import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class internetConnection{
Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    return false; // No internet connection
  }
  return true; // Internet connection is available
}
}
