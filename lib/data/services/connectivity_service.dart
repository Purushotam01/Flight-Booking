import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      try {
        final lookup = await InternetAddress.lookup('google.com');
        return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    }
    return true;
  }
}
