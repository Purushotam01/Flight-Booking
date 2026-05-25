import 'flight_model.dart';

class FlightDetailApiModel {
  final FlightDetails flightDetails;
  final List<PassengerApiModel> passengers;
  final BookingInfo bookingInfo;

  const FlightDetailApiModel({
    required this.flightDetails,
    required this.passengers,
    required this.bookingInfo,
  });

  factory FlightDetailApiModel.fromJson(Map<String, dynamic> json) {
    return FlightDetailApiModel(
      flightDetails: FlightDetails.fromJson(
        json['flight_details'] as Map<String, dynamic>? ?? {},
      ),
      passengers:
          (json['passengers'] as List<dynamic>?)
              ?.map(
                (e) => PassengerApiModel.fromJson(
                  e as Map<String, dynamic>? ?? {},
                ),
              )
              .toList() ??
          [],
      bookingInfo: BookingInfo.fromJson(
        json['booking_info'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class FlightDetails {
  final int id;
  final String airlineName;
  final String airlineLogo;
  final String flightId;
  final String flightNumber;
  final FlightEndpoint departure;
  final FlightEndpoint arrival;
  final String duration;
  final String aircraftType;
  final int stops;
  final String terminal;
  final String gate;
  final String flightClass;

  const FlightDetails({
    required this.id,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightId,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.aircraftType,
    required this.stops,
    required this.terminal,
    required this.gate,
    required this.flightClass,
  });

  factory FlightDetails.fromJson(Map<String, dynamic> json) {
    return FlightDetails(
      id: json['id'] as int? ?? 0,
      airlineName: json['airline_name'] as String? ?? '',
      airlineLogo: json['airline_logo'] as String? ?? '',
      flightId: json['flight_id'] as String? ?? '',
      flightNumber: json['flight_number'] as String? ?? '',
      departure: FlightEndpoint.fromJson(
        json['departure'] as Map<String, dynamic>? ?? {},
      ),
      arrival: FlightEndpoint.fromJson(
        json['arrival'] as Map<String, dynamic>? ?? {},
      ),
      duration: json['duration'] as String? ?? '',
      aircraftType: json['aircraft_type'] as String? ?? '',
      stops: json['stops'] as int? ?? 0,
      terminal: json['terminal'] as String? ?? '',
      gate: json['gate'] as String? ?? '',
      flightClass: json['class'] as String? ?? '',
    );
  }

  String get departureTimeShort => FlightApiModel.formatTime(departure.time);

  String get arrivalTimeShort => FlightApiModel.formatTime(arrival.time);
}

class PassengerApiModel {
  final int passengerNumber;
  final String title;
  final String name;
  final String seat;
  final String profilePicture;

  const PassengerApiModel({
    required this.passengerNumber,
    required this.title,
    required this.name,
    required this.seat,
    required this.profilePicture,
  });

  factory PassengerApiModel.fromJson(Map<String, dynamic> json) {
    return PassengerApiModel(
      passengerNumber: json['passenger_number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      name: json['name'] as String? ?? '',
      seat: json['seat'] as String? ?? '',
      profilePicture: json['profile_picture'] as String? ?? '',
    );
  }

  String get fullName => '$title $name'.trim();

  String get label => 'PASSENGER $passengerNumber';
}

class BookingInfo {
  final int totalPassengers;
  final String bookingReference;
  final String bookingDate;
  final String barcode;

  const BookingInfo({
    required this.totalPassengers,
    required this.bookingReference,
    required this.bookingDate,
    required this.barcode,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      totalPassengers: json['total_passengers'] as int? ?? 0,
      bookingReference: json['booking_reference'] as String? ?? '',
      bookingDate: json['booking_date'] as String? ?? '',
      barcode: json['barcode'] as String? ?? '',
    );
  }
}
