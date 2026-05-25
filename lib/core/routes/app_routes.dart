import 'package:flight_booking/view/home/view/home_view.dart';
import 'package:flight_booking/view/result/view/flight_result_view.dart';
import 'package:flight_booking/view/details/view/flight_details_view.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String flightResult = '/flight-result';
  static const String flightDetails = '/flight-details';

  static const String homeRoute = 'home';
  static const String flightResultRoute = 'flight-result';
  static const String flightDetailsRoute = 'flight-details';
}

abstract class AppPages {
  static const Type homeScreen = HomeScreen;
  static const Type flightResultScreen = FlightResultScreen;
  static const Type flightDetailsScreen = FlightDetailsScreen;
}
