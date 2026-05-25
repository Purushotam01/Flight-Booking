class FlightEndpoint {
  final String time;
  final String airportCode;
  final String city;

  const FlightEndpoint({
    required this.time,
    required this.airportCode,
    required this.city,
  });

  factory FlightEndpoint.fromJson(Map<String, dynamic> json) {
    return FlightEndpoint(
      time: json['time'] as String? ?? '',
      airportCode: json['airport_code'] as String? ?? '',
      city: json['city'] as String? ?? '',
    );
  }
}

class FlightPrice {
  final double amount;
  final String currency;

  const FlightPrice({required this.amount, required this.currency});

  factory FlightPrice.fromJson(Map<String, dynamic> json) {
    return FlightPrice(
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
    );
  }

  String get formatted => '\$$amount';
}

class FlightApiModel {
  final int id;
  final String airlineName;
  final String airlineLogo;
  final String flightNumber;
  final FlightEndpoint departure;
  final FlightEndpoint arrival;
  final String duration;
  final FlightPrice price;
  final String aircraftType;
  final int stops;
  final String? createdAt;
  final String? updatedAt;

  const FlightApiModel({
    required this.id,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.price,
    required this.aircraftType,
    required this.stops,
    this.createdAt,
    this.updatedAt,
  });

  factory FlightApiModel.fromJson(Map<String, dynamic> json) {
    return FlightApiModel(
      id: json['id'] as int? ?? 0,
      airlineName: json['airline_name'] as String? ?? '',
      airlineLogo: json['airline_logo'] as String? ?? '',
      flightNumber: json['flight_number'] as String? ?? '',
      departure: FlightEndpoint.fromJson(
        json['departure'] as Map<String, dynamic>? ?? {},
      ),
      arrival: FlightEndpoint.fromJson(
        json['arrival'] as Map<String, dynamic>? ?? {},
      ),
      duration: json['duration'] as String? ?? '',
      price: FlightPrice.fromJson(json['price'] as Map<String, dynamic>? ?? {}),
      aircraftType: json['aircraft_type'] as String? ?? '',
      stops: json['stops'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  String get departureTimeShort => formatTime(departure.time);

  String get arrivalTimeShort => formatTime(arrival.time);

  static String formatTime(String time) {
    if (time.isEmpty) return '';

    final parts = time.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return time;
  }
}
