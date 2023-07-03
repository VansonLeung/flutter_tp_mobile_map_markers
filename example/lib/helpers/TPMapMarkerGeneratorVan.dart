import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// This just adds overlay and builds [_MarkerHelper] on that overlay.
/// [_MarkerHelper] does all the heavy work of creating and getting bitmaps
class TPMapMarkerGeneratorVan {
  static List<BitmapDescriptor> bitmapCache = [];
}
