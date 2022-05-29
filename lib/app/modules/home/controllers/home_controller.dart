import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as google_location;
import 'package:location/location.dart';

class HomeController extends GetxController {
  Completer<GoogleMapController> mapController = Completer();
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  CameraPosition? kGooglePlex;
  var selected = "Restaurant".obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  var googlePlace =
      google_location.GooglePlace("AIzaSyCEa9HnLpD0cGxRE30ambp0v46GXm0Uvhw");

  @override
  void onInit() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    kGooglePlex = CameraPosition(
      target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
      zoom: 14,
    );
    _getNearby();
    super.onInit();
  }

  void _getNearby() async {
    markers = {};
    var result = await googlePlace.search.getNearBySearch(
        google_location.Location(
            lat: _locationData!.latitude!, lng: _locationData!.longitude!),
        1500,
        type: selected.toLowerCase());
    for (var res in result!.results!) {
      final id = MarkerId(res.placeId ?? Random.secure().toString());
      final marker = Marker(
        markerId: id,
        position:
            LatLng(res.geometry!.location!.lat!, res.geometry!.location!.lng!),
        infoWindow: InfoWindow(title: res.name, snippet: res.vicinity),
      );
      markers[id] = marker;
    }

    update();
  }

  void onChangeType(String value) {
    selected.value = value;
    _getNearby();
  }
}
