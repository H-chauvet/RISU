import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/staggered_list.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'container_list_data.dart';
import 'container_page.dart';

/// ContainerPageState class
/// This class is the state of the ContainerPage widget
class ContainerPageState extends State<ContainerPage> {
  final FlutterMapMath mapMath = FlutterMapMath();
  PermissionStatus? permission;
  final LoaderManager _loaderManager = LoaderManager();
  LatLng _userPosition = const LatLng(47.210546, -1.566842); // Epitech Nantes
  List<ContainerList> containers = [];
  late Timer timer;

  @override
  void initState() {
    super.initState();

    _updaterContainer();
    _updateLocation();
    if (widget.testPosition == null) {
      timer = Timer.periodic(
          const Duration(seconds: 10), (Timer t) => _updateLocation());
    }
  }

  void _updaterContainer() async {
    if (widget.testContainers.isEmpty) {
      await _getContainer();
    } else {
      setState(() {
        containers = widget.testContainers;
      });
    }
  }

  /// Update the user location and the containers list
  /// If the testPosition is not null, the user position is set to the testPosition
  void _updateLocation() async {
    if (widget.testPosition == null) {
      await _requestLocationPermission();
    } else {
      setState(() {
        _userPosition = widget.testPosition!;
      });
    }
    await _getDistances();
  }

  /// Request the location permission
  /// If the permission is granted, get the user location
  Future<void> _requestLocationPermission() async {
    permission = await Permission.locationWhenInUse.status;
    if (permission != PermissionStatus.granted) {
      return;
    }
    await _getUserLocation();
  }

  /// Get the user location
  /// If the location is not available, the user position is set to Epitech Nantes
  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _userPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (err, stacktrace) {
      if (mounted) {
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringGettingUserLocation);
        return;
      }
      return;
    }
  }

  /// Get the containers list
  /// The containers list is set to the containers list from the API
  Future<void> _getContainer() async {
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
      switch (response.statusCode) {
        case 200:
          dynamic responseData = json.decode(response.body);
          final List<dynamic> containersData = responseData;
          setState(() {
            containers = containersData
                .map((data) => ContainerList.fromJson(data))
                .toList();
          });
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'getContainer');
          }
      }
      _getDistances();
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace);
        return;
      }
      return;
    }
  }

  /// Get the distances between the user position and the containers
  /// The distance is set to the distance between the user position and the container
  Future<void> _getDistances() async {
    if (!mounted) return;
    containers.forEach((container) {
      setState(() {
        container.distance = mapMath.distanceBetween(
          _userPosition.latitude,
          _userPosition.longitude,
          container.latitude,
          container.longitude,
          "meters",
        );
      });
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(context)!.containersList,
                        key: const Key('container-list_title'),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          if (containers.isEmpty)
                            Text(
                              AppLocalizations.of(context)!.containersListEmpty,
                              key: const Key('container-list_no-container'),
                              style: TextStyle(
                                fontSize: 18,
                                color: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.primaryColor),
                              ),
                            )
                          else ...[
                            StaggeredList(
                              itemCount: containers.length,
                              itemBuilder: (context, index) {
                                final product = containers.elementAt(index);
                                return ContainerCard(
                                  key: Key(
                                      'container-list_container-${product.id}'),
                                  container: product,
                                  onDirectionClicked: widget.onDirectionClicked,
                                );
                              },
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
