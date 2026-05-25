import 'package:flight_booking/data/models/airport_model.dart';
import 'package:flight_booking/data/repositories/flight_repository.dart';
import 'package:flight_booking/data/services/api_service.dart';
import 'package:flight_booking/view/result/view/flight_result_view.dart';
import 'package:flutter/material.dart';

class FlightSearchFilters {
  final String? airline;
  final double? priceMin;
  final double? priceMax;
  final int? stops;
  final String? aircraftType;
  final String sortBy;

  const FlightSearchFilters({
    this.airline,
    this.priceMin,
    this.priceMax,
    this.stops,
    this.aircraftType,
    this.sortBy = 'price_asc',
  });

  FlightSearchFilters copyWith({
    String? airline,
    double? priceMin,
    double? priceMax,
    int? stops,
    String? aircraftType,
    String? sortBy,
    bool clearAirline = false,
    bool clearStops = false,
    bool clearAircraftType = false,
    bool clearPriceMin = false,
    bool clearPriceMax = false,
  }) {
    return FlightSearchFilters(
      airline: clearAirline ? null : (airline ?? this.airline),
      priceMin: clearPriceMin ? null : (priceMin ?? this.priceMin),
      priceMax: clearPriceMax ? null : (priceMax ?? this.priceMax),
      stops: clearStops ? null : (stops ?? this.stops),
      aircraftType: clearAircraftType
          ? null
          : (aircraftType ?? this.aircraftType),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class FlightModel {
  final String airlineName;
  final String departureTime;
  final String arrivalTime;
  final String departureCode;
  final String arrivalCode;
  final String departureCity;
  final String arrivalCity;
  final String duration;
  final String date;

  const FlightModel({
    required this.airlineName,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureCode,
    required this.arrivalCode,
    required this.departureCity,
    required this.arrivalCity,
    required this.duration,
    required this.date,
  });
}

class HomeViewModel extends ChangeNotifier {
  final FlightRepository _repository;

  HomeViewModel({required FlightRepository repository})
    : _repository = repository {
    loadSavedTrips();
  }

  String _fromCode = 'CGK';
  String _fromCity = 'Jakarta';
  String _toCode = 'NRT';
  String _toCity = 'Tokyo';
  String _departureDate = 'Tue, 2 Apr';
  int _passengerCount = 1;
  bool _isSearching = false;
  int _selectedNavIndex = 0;

  FlightSearchFilters _filters = const FlightSearchFilters();

  String get fromLocation => '$_fromCity ($_fromCode)';
  String get toLocation => '$_toCity ($_toCode)';
  String get fromCode => _fromCode;
  String get toCode => _toCode;
  String get departureDate => _departureDate;
  int get passengerCount => _passengerCount;
  bool get isSearching => _isSearching;
  int get selectedNavIndex => _selectedNavIndex;
  FlightSearchFilters get filters => _filters;

  String get passengerLabel =>
      '$_passengerCount ${_passengerCount == 1 ? 'person' : 'people'}';

  static const List<Map<String, String>> sortOptions = [
    {'label': 'Price: Low to High', 'value': 'price_asc'},
    {'label': 'Price: High to Low', 'value': 'price_desc'},
    {'label': 'Shortest Duration', 'value': 'duration_asc'},
    {'label': 'Earliest Departure', 'value': 'departure_asc'},
  ];

  List<FlightModel> _savedTrips = [];
  bool _isLoadingSavedTrips = false;
  String? _savedTripsError;

  List<FlightModel> get savedTrips => List.unmodifiable(_savedTrips);
  bool get isLoadingSavedTrips => _isLoadingSavedTrips;
  String? get savedTripsError => _savedTripsError;

  Future<void> loadSavedTrips() async {
    if (_isLoadingSavedTrips) return;
    _isLoadingSavedTrips = true;
    _savedTripsError = null;
    notifyListeners();

    try {
      final result = await _repository.getFlightList(limit: 3);
      _savedTrips = result.flights.map((flight) {
        return FlightModel(
          airlineName: flight.airlineName,
          departureTime: flight.departureTimeShort,
          arrivalTime: flight.arrivalTimeShort,
          departureCode: flight.departure.airportCode,
          arrivalCode: flight.arrival.airportCode,
          departureCity: flight.departure.city,
          arrivalCity: flight.arrival.city,
          duration: flight.duration,
          date: _departureDate,
        );
      }).toList();
    } catch (e) {
      _savedTripsError = 'Failed to load saved trips';
    } finally {
      _isLoadingSavedTrips = false;
      notifyListeners();
    }
  }

  List<AirportModel> _departureAirports = [];
  List<AirportModel> _arrivalAirports = [];
  bool _isLoadingAirports = false;
  String? _airportsError;

  List<AirportModel> get departureAirports => _departureAirports;
  List<AirportModel> get arrivalAirports => _arrivalAirports;
  bool get isLoadingAirports => _isLoadingAirports;
  String? get airportsError => _airportsError;

  Future<void> loadDepartureAirports({String search = ''}) async {
    _isLoadingAirports = true;
    _airportsError = null;
    notifyListeners();

    try {
      final result = await _repository.getDepartureAirports(
        search: search,
        limit: 50,
      );
      _departureAirports = result.airports;
    } on ApiException catch (e) {
      _airportsError = e.message;
    } catch (e) {
      _airportsError = 'Failed to load airports';
    }

    _isLoadingAirports = false;
    notifyListeners();
  }

  Future<void> loadArrivalAirports({String search = ''}) async {
    _isLoadingAirports = true;
    _airportsError = null;
    notifyListeners();

    try {
      final result = await _repository.getArrivalAirports(
        search: search,
        limit: 50,
      );
      _arrivalAirports = result.airports;
    } on ApiException catch (e) {
      _airportsError = e.message;
    } catch (e) {
      _airportsError = 'Failed to load airports';
    }

    _isLoadingAirports = false;
    notifyListeners();
  }

  void swapLocations() {
    final tempCode = _fromCode;
    final tempCity = _fromCity;
    _fromCode = _toCode;
    _fromCity = _toCity;
    _toCode = tempCode;
    _toCity = tempCity;
    notifyListeners();
  }

  void setFromLocation(String code, String city) {
    _fromCode = code;
    _fromCity = city;
    notifyListeners();
  }

  void setToLocation(String code, String city) {
    _toCode = code;
    _toCity = city;
    notifyListeners();
  }

  void setDepartureDate(String v) {
    _departureDate = v;
    notifyListeners();
  }

  void setPassengerCount(int count) {
    if (count < 1) return;
    _passengerCount = count;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  void updateFilters(FlightSearchFilters updated) {
    _filters = updated;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _filters = _filters.copyWith(sortBy: sortBy);
    notifyListeners();
  }

  bool get hasActiveFilters =>
      _filters.airline != null ||
      _filters.priceMin != null ||
      _filters.priceMax != null ||
      _filters.stops != null ||
      _filters.aircraftType != null;

  String? _searchError;
  String? get searchError => _searchError;

  Future<void> searchFlights(BuildContext context) async {
    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      final result = await _repository.searchFlights(
        from: _fromCode,
        to: _toCode,
        passengers: _passengerCount,
        sortBy: _filters.sortBy,
        airline: _filters.airline,
        priceMin: _filters.priceMin,
        priceMax: _filters.priceMax,
        stops: _filters.stops,
        aircraftType: _filters.aircraftType,
      );

      _isSearching = false;
      notifyListeners();

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlightResultScreen(
              fromCode: _fromCode,
              toCode: _toCode,
              fromCity: _fromCity,
              toCity: _toCity,
              departureDate: _departureDate,
              passengerCount: _passengerCount,
              filters: _filters,
              initialFlights: result.flights,
              initialPagination: result.pagination,
              repository: _repository,
            ),
          ),
        );
      }
    } on ApiException catch (e) {
      _isSearching = false;
      _searchError = e.message;
      notifyListeners();
    } catch (e) {
      _isSearching = false;
      _searchError = 'Search failed. Please try again.';
      notifyListeners();
    }
  }

  Future<void> onDepartureTapped(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2028, 12, 31),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF2979FF)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      setDepartureDate(
        '${days[picked.weekday - 1]}, ${picked.day} ${months[picked.month - 1]}',
      );
    }
  }
}
