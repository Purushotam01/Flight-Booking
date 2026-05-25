class AirportModel {
  final String airportCode;
  final String city;
  final int flightCount;

  const AirportModel({
    required this.airportCode,
    required this.city,
    required this.flightCount,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      airportCode: json['airport_code'] as String? ?? '',
      city: json['city'] as String? ?? '',
      flightCount: json['flight_count'] as int? ?? 0,
    );
  }

  String get displayLabel => '$city ($airportCode)';
}
