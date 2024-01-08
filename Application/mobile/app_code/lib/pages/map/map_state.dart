import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler

import 'map_page.dart';

class MapPageState extends State<MapPage> {
  GoogleMapController? mapController;

  LatLng _center = LatLng(37.7749, -122.4194); // Default map center

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(47.2104851, -1.56675127492582),
      infoWindow: InfoWindow(
        title: 'Epitech',
        snippet: 'Nantes',
      ),
    ),
    // Add more markers as needed
  };

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Request location permission when the page initializes
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus permission = await Permission.locationWhenInUse.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.locationWhenInUse.request();
      if (permission != PermissionStatus.granted) {
        // Handle denied permission
        return;
      }
    }
    _getUserLocation(); // Get the user's location if permission is granted
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });

      // Move the map camera to the new center
      mapController?.animateCamera(CameraUpdate.newLatLng(_center));
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),
        markers: _markers,
      ),
    );
  }
}
