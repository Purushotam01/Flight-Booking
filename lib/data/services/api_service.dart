import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException({this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';

  bool get isTimeout => message.contains('timed out');
  bool get isNetwork =>
      message.contains('network') || message.contains('connection');
}

class ApiService {
  static const String _baseUrl = 'https://flight.wigian.in/flight_api.php';
  static const Duration _timeout = Duration(seconds: 30);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint');

    _logRequest(endpoint, body);

    try {
      final response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      _logResponse(endpoint, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format',
        );
      } else {
        String errorMessage = 'Server error (${response.statusCode})';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map<String, dynamic>) {
            errorMessage =
                errorBody['error'] as String? ??
                errorBody['message'] as String? ??
                errorMessage;
          }
        } catch (_) {}

        throw ApiException(
          statusCode: response.statusCode,
          message: errorMessage,
        );
      }
    } on TimeoutException {
      throw const ApiException(
        message:
            'Request timed out. Please check your connection and try again.',
      );
    } on SocketException {
      throw const ApiException(
        message:
            'No network connection. Please check your internet and try again.',
      );
    } on http.ClientException catch (e) {
      throw ApiException(message: 'Connection error: ${e.message}');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> searchFlights({
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
  }) {
    final body = <String, dynamic>{
      'from': from,
      'to': to,
      'passengers': passengers,
      'sort_by': sortBy,
      'page': page,
      'limit': limit,
      'filters': <String, dynamic>{
        'airline': airline ?? '',
        'price_min': priceMin ?? 0,
        'price_max': priceMax ?? 0,
        'stops': stops ?? 0,
        'aircraft_type': aircraftType ?? '',
      },
    };
    return post('/search', body);
  }

  Future<Map<String, dynamic>> getFlightList({
    String sortBy = 'price_asc',
    int page = 1,
    int limit = 10,
    String? airline,
    double? priceMin,
    double? priceMax,
    int? stops,
    String? aircraftType,
  }) {
    final body = <String, dynamic>{
      'sort_by': sortBy,
      'page': page,
      'limit': limit,
      'filters': <String, dynamic>{
        'airline': airline ?? '',
        'price_min': priceMin ?? 0,
        'price_max': priceMax ?? 0,
        'stops': stops ?? 0,
        'aircraft_type': aircraftType ?? '',
      },
    };
    return post('/list', body);
  }

  Future<Map<String, dynamic>> getFlightDetails(int id) {
    return post('/flight', {'id': id});
  }

  Future<Map<String, dynamic>> getDepartureAirports({
    String search = '',
    int page = 1,
    int limit = 10,
  }) {
    return post('/airports/from', {
      'search': search,
      'page': page,
      'limit': limit,
    });
  }

  Future<Map<String, dynamic>> getArrivalAirports({
    String search = '',
    int page = 1,
    int limit = 10,
  }) {
    return post('/airports/to', {
      'search': search,
      'page': page,
      'limit': limit,
    });
  }

  Future<Map<String, dynamic>> getAirlines({
    String search = '',
    int page = 1,
    int limit = 10,
  }) {
    return post('/airlines', {'search': search, 'page': page, 'limit': limit});
  }

  Future<Map<String, dynamic>> getAircraftTypes({
    String search = '',
    int page = 1,
    int limit = 10,
  }) {
    return post('/aircraft-types', {
      'search': search,
      'page': page,
      'limit': limit,
    });
  }

  void _logRequest(String endpoint, Map<String, dynamic> body) {
    if (kDebugMode) {
      debugPrint('┌─── API REQUEST ───────────────────');
      debugPrint('│ POST $_baseUrl$endpoint');
      debugPrint('│ Body: ${jsonEncode(body)}');
      debugPrint('└──────────────────────────────────');
    }
  }

  void _logResponse(String endpoint, int statusCode, String body) {
    if (kDebugMode) {
      final truncated = body.length > 500 ? '${body.substring(0, 500)}…' : body;
      debugPrint('┌─── API RESPONSE ──────────────────');
      debugPrint('│ $endpoint → $statusCode');
      debugPrint('│ $truncated');
      debugPrint('└──────────────────────────────────');
    }
  }

  void dispose() {
    _client.close();
  }
}
