import 'package:flight_booking/data/models/aircraft_type_model.dart';
import 'package:flight_booking/data/models/airline_model.dart';
import 'package:flight_booking/data/models/airport_model.dart';
import 'package:flight_booking/data/models/flight_detail_model.dart';
import 'package:flight_booking/data/models/flight_model.dart';
import 'package:flight_booking/data/models/pagination_model.dart';
import 'package:flight_booking/data/services/api_service.dart';
import 'package:flight_booking/data/services/connectivity_service.dart';

class FlightRepository {
  final ApiService _api;
  final ConnectivityService _connectivity;

  FlightRepository({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _api = apiService,
       _connectivity = connectivityService;

  Future<void> _ensureConnected() async {
    if (!await _connectivity.isConnected) {
      throw const ApiException(
        message: 'No internet connection. Please check your network.',
      );
    }
  }

  Future<FlightSearchResult> searchFlights({
    required String from,
    required String to,
    int passengers = 1,
    String sortBy = 'price_asc',
    String? airline,
    double? priceMin,
    double? priceMax,
    int? stops,
    String? aircraftType,
    int page = 1,
    int limit = 10,
  }) async {
    await _ensureConnected();

    final json = await _api.searchFlights(
      from: from,
      to: to,
      passengers: passengers,
      sortBy: sortBy,
      airline: airline,
      priceMin: priceMin,
      priceMax: priceMax,
      stops: stops,
      aircraftType: aircraftType,
      page: page,
      limit: limit,
    );

    final data = json['data'] as Map<String, dynamic>? ?? {};
    final flights =
        (data['flights'] as List<dynamic>?)
            ?.map((e) => FlightApiModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pagination = PaginationModel.fromJson(
      data['pagination'] as Map<String, dynamic>? ?? {},
    );

    return FlightSearchResult(flights: flights, pagination: pagination);
  }

  Future<FlightSearchResult> getFlightList({
    String sortBy = 'price_asc',
    int page = 1,
    int limit = 10,
    String? airline,
    double? priceMin,
    double? priceMax,
    int? stops,
    String? aircraftType,
  }) async {
    await _ensureConnected();

    final json = await _api.getFlightList(
      sortBy: sortBy,
      page: page,
      limit: limit,
      airline: airline,
      priceMin: priceMin,
      priceMax: priceMax,
      stops: stops,
      aircraftType: aircraftType,
    );

    final data = json['data'] as Map<String, dynamic>? ?? {};
    final flights =
        (data['flights'] as List<dynamic>?)
            ?.map((e) => FlightApiModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pagination = PaginationModel.fromJson(
      data['pagination'] as Map<String, dynamic>? ?? {},
    );

    return FlightSearchResult(flights: flights, pagination: pagination);
  }

  Future<FlightDetailApiModel> getFlightDetails(int id) async {
    await _ensureConnected();

    final json = await _api.getFlightDetails(id);
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return FlightDetailApiModel.fromJson(data);
  }

  Future<AirportListResult> getDepartureAirports({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    await _ensureConnected();

    final json = await _api.getDepartureAirports(
      search: search,
      page: page,
      limit: limit,
    );

    final data = json['data'] as Map<String, dynamic>? ?? {};
    final airports =
        (data['airports'] as List<dynamic>?)
            ?.map((e) => AirportModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pagination = PaginationModel.fromJson(
      data['pagination'] as Map<String, dynamic>? ?? {},
    );

    return AirportListResult(airports: airports, pagination: pagination);
  }

  Future<AirportListResult> getArrivalAirports({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    await _ensureConnected();

    final json = await _api.getArrivalAirports(
      search: search,
      page: page,
      limit: limit,
    );

    final data = json['data'] as Map<String, dynamic>? ?? {};
    final airports =
        (data['airports'] as List<dynamic>?)
            ?.map((e) => AirportModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pagination = PaginationModel.fromJson(
      data['pagination'] as Map<String, dynamic>? ?? {},
    );

    return AirportListResult(airports: airports, pagination: pagination);
  }

  Future<AirlineListResult> getAirlines({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    await _ensureConnected();

    final json = await _api.getAirlines(
      search: search,
      page: page,
      limit: limit,
    );

    final data = json['data'] as Map<String, dynamic>? ?? {};
    final airlines =
        (data['airlines'] as List<dynamic>?)
            ?.map((e) => AirlineModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pagination = PaginationModel.fromJson(
      data['pagination'] as Map<String, dynamic>? ?? {},
    );

    return AirlineListResult(airlines: airlines, pagination: pagination);
  }

  Future<AircraftTypeListResult> getAircraftTypes({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    await _ensureConnected();

    final json = await _api.getAircraftTypes(
      search: search,
      page: page,
      limit: limit,
    );

    final data = json['data'] as Map<String, dynamic>? ?? {};
    final types =
        (data['aircraft_types'] as List<dynamic>?)
            ?.map((e) => AircraftTypeModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pagination = PaginationModel.fromJson(
      data['pagination'] as Map<String, dynamic>? ?? {},
    );

    return AircraftTypeListResult(aircraftTypes: types, pagination: pagination);
  }
}

class FlightSearchResult {
  final List<FlightApiModel> flights;
  final PaginationModel pagination;

  const FlightSearchResult({required this.flights, required this.pagination});
}

class AirportListResult {
  final List<AirportModel> airports;
  final PaginationModel pagination;

  const AirportListResult({required this.airports, required this.pagination});
}

class AirlineListResult {
  final List<AirlineModel> airlines;
  final PaginationModel pagination;

  const AirlineListResult({required this.airlines, required this.pagination});
}

class AircraftTypeListResult {
  final List<AircraftTypeModel> aircraftTypes;
  final PaginationModel pagination;

  const AircraftTypeListResult({
    required this.aircraftTypes,
    required this.pagination,
  });
}
