

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TPLocationPermissionResponse {
  bool success;
  bool serviceEnabled;
  LocationPermission? permission;

  TPLocationPermissionResponse(this.success, this.serviceEnabled, this.permission);
}

class TPLocationPermissionHandler {
  Future<TPLocationPermissionResponse> handleLocationPermission( {
        bool isNotRequest = false,
    }) async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location services are disabled. Please enable the services')));
      return TPLocationPermissionResponse(false, serviceEnabled, null);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (isNotRequest) {
        return TPLocationPermissionResponse(false, serviceEnabled, permission);
      } else {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Location permissions are denied')));
          return TPLocationPermissionResponse(false, serviceEnabled, permission);
        }
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return TPLocationPermissionResponse(false, serviceEnabled, permission);
    }
    return TPLocationPermissionResponse(true, serviceEnabled, permission);
  }
}




