import 'package:flight_booking/data/models/flight_detail_model.dart';
import 'package:flight_booking/data/repositories/flight_repository.dart';
import 'package:flight_booking/data/services/api_service.dart';
import 'package:flutter/material.dart';

class PassengerInfo {
  final String name;
  final String label;
  final String seat;
  final String avatarUrl;

  const PassengerInfo({
    required this.name,
    required this.label,
    required this.seat,
    required this.avatarUrl,
  });
}

class FlightDetailsViewModel extends ChangeNotifier {
  final FlightRepository _repository;
  final int flightId;

  FlightDetailsViewModel({
    required FlightRepository repository,
    required this.flightId,
  }) : _repository = repository {
    _loadDetails();
  }

  bool _isLoading = true;
  String? _errorMessage;
  FlightDetailApiModel? _details;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _details != null;

  String get airlineName => _details?.flightDetails.airlineName ?? '';
  String get logoUrl => _details?.flightDetails.airlineLogo ?? '';
  String get departureTime => _details?.flightDetails.departureTimeShort ?? '';
  String get arrivalTime => _details?.flightDetails.arrivalTimeShort ?? '';
  String get departureCode =>
      _details?.flightDetails.departure.airportCode ?? '';
  String get arrivalCode => _details?.flightDetails.arrival.airportCode ?? '';
  String get departureCity => _details?.flightDetails.departure.city ?? '';
  String get arrivalCity => _details?.flightDetails.arrival.city ?? '';
  String get duration => _details?.flightDetails.duration ?? '';
  String get bookingId => _details?.bookingInfo.bookingReference ?? '';
  String get terminal => _details?.flightDetails.terminal ?? '';
  String get gate => _details?.flightDetails.gate ?? '';
  String get flightClass => _details?.flightDetails.flightClass ?? '';

  List<PassengerInfo> get passengers {
    if (_details == null) return [];
    return _details!.passengers
        .map(
          (p) => PassengerInfo(
            name: p.fullName,
            label: p.label,
            seat: p.seat,
            avatarUrl: p.profilePicture,
          ),
        )
        .toList();
  }

  Future<void> _loadDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _details = await _repository.getFlightDetails(flightId);
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load flight details.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => _loadDetails();
}
