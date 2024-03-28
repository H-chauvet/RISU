import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen(
      {super.key,
      this.lockers,
      this.amount,
      this.containerMapping,
      this.id,
      this.container});

  final String? lockers;
  final int? amount;
  final String? containerMapping;
  final String? id;
  final String? container;

  @override
  State<MapsScreen> createState() => MapsState();
}

class MapsState extends State<MapsScreen> {
  String jwtToken = '';
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(45.803160, 15.957040),
    zoom: 14.4746,
  );

  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != "") {
      jwtToken = token!;
    } else {
      if (mounted) {
        context.go(
          '/login',
        );
      }
    }
  }

  @override
  void initState() {
    checkToken();
    super.initState();
  }

  Set<Marker> markers = {};

  void goNext() {
    HttpService().putRequest(
      'http://$serverIp:3000/api/container/update-position',
      <String, String>{
        'Authorization': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      {
        'id': widget.id,
        'latitude': markers.first.position.latitude,
        'longitude': markers.first.position.longitude,
      },
    );
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'lockers': widget.lockers,
      'id': widget.id,
      'container': widget.container,
    };
    context.go('/container-creation/payment', extra: jsonEncode(data));
  }

  void goPrevious() {
    debugPrint('previous');
    dynamic decode = jsonDecode(widget.lockers!);
    debugPrint(decode.toString());
    debugPrint('previous2');
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'lockers': widget.lockers,
      'id': widget.id,
      'container': widget.container,
    };
    context.go('/container-creation/recap', extra: jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Localisation',
        context: context,
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressBar(
            length: 6,
            progress: 4,
            previous: 'Précédent',
            next: 'Suivant',
            previousFunc: goPrevious,
            nextFunc: goNext,
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
      body: Center(
          child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.7,
        alignment: Alignment.center,
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (LatLng latLng) {
            setState(() {
              markers.clear();
              markers.add(Marker(
                markerId: const MarkerId('1'),
                position: latLng,
              ));
            });
          },
        ),
      )),
    );
  }
}
