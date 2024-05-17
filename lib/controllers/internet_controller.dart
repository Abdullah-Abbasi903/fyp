import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetController extends ChangeNotifier {

  late bool _isConnected;

  bool get isConnected => _isConnected;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  InternetController() {
    _isConnected = false;
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _updateConnectionStatus(await Connectivity().checkConnectivity());
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    var connected = false;
    for (var result in connectivityResults) {
      if (result != ConnectivityResult.none) {
        connected = true;
        break;
      }
    }
    _isConnected = connected;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
