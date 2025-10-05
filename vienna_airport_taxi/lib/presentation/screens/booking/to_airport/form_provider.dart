import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/data/models/booking_form_data.dart';
import 'package:vienna_airport_taxi/data/services/booking_api_service.dart';
import 'package:vienna_airport_taxi/data/services/form_validation_service.dart';
import 'package:vienna_airport_taxi/presentation/screens/success/success_screen.dart';
import 'package:vienna_airport_taxi/presentation/screens/error/error_screen.dart';
import 'package:vienna_airport_taxi/data/services/auth_service.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class ToAirportFormProvider with ChangeNotifier {
  // Instance of AuthService
  final AuthService _authService = AuthService();

  // Form data - NOT final, so we can replace it with new instances
  BookingFormData _formData = BookingFormData();
  BookingFormData get formData => _formData;

  // Track if luggage has been explicitly selected
  bool _hasSelectedLuggage = false;
  bool get hasSelectedLuggage => _hasSelectedLuggage;

  // Zwischenstopp panel state tracking
  bool _hasOpenStopoverPanel = false;
  bool get hasOpenStopoverPanel => _hasOpenStopoverPanel;

  // Current step (0-indexed)
  int _currentStep = 0;
  int get currentStep => _currentStep;

  // API service
  final BookingApiService _apiService = BookingApiService();

  // State management
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCalculatingPrice = false;
  bool get isCalculatingPrice => _isCalculatingPrice;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _priceErrorMessage;
  String? get priceErrorMessage => _priceErrorMessage;

  // Price calculation debounce
  Timer? _priceCalculationTimer;

  bool _termsAccepted = false;
  bool get termsAccepted => _termsAccepted;

  // Validation errors
  final Map<String, String?> _validationErrors = {};
  Map<String, String?> get validationErrors => Map.from(_validationErrors);

  // Helper method to clear specific field errors when user starts typing
  void _clearFieldError(String fieldKey) {
    if (_validationErrors.containsKey(fieldKey)) {
      _validationErrors.remove(fieldKey);
    }
  }

  ToAirportFormProvider() {
    // Use copyWith to set the tripType
    _formData = _formData.copyWith(tripType: 'to_airport');
    // Initialize with 0 passengers and luggage (will show placeholders)
    _formData = _formData.copyWith(passengerCount: 0, luggageCount: 0);
  }

  // Navigation methods
  void goToStep(int step) {
    if (step >= 0 && step < 3) {
      _currentStep = step;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Form data manipulation methods - all using copyWith

  // UPDATED: Date and time changes NO LONGER trigger price calculation
  void updatePickupDate(DateTime? date) {
    _clearFieldError('date');
    _clearFieldError('reservationTime'); // Also clear reservation time error
    _formData = _formData.copyWith(pickupDate: date);
    // Removed: _debouncePriceCalculation();
    notifyListeners();
  }

  void updatePickupTime(String? time) {
    _clearFieldError('time');
    _clearFieldError('reservationTime'); // Also clear reservation time error
    _formData = _formData.copyWith(pickupTime: time);
    // Removed: _debouncePriceCalculation();
    notifyListeners();
  }

  // UPDATED: City changes trigger price calculation
  void updateCity(String? city) {
    _clearFieldError('city');
    print('updateCity called with: $city');
    print('Previous city was: ${_formData.city}');
    print('Previous price was: ${_formData.price}');

    if (city != 'Wien') {
      print(
          'Non-Vienna city selected, clearing postal code and calculating price');
      _formData = _formData.copyWith(
        city: city,
        postalCode: null,
      );
      // For non-Vienna cities, calculate price immediately
      _debouncePriceCalculation();
    } else {
      print('Vienna selected, clearing postal code and price');
      // For Vienna, create a new BookingFormData with null price
      _formData = BookingFormData(
        tripType: _formData.tripType,
        city: city,
        postalCode: null,
        address: _formData.address,
        pickupDate: _formData.pickupDate,
        pickupTime: _formData.pickupTime,
        passengerCount: _formData.passengerCount,
        luggageCount: _formData.luggageCount,
        customerName: _formData.customerName,
        customerEmail: _formData.customerEmail,
        customerPhone: _formData.customerPhone,
        childSeat: _formData.childSeat,
        nameplateService: _formData.nameplateService,
        paymentMethod: _formData.paymentMethod,
        comment: _formData.comment,
        roundTrip: _formData.roundTrip,
        returnDate: _formData.returnDate,
        returnTime: _formData.returnTime,
        flightFrom: _formData.flightFrom,
        flightNumber: _formData.flightNumber,
        stops: _formData.stops,
        price: null, // Explicitly set to null
      );
      _priceErrorMessage = null;

      // Cancel any pending price calculation
      _priceCalculationTimer?.cancel();

      print('After clearing - price is now: ${_formData.price}');
    }

    notifyListeners();
  }

  // UPDATED: Postal code changes trigger price calculation
  void updatePostalCode(String? postalCode) {
    _clearFieldError('postalCode');
    print('updatePostalCode called with: $postalCode');
    _formData = _formData.copyWith(postalCode: postalCode);
    _debouncePriceCalculation(); // Calculate price when postal code changes
    notifyListeners();
  }

  // UPDATED: Address changes NO LONGER trigger price calculation
  void updateAddress(String? address) {
    _clearFieldError('address');
    _formData = _formData.copyWith(address: address);
    // Removed: _debouncePriceCalculation();
    notifyListeners();
  }

  // UPDATED: Passenger count changes trigger price calculation
  void updatePassengerCount(int count) {
    _clearFieldError('passengers');
    _formData = _formData.copyWith(passengerCount: count);
    _debouncePriceCalculation(); // Calculate price when passengers change
    notifyListeners();
  }

  // UPDATED: Luggage count changes trigger price calculation
  void updateLuggageCount(int count) {
    _clearFieldError('luggage');
    _formData = _formData.copyWith(luggageCount: count);
    _hasSelectedLuggage = true; // Mark as explicitly selected
    _debouncePriceCalculation(); // Calculate price when luggage changes
    notifyListeners();
  }

  void updateCustomerName(String? name) {
    _clearFieldError('name');
    _formData = _formData.copyWith(customerName: name);
    notifyListeners();
  }

  void updateCustomerEmail(String? email) {
    _clearFieldError('email');
    _formData = _formData.copyWith(customerEmail: email);
    notifyListeners();
  }

  void updateCustomerPhone(String? phone) {
    _clearFieldError('phone');
    _formData = _formData.copyWith(customerPhone: phone);
    notifyListeners();
  }

  void updateChildSeat(String childSeat) {
    _clearFieldError('childSeat'); // Clear error immediately
    _formData = _formData.copyWith(childSeat: childSeat);
    _debouncePriceCalculation();
    notifyListeners();
  }

  void updateNameplateService(bool isEnabled) {
    _formData = _formData.copyWith(nameplateService: isEnabled);
    _debouncePriceCalculation();
    notifyListeners();
  }

  void updatePaymentMethod(String method) {
    _formData = _formData.copyWith(paymentMethod: method);
    notifyListeners();
  }

  void updateComment(String? comment) {
    _formData = _formData.copyWith(comment: comment);
    notifyListeners();
  }

  void updateRoundTrip(bool isEnabled) {
    if (!isEnabled) {
      // Clear return trip data
      _formData = _formData.copyWith(
        roundTrip: isEnabled,
        returnDate: null,
        returnTime: null,
        flightFrom: null,
        flightNumber: null,
      );
    } else {
      _formData = _formData.copyWith(roundTrip: isEnabled);
    }
    _debouncePriceCalculation();
    notifyListeners();
  }

  void updateReturnDate(DateTime? date) {
    _clearFieldError('returnDate');
    _clearFieldError('returnDateTime'); // Clear combined validation error
    _clearFieldError('returnReservationTime'); // Clear return reservation error
    _formData = _formData.copyWith(returnDate: date);
    _debouncePriceCalculation();
    notifyListeners();
  }

  void updateReturnTime(String? time) {
    _clearFieldError('returnTime');
    _clearFieldError('returnDateTime'); // Clear combined validation error
    _clearFieldError('returnReservationTime'); // Clear return reservation error
    _formData = _formData.copyWith(returnTime: time);
    _debouncePriceCalculation();
    notifyListeners();
  }

  void updateFlightFrom(String? flightFrom) {
    _clearFieldError('flightFrom');
    _formData = _formData.copyWith(flightFrom: flightFrom);
    _debouncePriceCalculation();
    notifyListeners();
  }

  void updateFlightNumber(String? flightNumber) {
    _clearFieldError('flightNumber');
    _formData = _formData.copyWith(flightNumber: flightNumber);
    _debouncePriceCalculation();
    notifyListeners();
  }

  // Stopover management
  void addStopover(String postalCode, String address) {
    _clearFieldError('stopover'); // Clear stopover error when adding
    final newStopover = StopoverLocation(
      postalCode: postalCode,
      address: address,
    );
    final updatedStops = [..._formData.stops, newStopover];
    _formData = _formData.copyWith(stops: updatedStops);
    _debouncePriceCalculation();
    notifyListeners();
  }

  void removeStopover(int index) {
    _clearFieldError('stopover'); // Clear stopover error when removing
    if (index >= 0 && index < _formData.stops.length) {
      final updatedStops = [..._formData.stops];
      updatedStops.removeAt(index);
      _formData = _formData.copyWith(stops: updatedStops);
      _debouncePriceCalculation();
      notifyListeners();
    }
  }

  void clearStopovers() {
    _formData = _formData.copyWith(stops: []);
    _debouncePriceCalculation();
    notifyListeners();
  }

  // Methods to track Zwischenstopp panel state
  void setStopoverPanelOpen(bool isOpen) {
    _hasOpenStopoverPanel = isOpen;
    if (!isOpen) {
      _clearFieldError('stopover'); // Clear error when panel is closed
    }
    notifyListeners();
  }

  void validateStopoverPanel(bool hasUnaddedData) {
    if (hasUnaddedData) {
      _validationErrors['stopover'] =
          'Bitte fügen Sie den Zwischenstopp zur Liste hinzu oder schließen Sie das Panel.';
    } else {
      _clearFieldError('stopover');
      _clearFieldError('stopoverAddress');
      _clearFieldError('stopoverPostalCode');
    }
    notifyListeners();
  }

  // Method to validate individual stopover fields
  void validateStopoverFields(String? postalCode, String address) {
    // Clear previous individual field errors
    _clearFieldError('stopoverAddress');
    _clearFieldError('stopoverPostalCode');

    bool hasData =
        (postalCode != null && postalCode.isNotEmpty) || address.isNotEmpty;

    if (hasData) {
      // If user has started filling, validate individual fields
      if (postalCode == null || postalCode.isEmpty) {
        _validationErrors['stopoverPostalCode'] = 'PLZ ist erforderlich';
      }
      if (address.isEmpty) {
        _validationErrors['stopoverAddress'] = 'Adresse ist erforderlich';
      }
    }

    notifyListeners();
  }

  // Price calculation
  void _debouncePriceCalculation() {
    print('_debouncePriceCalculation called');

    // Cancel existing timer
    _priceCalculationTimer?.cancel();

    // Start new timer
    _priceCalculationTimer = Timer(const Duration(milliseconds: 500), () {
      print('Debounce timer expired, checking if we can calculate price...');
      if (_canCalculatePrice()) {
        calculatePrice();
      }
    });
  }

  // UPDATED: New price calculation logic - only requires city/postal code
  bool _canCalculatePrice() {
    // Debug logging
    print('_canCalculatePrice check:');
    print('  city: ${_formData.city}');
    print('  postalCode: ${_formData.postalCode}');

    // NEW LOGIC: Only require city (+ postal code if Vienna)
    // Note: passenger_count can be 0 in UI (API service will send minimum 1)
    final canCalculate = _formData.city != null &&
        _formData.city!.isNotEmpty &&
        (_formData.city != 'Wien' ||
            (_formData.postalCode != null && _formData.postalCode!.isNotEmpty));

    print('  result: $canCalculate');
    return canCalculate;
  }

  Future<void> calculatePrice() async {
    print('calculatePrice called');
    if (_isCalculatingPrice) {
      print('Already calculating price, returning');
      return;
    }

    if (!_canCalculatePrice()) {
      print('Cannot calculate price, setting to null');
      _formData = _formData.copyWith(price: null);
      _priceErrorMessage = null;
      notifyListeners();
      return;
    }

    print('Starting price calculation...');
    _isCalculatingPrice = true;
    _priceErrorMessage = null;
    notifyListeners();

    try {
      final price = await _apiService.calculatePrice(_formData);
      print('Price calculated: $price');
      _formData = _formData.copyWith(price: price);

      // If price is 0 and it's Wien, it might be a missing price in database
      if (price == 0 && _formData.city == 'Wien') {
        _priceErrorMessage =
            'Preis für diese PLZ nicht verfügbar. Bitte kontaktieren Sie uns.';
      }
    } catch (e) {
      print('Error calculating price: $e');
      // Keep the last valid price if there's an error
      _priceErrorMessage =
          'Fehler bei der Preisberechnung. Bitte versuchen Sie es erneut.';
    } finally {
      _isCalculatingPrice = false;
      notifyListeners();
    }
  }

  // Validation
  bool validateStep(int step, BuildContext context) {
    // _validationErrors.clear();

    final localizations = AppLocalizations.of(context);

    switch (step) {
      case 0: // Step 1 validation
        return _validateStep1(localizations);
      case 1: // Step 2 validation
        return _validateStep2(localizations);
      case 2: // Step 3 validation
        return _validateStep3(localizations);
      default:
        return false;
    }
  }

  // UPDATED: Step 1 validation - still requires all fields for form submission
  bool _validateStep1(AppLocalizations localizations) {
    bool isValid = true;
    _validationErrors.clear();

    // Date validation - REQUIRED for form submission
    final dateValidation =
        FormValidationService.validateDate(_formData.pickupDate, localizations);
    if (!dateValidation.isValid) {
      _validationErrors['date'] = dateValidation.errorMessage;
      isValid = false;
    }

    // Time validation - REQUIRED for form submission
    final timeValidation = FormValidationService.validateTime(
        _formData.pickupTime, localizations, _formData.pickupDate);
    if (!timeValidation.isValid) {
      _validationErrors['time'] = timeValidation.errorMessage;
      isValid = false;
    }

    // City validation - REQUIRED for both price calculation and form submission
    final cityValidation = FormValidationService.validateCity(_formData.city);
    if (!cityValidation.isValid) {
      _validationErrors['city'] = cityValidation.errorMessage;
      isValid = false;
    }

    // Postal code validation - REQUIRED for Vienna
    final postalCodeValidation = FormValidationService.validatePostalCode(
        _formData.postalCode, _formData.city);
    if (!postalCodeValidation.isValid) {
      _validationErrors['postalCode'] = postalCodeValidation.errorMessage;
      isValid = false;
    }

    // Address validation - REQUIRED for form submission
    final addressValidation =
        FormValidationService.validateAddress(_formData.address);
    if (!addressValidation.isValid) {
      _validationErrors['address'] = addressValidation.errorMessage;
      isValid = false;
    }

    // Passenger validation - REQUIRED (must be > 0)
    if (_formData.passengerCount <= 0) {
      _validationErrors['passengers'] =
          'Bitte wählen Sie die Anzahl der Personen';
      isValid = false;
    }

    // Luggage validation - REQUIRED (must be explicitly selected)
    if (!_hasSelectedLuggage) {
      _validationErrors['luggage'] = 'Bitte wählen Sie die Anzahl der Koffer';
      isValid = false;
    }

    // RESERVATION TIME VALIDATION (Reservierungsfristen)
    final reservationTimeValidation =
        FormValidationService.validateReservationTime(
            _formData.pickupDate, _formData.pickupTime);
    if (!reservationTimeValidation.isValid) {
      _validationErrors['reservationTime'] =
          reservationTimeValidation.errorMessage;
      isValid = false;
    }

    // Contact information validation (only for non-authenticated users)
    if (_authService.currentUser == null) {
      // Name validation
      final nameValidation =
          FormValidationService.validateName(_formData.customerName);
      if (!nameValidation.isValid) {
        _validationErrors['name'] = nameValidation.errorMessage;
        isValid = false;
      }

      // Email validation
      final emailValidation =
          FormValidationService.validateEmail(_formData.customerEmail);
      if (!emailValidation.isValid) {
        _validationErrors['email'] = emailValidation.errorMessage;
        isValid = false;
      }

      // Phone validation
      final phoneValidation =
          FormValidationService.validatePhone(_formData.customerPhone);
      if (!phoneValidation.isValid) {
        _validationErrors['phone'] = phoneValidation.errorMessage;
        isValid = false;
      }
    }
    notifyListeners();
    return isValid;
  }

  bool _validateStep2(AppLocalizations localizations) {
    bool isValid = true;

    // If return trip is enabled, validate return trip fields
    if (_formData.roundTrip) {
      // Return date validation
      final returnDateValidation = FormValidationService.validateDate(
          _formData.returnDate, localizations);
      if (!returnDateValidation.isValid) {
        _validationErrors['returnDate'] = returnDateValidation.errorMessage;
        isValid = false;
      }

      // Return time validation
      final returnTimeValidation = FormValidationService.validateTime(
          _formData.returnTime, localizations, _formData.returnDate);
      if (!returnTimeValidation.isValid) {
        _validationErrors['returnTime'] = returnTimeValidation.errorMessage;
        isValid = false;
      }

      // RETURN TRIP DATETIME VALIDATION (Return must be after pickup)
      final returnDateTimeValidation =
          FormValidationService.validateReturnDateTime(_formData.pickupDate,
              _formData.pickupTime, _formData.returnDate, _formData.returnTime);
      if (!returnDateTimeValidation.isValid) {
        _validationErrors['returnDateTime'] =
            returnDateTimeValidation.errorMessage;
        isValid = false;
      }

      // RETURN TRIP RESERVATION TIME VALIDATION
      final returnReservationTimeValidation =
          FormValidationService.validateReservationTime(
              _formData.returnDate, _formData.returnTime);
      if (!returnReservationTimeValidation.isValid) {
        _validationErrors['returnReservationTime'] =
            returnReservationTimeValidation.errorMessage;
        isValid = false;
      }
    }

    // ZWISCHENSTOPP PANEL VALIDATION (Check for open panel with unfilled data)
    if (_hasOpenStopoverPanel && _formData.city == 'Wien') {
      _validationErrors['stopover'] =
          'Bitte fügen Sie den Zwischenstopp zur Liste hinzu oder schließen Sie das Panel.';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  bool _validateStep3(AppLocalizations localizations) {
    bool isValid = true;

    // This validation is handled by the terms checkbox widget
    // The checkbox must be checked before proceeding

    notifyListeners();
    return isValid;
  }

  void toggleTermsAccepted() {
    _termsAccepted = !_termsAccepted;
    notifyListeners();
  }

// Update the submitForm method
  Future<bool> submitForm(BuildContext context) async {
    // Final validation
    if (!validateStep(2, context)) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.submitBooking(_formData);

      if (response.success) {
        // Navigate to success screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              bookingId: response.bookingId ??
                  'TB-${DateTime.now().millisecondsSinceEpoch}',
              userEmail: _formData.customerEmail,
            ),
          ),
        );
        return true;
      } else {
        // Navigate to error screen with specific error message
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ErrorScreen(
              errorMessage:
                  response.message ?? 'Ein unbekannter Fehler ist aufgetreten.',
              onRetry: () {
                Navigator.of(context).pop(); // Go back to form
                submitForm(context); // Try again
              },
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      // Navigate to error screen with generic error message
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ErrorScreen(
            errorMessage:
                'Verbindungsfehler. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.',
            onRetry: () {
              Navigator.of(context).pop(); // Go back to form
              submitForm(context); // Try again
            },
          ),
        ),
      );
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Error handling
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearValidationError(String field) {
    _validationErrors.remove(field);
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    _priceCalculationTimer?.cancel();
    super.dispose();
  }
}
