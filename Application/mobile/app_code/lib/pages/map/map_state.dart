import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:risu/utils/errors.dart';

import 'map_page.dart';

class MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  final bool displayGoogleMap = true;

  LatLng _center = const LatLng(47.2104851, -1.56675127492582);

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Widget displayMap(BuildContext context) {
    if (!displayGoogleMap) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.mapNoDisplayedByRisu,
          textAlign: TextAlign.center,
        ),
      );
    }
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 16.0,
      ),
      markers: _markers,
    );
  }

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(47.2104851, -1.56675127492582),
      infoWindow: InfoWindow(
        title: "Epitech",
        snippet: "Nantes",
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
          message: AppLocalizations.of(context)!
              .errorOccurredDuringGettingUserLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: displayMap(context),
    );
  }
}
