import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:tp_form/tp_form.dart';
import 'package:tp_form_example/pages/NearbyShopMapPage.dart';

import 'apis/APISourcerShops.dart';
import 'helpers/TPLocationGeolocator.dart';
import 'helpers/TPLocationPermissionHandler.dart';
import 'helpers/TPMapMarkerGeneratorVan.dart';
import 'helpers/TPShopMapMarkerPinPure.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NearbyShopMapPage(),
    );
  }

}
