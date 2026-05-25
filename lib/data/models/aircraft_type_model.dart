class AircraftTypeModel {
  final String aircraft;

  const AircraftTypeModel({required this.aircraft});

  factory AircraftTypeModel.fromJson(Map<String, dynamic> json) {
    return AircraftTypeModel(aircraft: json['aircraft'] as String? ?? '');
  }
}
