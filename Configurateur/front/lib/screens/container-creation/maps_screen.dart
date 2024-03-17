import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => MapsState();
}

class MapsState extends State<MapsScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(45.803160, 15.957040),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          onTap: (LatLng latLng) {
            debugPrint(latLng.toString());
          },
        ),
      ),
    );
  }
}
