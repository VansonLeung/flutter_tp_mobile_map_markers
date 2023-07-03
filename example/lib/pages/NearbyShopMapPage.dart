import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tp_form_example/fragments/generic/GenericScaffold.dart';

import '../apis/APISourcerShops.dart';
import '../apis/models/APIResponsesShop.dart';
import '../fragments/nearbymap/NearbyMapShopListView.dart';
import '../helpers/TPLocationGeolocator.dart';
import '../helpers/TPLocationPermissionHandler.dart';
import '../helpers/TPMapMarkerGeneratorVan.dart';
import '../helpers/TPShopMapMarkerPinPure.dart';

class NearbyShopMapPage extends StatefulWidget {

  const NearbyShopMapPage({super.key});

  @override
  _NearbyShopMapPageState createState() => _NearbyShopMapPageState();
}

class Location {
  final LatLng coordinates;
  final String name;
  Location(this.coordinates, this.name);
}

class _NearbyShopMapPageState extends State<NearbyShopMapPage> with SingleTickerProviderStateMixin {

  String? _mapStyle;
  PlatformMapController? _platformMapController;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  List<Shop> shops = [];
  List<Shop> shops_by_zIndex = [];

  List<Marker> customMarkers = [];

  final selectedIndex = ValueNotifier<int>(0);
  bool isFirstViewed = false;

  bool isReady = false;

  @override
  void initState() {
    super.initState();
    initPage();
  }

  Future<void> initPage() async {
    await buildMapMarkers();

    rootBundle.loadString('assets/misc/map_styles.txt').then((string) {
      _mapStyle = string;
      refreshMapStyle();
      setState(() {
        isReady = true;
      });
    });

    getCurrentPosition();
  }

  Future<void> buildMapMarkers() async {

    BorderPainter borderPainter = new BorderPainter();
    List<BitmapDescriptor> collections = [];

    for (var k = 0; k < 30; k ++) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromPoints(Offset(0.0, 0.0), Offset(132, 132)));
      borderPainter.paintMarker(canvas, Size(132, 132), k);
      final picture = recorder.endRecording();
      final img = await picture.toImage(132, 132);
      final pngBytes = await img.toByteData(format: ImageByteFormat.png);

      final uint8llist = pngBytes?.buffer.asUint8List();
      if (uint8llist != null)
        collections.add(BitmapDescriptor.fromBytes(uint8llist!));
    }

    TPMapMarkerGeneratorVan.bitmapCache = collections;
  }


  Future<void> getCurrentPosition() async {
    log("XX A");
    final result = await TPLocationPermissionHandler().handleLocationPermission();
    if (!result.success) return;

    log("XX B");
    final currentLatLng = await TPLocationGeolocator().getCurrentCoordinate();

    Map<String, dynamic> query = {};
    query["removed"] = {"\$ne": true};
    query["lnglat"] = {
      "\$near": {
        "\$geometry": {
          "type": "Point",
          "coordinates": [currentLatLng.longitude, currentLatLng.latitude]
        },
        "\$maxDistance": 30000
      }
    };

    APISourcerShops().get_shops(
      query: query,
      limit: 30,
      skip: 0,
    )
        .then((value) {
      setState(() {
        shops.clear();
        shops.addAll(value ?? []);

        shops_by_zIndex.clear();
        shops_by_zIndex.addAll(value ?? []);
        shops_by_zIndex.sort((a, b) {
          return b.latitude!.compareTo(a.latitude!);
        });


        if (!isFirstViewed) {
          // zoom
          double minLat = 10000;
          double maxLat = -10000;
          double minLng = 10000;
          double maxLng = -10000;

          for (var k in shops) {
            if (k.latitude != null) {
              minLat = k.latitude! < minLat ? k.latitude! : minLat;
              maxLat = k.latitude! > maxLat ? k.latitude! : maxLat;
            }
            if (k.longitude != null) {
              minLng = k.longitude! < minLng ? k.longitude! : minLng;
              maxLng = k.longitude! > maxLng ? k.longitude! : maxLng;
            }
          }

          if (minLat < maxLat && minLng < maxLng) {
            _platformMapController?.moveCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: LatLng(minLat, minLng),
                  northeast: LatLng(maxLat, maxLng),
                ),
                40.0,
              ),
            );
          }
        }

        cacheCustomMarkersBitmapsByShopsOfZIndex();

      });
    });

  }



  void cacheCustomMarkersBitmapsByShopsOfZIndex() {

    setState(() {
      customMarkers.clear();
      shops_by_zIndex.asMap().forEach((i, bmp) {
        int real_index = shops.indexOf(shops_by_zIndex[i]);
        var bmp = TPMapMarkerGeneratorVan.bitmapCache[real_index];

        customMarkers.add(
            Marker(
              markerId: MarkerId("$real_index"),
              position: LatLng(
                  shops[real_index].latitude!,
                  shops[real_index].longitude!
              ),
              icon: (bmp),
              infoWindow: InfoWindow(
                anchor: const Offset(0.5, 0),
                title: "${real_index+1}. ${shops[real_index].getName(context)}",
                snippet: "${shops[real_index].address}",
              ),
              onTap: () {
                highlightMarker(real_index, shouldScrollToIndex: true);
              },
            )
        );

      });

    });


  }



  void highlightMarker(int index, {
    bool shouldSummonInfoWindow = false,
    bool shouldScrollToIndex = false,
  }) {

    selectedIndex.value = index;

    if (shouldScrollToIndex) {
      itemScrollController.scrollTo(
        index: selectedIndex.value,
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 350),
        alignment: 0.5,
      );
    }

    _platformMapController?.showMarkerInfoWindow(MarkerId("${index}"));

    if (_platformMapController?.appleController != null) {
      _platformMapController?.appleController?.getZoomLevel()
          .then((zoom) {

        if (zoom != null) {
          _platformMapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(shops[index].latitude!, shops[index].longitude!),
                // zoom!,
              )
          );
        }

      });
    }
    else if (_platformMapController?.googleController != null) {
      _platformMapController?.googleController?.getZoomLevel()
          .then((zoom) {

        if (zoom != null) {
          _platformMapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(shops[index].latitude!, shops[index].longitude!),
                // zoom!,
              )
          );
        }


      });
    }
  }




  @override
  void dispose() {
    super.dispose();
  }



  void refreshMapStyle() {
    if (_platformMapController?.googleController != null
        && _mapStyle != null)
    {
      _platformMapController?.googleController?.setMapStyle(_mapStyle);
    }
  }



  @override
  Widget build(BuildContext context) {
    return GenericScaffold(
      titleString: "Nearby",
      body: Container(
        child: isReady ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              flex: 3,
              child: PlatformMap(
                onMapCreated: (PlatformMapController platformMapController) {
                  _platformMapController = platformMapController;
                  refreshMapStyle();
                },
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    22.302219,
                    114.174637,
                  ),
                  bearing: 0.0,
                  tilt: 0.0,
                  zoom: 15,
                ),

                markers: Set<Marker>.of(
                  customMarkers,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onCameraMove: (cameraUpdate) => print('onCameraMove: $cameraUpdate'),
                compassEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: true,
                trafficEnabled: true,


              ),
            ),


            Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                    children: [
                      Text("Displaying ",
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      Text("your nearby bars",
                        style: const TextStyle(
                          color: Color(0xFFff33ff),
                        ),
                      ),
                    ]
                )
            ),


            Expanded(
              flex: 4,
              child: ValueListenableBuilder(
                  valueListenable: selectedIndex,
                  builder: (_, value, __) {
                    return NearbyMapShopListView(
                      selectedIndex: value,
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      shops: shops,
                      onBottomReach: () {

                      },
                      onSelectIndex: (index) {
                        highlightMarker(index, shouldSummonInfoWindow: true);
                      },
                    );
                  }),

            ),


          ],
        ) : null,
      ),
    );
  }
}