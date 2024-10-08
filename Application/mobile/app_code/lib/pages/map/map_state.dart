import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/showModalBottomSheet.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/pages/container/container_list_data.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/image_loader.dart';
import 'package:risu/utils/providers/theme.dart';

import 'map_page.dart';

/// MapPageState
/// This class is the state of the MapPage class
/// It contains the methods to display the map and the containers
class MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  PermissionStatus? permission;
  List<ContainerList> containers = [];
  final LoaderManager _loaderManager = LoaderManager();
  List<dynamic> listItems = [];
  Map<String, dynamic> containersData = {};
  Color dividerColor = Colors.black12;
  int? containerId;
  LatLng _center = const LatLng(47.210546, -1.566842); // Epitech Nantes

  @override
  void initState() {
    super.initState();
    containerId = widget.containerId;
    _requestLocationPermission();
    _getContainersData();
  }

  /// _getContainersData
  /// This method is used to get the containers data from the API
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
      switch (response.statusCode) {
        case 200:
          dynamic responseData = json.decode(response.body);
          final List<dynamic> containersData = responseData;
          containers = containersData
              .map((data) => ContainerList.fromJson(data))
              .toList();
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, '_getContainersData');
          }
          break;
      }
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

  /// _getContainerItems
  /// This method is used to get the items of a container from the API
  /// params:
  /// [containerId] - the id of the container
  Future<void> _getContainerItems(int containerId) async {
    if (containersData.containsKey('$containerId')) {
      setState(() {
        listItems = containersData['$containerId'];
      });
      return;
    }
    setState(() {
      listItems = [];
    });
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/mobile/container/$containerId/articleslist'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      switch (response.statusCode) {
        case 200:
          dynamic responseData = json.decode(response.body);
          setState(() {
            listItems = responseData;
            containersData['$containerId'] = listItems;
          });
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, '_getContainersData');
          }
          break;
      }
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

  /// displayBottomSheet
  /// This method is used to display the bottom sheet of a container
  /// params:
  /// [container] - the container
  void displayBottomSheet(ContainerList container) {
    if (!context.mounted) return;
    _getContainerItems(container.id).then(
      (value) => myShowModalBottomSheet(
        context,
        container.city,
        subtitle: "${AppLocalizations.of(context)!.by} ${"Risu"}",
        SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: dividerColor,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(container.address),
                  ),
                ],
              ),
              Divider(
                color: dividerColor,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.articles,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleListPage(
                            containerId: container.id,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.viewMore,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (listItems.isEmpty)
                Text(
                  AppLocalizations.of(context)!.articlesListEmpty,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              else
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      final item = listItems.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailsPage(
                                articleId: item['id'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Stack(
                              children: [
                                loadImageFromURL(item['imageUrl']),
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: item['available']
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// displayMap
  /// This method is used to display the map
  /// It returns a widget that contains the GoogleMap widget
  /// params:
  /// [context] - the context of the widget
  Widget displayMap(BuildContext context) {
    setState(() {
      _loaderManager.setIsLoading(true);
    });
    if (!widget.displayGoogleMap) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.mapNoDisplayedByRisu,
          textAlign: TextAlign.center,
        ),
      );
    }

    Set<Marker> markers = {};
    for (ContainerList container in containers) {
      if (containerId != null && containerId == container.id) {
        setState(() {
          mapController?.animateCamera(CameraUpdate.newLatLng(
              LatLng(container.latitude, container.longitude)));
        });
      }
      final position = LatLng(container.latitude, container.longitude);
      markers.add(
        Marker(
          markerId: MarkerId(container.id.toString()),
          position: position,
          onTap: () {
            displayBottomSheet(container);
          },
        ),
      );
    }

    setState(() {
      Colors.black12;
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

  /// _onMapCreated
  /// This method is called when the map is created
  /// It sets the mapController
  /// params:
  /// [controller] - the GoogleMapController
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  /// testOnMapCreated
  /// This method is used to test the _onMapCreated method
  /// params:
  /// [controller] - the GoogleMapController
  void testOnMapCreated(GoogleMapController controller) {
    _onMapCreated(controller);
  }

  /// _requestLocationPermission
  /// This method is used to request the location permission
  /// It sets the permission status and gets the user location
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

  /// _getUserLocation
  /// This method is used to get the user location
  /// It sets the _center variable and animates the camera
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
      if (mounted) {
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
          containerId = null;
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
    dividerColor = context.select((ThemeProvider themeProvider) =>
        themeProvider.currentTheme.dividerColor);
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
