import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:risu/utils/errors.dart';

import 'map_page.dart';

class MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  final bool displayGoogleMap = true;

  LatLng _center = const LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Widget displayMap() {
    if (!displayGoogleMap) {
      return const Center(
        child: Text(
          'Risu decided to not display the map',
          textAlign: TextAlign.center,
        ),
      );
    }
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 10.0,
      ),
      markers: _markers,
    );
  }

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(47.2104851, -1.56675127492582),
      infoWindow: InfoWindow(
        title: 'Epitech',
        snippet: 'Nantes',
      ),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus permission = await Permission.locationWhenInUse.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.locationWhenInUse.request();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
      mapController?.animateCamera(CameraUpdate.newLatLng(_center));
    } catch (err, stacktrace) {
      printCatchError(context, err, stacktrace,
          message: "An error occured when trying to get the user's location.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: displayMap(),
    );
  }
}
