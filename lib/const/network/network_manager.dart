import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum NetworkState { good, weak, disconnected }

class NetworkManager extends ChangeNotifier {
  // OOP Singleton Pattern: Ensures only one instance exists across the app
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance;
  NetworkManager._internal() {
    _initHardwareListener();
  }

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  NetworkState _currentStatus = NetworkState.good;

  NetworkState get currentStatus => _currentStatus;

  // 1. Passive Hardware Listener (Runs once, consumes zero battery when idle)
  void _initHardwareListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        _updateState(NetworkState.disconnected);
      } else {
        // When hardware reconnects, assume 'good' until an API call proves otherwise
        _updateState(NetworkState.good);
      }
    });
  }

  // 2. On-Demand Speed Reporter (Called lazily by your Interceptor)
  void reportSpeedFlag(bool isWeak) {
    // If the hardware says we are completely disconnected, ignore speed updates
    if (_currentStatus == NetworkState.disconnected) return;

    final targetState = isWeak ? NetworkState.weak : NetworkState.good;
    _updateState(targetState);
  }

  void _updateState(NetworkState newState) {
    if (_currentStatus != newState) {
      _currentStatus = newState;
      notifyListeners(); // Notifies the Global UI Banner to slide up/down
    }
  }

  void disposeSubscription() {
    _connectivitySubscription.cancel();
  }
}






// class NetworkBoundClient {
//   final http.Client _client = http.Client();
//   final NetworkManager _networkManager = NetworkManager();
//
//   // OOP State Flag: Tracks if the HTTP connection pool is warmed up
//   bool _isFirstRequest = true;
//
//   /// Executes an API request and measures latency on-demand without background traffic
//   Future<http.Response> get(Uri url) async {
//     try {
//       final stopwatch = Stopwatch()..start();
//
//       // Enforce a strict 5-second cutoff time for your actual app API request
//       final response = await _client.get(url).timeout(const Duration(seconds: 5));
//
//       stopwatch.stop();
//       final elapsed = stopwatch.elapsedMilliseconds;
//
//       print("TIME TAKEN API ---> $elapsed");
//
//       // 1. Handle the Cold Start exception safely
//       if (_isFirstRequest) {
//         _isFirstRequest = false; // Mark connection pool as warmed up for all future calls
//
//         // Give the first connection a higher threshold (e.g., 4000ms) to allow SSL handshake
//         if (elapsed > 4000) {
//           _networkManager.reportSpeedFlag(true);
//         } else {
//           _networkManager.reportSpeedFlag(false);
//         }
//       }
//       // 2. Standard execution rules for subsequent calls
//       else {
//         if (elapsed > 2000) {
//           _networkManager.reportSpeedFlag(true);
//         } else {
//           _networkManager.reportSpeedFlag(false); // Speed is perfectly fine
//         }
//       }
//
//       return response;
//     } on TimeoutException {
//       _networkManager.reportSpeedFlag(true);
//       throw Exception("Network request timed out due to slow speed.");
//     } catch (e) {
//       throw Exception("Network failure: $e");
//     }
//   }
// }






class NetworkBoundClient {
  final http.Client _client = http.Client();
  final NetworkManager _networkManager = NetworkManager();
  bool _isFirstRequest = true;

  // Helper method to consolidate stopwatch and latency-checking logic across all requests
  void _trackLatency(int elapsedMilliseconds) {
    if (_isFirstRequest) {
      _isFirstRequest = false;
      if (elapsedMilliseconds > 4000) {
        _networkManager.reportSpeedFlag(true);
      } else {
        _networkManager.reportSpeedFlag(false);
      }
    } else {
      if (elapsedMilliseconds > 2000) {
        _networkManager.reportSpeedFlag(true);
      } else {
        _networkManager.reportSpeedFlag(false);
      }
    }
  }

  /// GET Request
  Future<http.Response> get(Uri url) async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await _client.get(url).timeout(const Duration(seconds: 5));
      stopwatch.stop();

      _trackLatency(stopwatch.elapsedMilliseconds);
      return response;
    } on TimeoutException {
      _networkManager.reportSpeedFlag(true);
      throw Exception("Network request timed out due to slow speed.");
    } catch (e) {
      throw Exception("Network failure: $e");
    }
  }

  /// NEW: POST Request
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await _client.post(url, headers: headers, body: body).timeout(const Duration(seconds: 5));
      stopwatch.stop();

      _trackLatency(stopwatch.elapsedMilliseconds);
      return response;
    } on TimeoutException {
      _networkManager.reportSpeedFlag(true);
      throw Exception("Network post request timed out.");
    } catch (e) {
      throw Exception("Network failure: $e");
    }
  }

  /// NEW: PUT Request
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body}) async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await _client.put(url, headers: headers, body: body).timeout(const Duration(seconds: 5));
      stopwatch.stop();

      _trackLatency(stopwatch.elapsedMilliseconds);
      return response;
    } on TimeoutException {
      _networkManager.reportSpeedFlag(true);
      throw Exception("Network put request timed out.");
    } catch (e) {
      throw Exception("Network failure: $e");
    }
  }

  /// NEW: DELETE Request
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body}) async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await _client.delete(url, headers: headers, body: body).timeout(const Duration(seconds: 5));
      stopwatch.stop();

      _trackLatency(stopwatch.elapsedMilliseconds);
      return response;
    } on TimeoutException {
      _networkManager.reportSpeedFlag(true);
      throw Exception("Network delete request timed out.");
    } catch (e) {
      throw Exception("Network failure: $e");
    }
  }
}

