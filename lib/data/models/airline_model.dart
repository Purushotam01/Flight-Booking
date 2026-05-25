class AirlineModel {
  final String airline;

  const AirlineModel({required this.airline});

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    return AirlineModel(airline: json['airline'] as String? ?? '');
  }
}
