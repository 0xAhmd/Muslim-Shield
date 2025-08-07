// lib/core/services/connectivity_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  bool _isConnected = true;

  Stream<bool> get connectionStream => _connectionController.stream;
  bool get isConnected => _isConnected;
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    // ignore: unrelated_type_equality_checks
    _isConnected = result != ConnectivityResult.none;

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final wasConnected = _isConnected;
      // Consider connected if any of the results is not `none`
      _isConnected = results.any((result) => result != ConnectivityResult.none);

      if (wasConnected != _isConnected) {
        _connectionController.add(_isConnected);
      }
    });
  }

  void dispose() {
    _connectionController.close();
  }
}
