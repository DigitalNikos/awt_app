// lib/data/models/booking_form_data.dart

class StopoverLocation {
  final String postalCode;
  final String address;

  const StopoverLocation({
    required this.postalCode,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'postal_code': postalCode,
        'street_and_number': address,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopoverLocation &&
          runtimeType == other.runtimeType &&
          postalCode == other.postalCode &&
          address == other.address;

  @override
  int get hashCode => postalCode.hashCode ^ address.hashCode;
}

class BookingFormData {
  // Step 1 fields
  final String? city;
  final String? postalCode;
  final String? address;
  final DateTime? pickupDate;
  final String? pickupTime;
  final int passengerCount;
  final int luggageCount;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;

  // Step 2 fields
  final bool roundTrip;
  final DateTime? returnDate;
  final String? returnTime;
  final String? flightFrom;
  final String? flightNumber;
  final String childSeat;
  final bool nameplateService;
  final List<StopoverLocation> stops;
  final String paymentMethod;
  final String? comment;

  // Additional fields
  final String tripType;
  final double? price;

  BookingFormData({
    this.city,
    this.postalCode,
    this.address,
    this.pickupDate,
    this.pickupTime,
    this.passengerCount = 1,
    this.luggageCount = 0,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.roundTrip = false,
    this.returnDate,
    this.returnTime,
    this.flightFrom,
    this.flightNumber,
    this.childSeat = 'None',
    this.nameplateService = false,
    this.stops = const [],
    this.paymentMethod = 'cash',
    this.comment,
    this.tripType = 'to_airport',
    this.price,
  });

  BookingFormData copyWith({
    String? city,
    String? postalCode,
    String? address,
    DateTime? pickupDate,
    String? pickupTime,
    int? passengerCount,
    int? luggageCount,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    bool? roundTrip,
    DateTime? returnDate,
    String? returnTime,
    String? flightFrom,
    String? flightNumber,
    String? childSeat,
    bool? nameplateService,
    List<StopoverLocation>? stops,
    String? paymentMethod,
    String? comment,
    String? tripType,
    double? price,
  }) {
    return BookingFormData(
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      address: address ?? this.address,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
      passengerCount: passengerCount ?? this.passengerCount,
      luggageCount: luggageCount ?? this.luggageCount,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      roundTrip: roundTrip ?? this.roundTrip,
      returnDate: returnDate ?? this.returnDate,
      returnTime: returnTime ?? this.returnTime,
      flightFrom: flightFrom ?? this.flightFrom,
      flightNumber: flightNumber ?? this.flightNumber,
      childSeat: childSeat ?? this.childSeat,
      nameplateService: nameplateService ?? this.nameplateService,
      stops: stops ?? this.stops,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      comment: comment ?? this.comment,
      tripType: tripType ?? this.tripType,
      price: price ?? this.price,
    );
  }

  // Convert pickup date and time to DateTime object for API
  DateTime? get pickupDatetime {
    if (pickupDate == null || pickupTime == null) return null;

    final timeParts = pickupTime!.split(':');
    if (timeParts.length != 2) return null;

    final hours = int.tryParse(timeParts[0]) ?? 0;
    final minutes = int.tryParse(timeParts[1]) ?? 0;

    return DateTime(
      pickupDate!.year,
      pickupDate!.month,
      pickupDate!.day,
      hours,
      minutes,
    );
  }

  // Convert return date and time to DateTime object for API
  DateTime? get returnDatetime {
    if (returnDate == null || returnTime == null) return null;

    final timeParts = returnTime!.split(':');
    if (timeParts.length != 2) return null;

    final hours = int.tryParse(timeParts[0]) ?? 0;
    final minutes = int.tryParse(timeParts[1]) ?? 0;

    return DateTime(
      returnDate!.year,
      returnDate!.month,
      returnDate!.day,
      hours,
      minutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_type': tripType,
      'pickup_datetime': pickupDatetime?.toIso8601String(),
      'return_datetime': returnDatetime?.toIso8601String(),
      'city': city,
      'pickup_address': {
        'postal_code': postalCode ?? '',
        'street_and_number': address ?? '',
      },
      'stops': stops.map((stop) => stop.toJson()).toList(),
      'passenger_count': passengerCount,
      'luggage_count': luggageCount,
      'round_trip': roundTrip,
      'flight_from': flightFrom,
      'flight_number': flightNumber,
      'child_seat': childSeat,
      'nameplate_service': nameplateService,
      'note': comment,
      'payment_method': paymentMethod,
      'language': 'GERMAN', // You can make this dynamic later
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'request_price': price,
    };
  }
}
