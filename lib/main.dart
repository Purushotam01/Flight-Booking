import 'package:flight_booking/data/repositories/flight_repository.dart';
import 'package:flight_booking/data/services/api_service.dart';
import 'package:flight_booking/data/services/connectivity_service.dart';
import 'package:flight_booking/view/home/view/home_view.dart';
import 'package:flight_booking/view/home/viewmodel/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  final apiService = ApiService();
  final connectivityService = ConnectivityService();
  final repository = FlightRepository(
    apiService: apiService,
    connectivityService: connectivityService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(repository: repository),
        ),
      ],
      child: const _App(),
    ),
  );
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Booking',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFECF2FB),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2979FF)),
      ),

      home: const HomeScreen(),
    );
  }
}
