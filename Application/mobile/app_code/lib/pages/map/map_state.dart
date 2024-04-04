import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:risu/utils/errors.dart';

import '../../components/showModalBottomSheet.dart';
import 'map_page.dart';

class MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  final bool displayGoogleMap = true;
  PermissionStatus? permission;
  String? markerId;

  LatLng _center = const LatLng(33.139469, -117.161148);

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

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('marker_1'),
        position: const LatLng(47.2104851, -1.56675127492582),
        onTap: () {
          setState(() {
            markerId = 'myId';
          });
          myShowModalBottomSheet(
            context,
            'Epitech Nantes',
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "myShowModalBottomSheet",
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    };
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 16.0,
      ),
      markers: markers,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _requestLocationPermission() async {
    permission = await Permission.locationWhenInUse.status;
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
        desiredAccuracy: LocationAccuracy.low,
      );
      if (!mounted) return;
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
      mapController?.animateCamera(CameraUpdate.newLatLng(_center));
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringGettingUserLocation);
        return;
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? floatingActionButton;
    if (permission != null && permission == PermissionStatus.granted) {
      floatingActionButton = FloatingActionButton(
        onPressed: () {
          _getUserLocation();
        },
        child: const Icon(Icons.location_searching),
      );
    } else {
      floatingActionButton = null;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: displayMap(context),
      floatingActionButton: floatingActionButton,
    );
  }
}
