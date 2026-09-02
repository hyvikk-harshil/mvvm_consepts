///only network connection check on device
/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// Import your main.dart file or wherever your global navigatorKey is declared
import '../../main.dart';

mixin NetworkCheckerMixin<T extends StatefulWidget> on State<T> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _checkStatus(results);
    });
  }

  void _checkStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      _showNoInternetDialog();
    } else {
      _dismissDialog();
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;

    // Use the global navigator key to locate the active screen context safely
    final currentContext = navigatorKey.currentContext;
    if (currentContext == null) return;

    _isDialogShowing = true;
    showDialog(
      context: currentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 10),
              Text("Connection Error"),
            ],
          ),
          content: const Text("Check internet connection."),
          actions: [
            TextButton(
              onPressed: () async {
                final currentStatus = await Connectivity().checkConnectivity();
                if (!currentStatus.contains(ConnectivityResult.none)) {
                  _dismissDialog();
                }
              },
              child: const Text("RETRY"),
            ),
          ],
        );
      },
    );
  }

  void _dismissDialog() {
    if (_isDialogShowing) {
      final currentContext = navigatorKey.currentContext;
      if (currentContext != null && mounted) {
        Navigator.of(currentContext, rootNavigator: true).pop();
      }
      _isDialogShowing = false;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
*/






/// Only device network connected or weak network check base on api call
/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

mixin NetworkCheckerMixin<T extends StatefulWidget> on State<T> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isDialogShowing = false;
  String _activeErrorType = ""; // Tracks if "disconnected" or "weak" dialog is active

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _evaluateNetwork(results);
    });
  }

  Future<void> _evaluateNetwork(List<ConnectivityResult> results) async {
    // 1. First Check: Hardware Connection
    if (results.contains(ConnectivityResult.none)) {
      _showWarningDialog(
        title: "Connection Error",
        message: "Check internet connection.",
        icon: Icons.wifi_off,
        errorType: "disconnected",
      );
      return;
    }

    // 2. Second Check: Network Speed / Latency Test
    bool isNetworkFastAndHealthy = await _testNetworkLatency();

    if (!isNetworkFastAndHealthy) {
      _showWarningDialog(
        title: "Weak Connection",
        message: "Your network is weak.",
        icon: Icons.signal_cellular_connected_no_internet_4_bar,
        errorType: "weak",
      );
    } else {
      // Everything is perfect, clear any active dialogs
      _dismissDialog();
    }
  }

  /// Measures connection speed by fetching a lightweight resource.
  /// Returns [true] if the network answers quickly, [false] if it is slow or times out.
  Future<bool> _testNetworkLatency() async {
    try {
      final stopwatch = Stopwatch()..start();
      // We request a lightweight endpoint with a strict response deadline
      final response = await http.get(
        Uri.parse('https://google.com'),
      ).timeout(const Duration(seconds: 3)); // If it takes longer than 3 seconds, it's considered weak

      stopwatch.stop();

      if (response.statusCode == 200) {
        debugPrint("---> Ping response received in: ${stopwatch.elapsedMilliseconds}ms");

        // If response takes more than 1800ms (1.8 seconds), flag it as a weak connection
        if (stopwatch.elapsedMilliseconds > 1800) {
          return false;
        }
        return true;
      }
      return false;
    } catch (_) {
      // Captures connection timeouts, packet drops, or socket exceptions
      return false;
    }
  }

  void _showWarningDialog({
    required String title,
    required String message,
    required IconData icon,
    required String errorType,
  }) {
    // If the exact same alert state is already active, don't recreate it
    if (_isDialogShowing && _activeErrorType == errorType) return;

    // If an alternative warning is currently running, dismiss it first before swapping
    if (_isDialogShowing) _dismissDialog();

    final currentContext = navigatorKey.currentContext;
    if (currentContext == null) return;

    _isDialogShowing = true;
    _activeErrorType = errorType;

    showDialog(
      context: currentContext,
      barrierDismissible: false, // Force user to acknowledge or hit retry
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: Colors.orange.shade800),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                // Re-run the verification instantly on manual tap
                final currentHardware = await Connectivity().checkConnectivity();
                _evaluateNetwork(currentHardware);
              },
              child: const Text("RETRY"),
            ),
          ],
        );
      },
    );
  }

  void _dismissDialog() {
    if (_isDialogShowing) {
      final currentContext = navigatorKey.currentContext;
      if (currentContext != null && mounted) {
        Navigator.of(currentContext, rootNavigator: true).pop();
      }
      _isDialogShowing = false;
      _activeErrorType = "";
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
*/
