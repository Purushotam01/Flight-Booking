import 'package:flight_booking/data/models/flight_model.dart';
import 'package:flight_booking/data/models/pagination_model.dart';
import 'package:flight_booking/data/repositories/flight_repository.dart';
import 'package:flight_booking/data/services/api_service.dart';
import 'package:flight_booking/view/home/viewmodel/home_controller.dart';
import 'package:flutter/material.dart';

class FlightResultViewModel extends ChangeNotifier {
  final FlightRepository repository;
  final String fromCode;
  final String toCode;
  final String fromCity;
  final String toCity;
  final String departureDate;
  final int passengerCount;
  FlightSearchFilters filters;

  FlightResultViewModel({
    required this.repository,
    required this.fromCode,
    required this.toCode,
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    required this.passengerCount,
    required this.filters,
    required List<FlightApiModel> initialFlights,
    required PaginationModel initialPagination,
  }) : _flights = List.of(initialFlights),
       _pagination = initialPagination;

  List<FlightApiModel> _flights;
  PaginationModel _pagination;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  List<FlightApiModel> get results => List.unmodifiable(_flights);
  PaginationModel get pagination => _pagination;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasResults => _flights.isNotEmpty;
  bool get hasNextPage => _pagination.hasNextPage;

  int get selectedFilter {
    switch (filters.sortBy) {
      case 'price_asc':
        return 0;
      case 'price_desc':
        return 1;
      case 'duration_asc':
        return 2;
      case 'departure_asc':
        return 3;
      default:
        return 0;
    }
  }

  final List<String> filterLabels = const [
    'Price ↑',
    'Price ↓',
    'Duration',
    'Departure',
  ];

  static const List<String> _sortValues = [
    'price_asc',
    'price_desc',
    'duration_asc',
    'departure_asc',
  ];

  void setFilter(int index) {
    final newSort = _sortValues[index];
    if (newSort == filters.sortBy) return;
    filters = filters.copyWith(sortBy: newSort);
    notifyListeners();
    _refreshFlights();
  }

  Future<void> _refreshFlights() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.searchFlights(
        from: fromCode,
        to: toCode,
        passengers: passengerCount,
        sortBy: filters.sortBy,
        airline: filters.airline,
        priceMin: filters.priceMin,
        priceMax: filters.priceMax,
        stops: filters.stops,
        aircraftType: filters.aircraftType,
        page: 1,
      );
      _flights = List.of(result.flights);
      _pagination = result.pagination;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load flights. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_pagination.hasNextPage) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await repository.searchFlights(
        from: fromCode,
        to: toCode,
        passengers: passengerCount,
        sortBy: filters.sortBy,
        airline: filters.airline,
        priceMin: filters.priceMin,
        priceMax: filters.priceMax,
        stops: filters.stops,
        aircraftType: filters.aircraftType,
        page: _pagination.currentPage + 1,
      );
      _flights.addAll(result.flights);
      _pagination = result.pagination;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load more flights.';
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> retry() => _refreshFlights();
}
