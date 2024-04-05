import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:risu/utils/errors.dart';
import 'package:http/http.dart' as http;

import 'package:risu/components/loader.dart';
import 'package:risu/pages/container/container_list.dart';
import 'package:risu/components/showModalBottomSheet.dart';
import 'package:risu/globals.dart';
import 'map_page.dart';

class MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  final bool displayGoogleMap = true;
  PermissionStatus? permission;
  String? markerId;
  List<ContainerList> containers = [];
  final LoaderManager _loaderManager = LoaderManager();

  LatLng _center = const LatLng(33.139469, -117.161148);

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getContainersData();
  }

  void _getContainersData() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.get(
        Uri.parse('$baseUrl/api/mobile/container/listAll'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);
        final List<dynamic> containersData = responseData;
        containers =
            containersData.map((data) => ContainerList.fromJson(data)).toList();
      } else {
        if (context.mounted) {
          printServerResponse(context, response, '_getContainersData');
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace);
        return;
      }
      return;
    }
  }

  Widget displayMap(BuildContext context) {
    setState(() {
      _loaderManager.setIsLoading(true);
    });
    if (!displayGoogleMap) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.mapNoDisplayedByRisu,
          textAlign: TextAlign.center,
        ),
      );
    }

    Set<Marker> markers = {};

    for (ContainerList container in containers) {
      final position = LatLng(container.latitude ?? _center.latitude,
          container.longitude ?? _center.longitude);
      markers.add(
        Marker(
          markerId: MarkerId(container.id.toString()),
          position: position,
          onTap: () {
            setState(() {
              markerId = container.id.toString();
            });
            myShowModalBottomSheet(
              context,
              container.city!,
              subtitle: "by ${"Risu"}",
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(container.address!),
                    ),
                    const Divider(
                      color: Colors.black12,
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(container.address!),
                    ),
                    const Divider(
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    setState(() {
      _loaderManager.setIsLoading(false);
    });
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 16.0 + 1.0,
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
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.location_searching,
          color: Theme.of(context).secondaryHeaderColor,
        ),
      );
    } else {
      floatingActionButton = null;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : displayMap(context),
      floatingActionButton:
          (_loaderManager.getIsLoading()) ? null : floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
