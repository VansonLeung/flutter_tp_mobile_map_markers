

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

import '../apis/models/APIResponsesShop.dart';

class TPLocationGeolocator {
  Future<Position> getCurrentPosition() async {
    print("getCurrentPositionA");
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(milliseconds: 1500),
      );
      return position;
    } catch (e) {
      rethrow;
    }
    // return Position(
    //     longitude: 114.174637,
    //     latitude: 22.302219,
    //     timestamp: timestamp,
    //     accuracy: accuracy,
    //     altitude: altitude,
    //     heading: heading,
    //     speed: speed,
    //     speedAccuracy: speedAccuracy);
  }

  Future<LatLng> getCurrentCoordinate() async {
    print("getCurrentCoordinate");
    try {
      Position position = await getCurrentPosition();
      return LatLng(
          position.latitude,
          position.longitude);
    } catch (e) {
      return const LatLng(
          22.302219,
          114.174637,);
    }
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // return position;
  }


  String? getDistanceRepresentation(
      BuildContext context,
      double lat,
      double lng,
      Shop shop,
      )
  {
    var distance;
    if (shop.lnglat != null && shop.lnglat?.length == 2) {
      var distanceKm = calculateDistance(lat, lng, shop.lnglat![1], shop.lnglat![0], "K");
      if (distanceKm < 0.1) {
        distance = "< 100${("m")}";
      }
      else if (distanceKm <= 1.0) {
        distance = "${( (distanceKm * 100).round() * 10)}${("m")}";
      }
      else {
        distance = "${( (distanceKm * 10).round() / 10)}${("km")}";
      }
    }
    return distance;
  }



  calculateDistance(double lat1, double lon1, double lat2, double lon2, String unit) {
    var radlat1 = pi * lat1/180;
    var radlat2 = pi * lat2/180;
    var theta = lon1-lon2;
    var radtheta = pi * theta/180;
    var dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta);
    dist = acos(dist);
    dist = dist * 180/pi;
    dist = dist * 60 * 1.1515;
    if (unit=="K") { dist = dist * 1.609344; }
    if (unit=="N") { dist = dist * 0.8684; }
    return dist;
  }

}



