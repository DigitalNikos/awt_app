import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vienna_airport_taxi/data/models/booking_form_data.dart';

class BookingApiService {
  // API endpoints - matching your JavaScript configuration
  // static const String _baseUrl = 'https://awt.eu.pythonanywhere.com/';
  static const String _baseUrl = 'http://localhost:5001';

  static const String _ordersEndpoint = '$_baseUrl/orders';
  static const String _priceEndpoint = '$_baseUrl/public_calculate_price';

  // Timeout settings
  static const Duration _timeout = Duration(seconds: 30);

  // Retry settings
  static const int _maxRetries = 3;
  static const int _retryDelayMs = 1000;

  /// Calculate the price for the booking
  Future<double> calculatePrice(BookingFormData formData) async {
    int retries = 0;

    // Create a price calculation specific payload
    final pricePayload = {
      'city': formData.city ?? '',
      'pickup_address': {
        'postal_code': formData.postalCode ?? '',
        'street_and_number': formData.address ?? '',
      },
      'passenger_count': formData.passengerCount,
      'luggage_count': formData.luggageCount,
      'trip_type': formData.tripType,
      'round_trip': formData.roundTrip,
      'child_seat': formData.childSeat == 'None' ? 'None' : formData.childSeat,
      'nameplate_service': formData.nameplateService,
      'stops': formData.stops.map((stop) => stop.toJson()).toList(),
      // Provide a default date if not set - use today's date
      'date': formData.pickupDate != null
          ? '${formData.pickupDate!.year}-${formData.pickupDate!.month.toString().padLeft(2, '0')}-${formData.pickupDate!.day.toString().padLeft(2, '0')}'
          : '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
      'time': formData.pickupTime ?? '12:00',
      'flight_from': formData.flightFrom,
      'flight_number': formData.flightNumber,
    };

    while (retries < _maxRetries) {
      try {
        final response = await http
            .post(
              Uri.parse(_priceEndpoint),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: jsonEncode(pricePayload),
            )
            .timeout(_timeout);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final data = jsonDecode(response.body);

          // Handle different response formats
          if (data is Map<String, dynamic>) {
            // Check for price in various formats
            if (data['price'] != null) {
              final price = data['price'];
              if (price is String) {
                return double.tryParse(price) ?? 0.0;
              } else if (price is num) {
                return price.toDouble();
              }
            }
          }

          // Default to 0 if price cannot be determined
          return 0.0;
        } else if (response.statusCode == 429 || response.statusCode >= 500) {
          // Retry on rate limiting or server errors
          if (retries < _maxRetries - 1) {
            retries++;
            final delay =
                _retryDelayMs * (1 << (retries - 1)); // Exponential backoff
            await Future.delayed(Duration(milliseconds: delay));
            continue;
          }
        }

        // Handle error responses with more details
        try {
          final errorData = jsonDecode(response.body);
          print('API Error: $errorData');
          throw Exception(
              errorData['message'] ?? 'Server error: ${response.statusCode}');
        } catch (e) {
          print('Failed to parse error response: $e');
          throw Exception(
              'Server error: ${response.statusCode} ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Request error: $e');
        if (e is http.ClientException ||
            e.toString().contains('Failed to fetch')) {
          if (retries < _maxRetries - 1) {
            retries++;
            final delay =
                _retryDelayMs * (1 << (retries - 1)); // Exponential backoff
            await Future.delayed(Duration(milliseconds: delay));
            continue;
          }
        }

        if (retries >= _maxRetries - 1) {
          throw Exception('Network error after $retries retries: $e');
        }
      }
    }

    return 0.0; // Default fallback
  }

  /// Submit the booking form
  Future<BookingResponse> submitBooking(BookingFormData formData) async {
    int retries = 0;

    while (retries < _maxRetries) {
      try {
        final response = await http
            .post(
              Uri.parse(_ordersEndpoint),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: jsonEncode(formData.toJson()),
            )
            .timeout(_timeout);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          try {
            final data = jsonDecode(response.body);

            // Check if the response indicates success
            if (data is Map<String, dynamic>) {
              if (data['success'] == false) {
                throw Exception(data['message'] ?? 'Server indicated failure');
              }

              // Extract booking ID from various possible fields
              String bookingId = '';
              if (data['bookingId'] != null) {
                bookingId = data['bookingId'];
              } else if (data['id'] != null) {
                bookingId = 'TB-${data['id']}';
              } else if (data['order_id'] != null) {
                bookingId = 'TB-${data['order_id']}';
              } else {
                // Generate a random booking ID if none is provided
                bookingId = _generateOrderNumber();
              }

              return BookingResponse(
                success: true,
                bookingId: bookingId,
                message: data['message'] ?? 'Booking successful',
              );
            } else {
              // Handle non-object responses
              return BookingResponse(
                success: true,
                bookingId: _generateOrderNumber(),
                message: 'Booking successful',
              );
            }
          } catch (parseError) {
            // Handle non-JSON responses as success if status code is 2xx
            return BookingResponse(
              success: true,
              bookingId: _generateOrderNumber(),
              message: 'Booking successful',
            );
          }
        } else if (response.statusCode == 429 || response.statusCode >= 500) {
          // Retry on rate limiting or server errors
          if (retries < _maxRetries - 1) {
            retries++;
            final delay =
                _retryDelayMs * (1 << (retries - 1)); // Exponential backoff
            await Future.delayed(Duration(milliseconds: delay));
            continue;
          }
        }

        // Handle other error responses
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(
              errorData['message'] ?? 'Server error: ${response.statusCode}');
        } catch (parseError) {
          throw Exception(
              'Server error: ${response.statusCode} ${response.reasonPhrase}');
        }
      } catch (e) {
        if (e is http.ClientException ||
            e.toString().contains('Failed to fetch')) {
          if (retries < _maxRetries - 1) {
            retries++;
            final delay =
                _retryDelayMs * (1 << (retries - 1)); // Exponential backoff
            await Future.delayed(Duration(milliseconds: delay));
            continue;
          }
        }

        if (retries >= _maxRetries - 1) {
          // Provide user-friendly error messages
          if (e is http.ClientException ||
              e.toString().contains('Failed to fetch')) {
            throw Exception(
                'Verbindungsfehler. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.');
          } else if (e.toString().contains('timeout')) {
            throw Exception(
                'Die Anfrage hat zu lange gedauert. Bitte versuchen Sie es später erneut.');
          }
          rethrow;
        }
      }
    }

    return BookingResponse(
      success: false,
      bookingId: '',
      message: 'Unexpected error occurred',
    );
  }

  /// Generate a random order number
  String _generateOrderNumber() {
    final timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(6, 12);
    final random =
        (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
    return 'TB-$timestamp$random';
  }
}

class BookingResponse {
  final bool success;
  final String bookingId;
  final String message;

  BookingResponse({
    required this.success,
    required this.bookingId,
    required this.message,
  });
}
