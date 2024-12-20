import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/dialog/help_dialog/help_dialog.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'maps_screen_style.dart';

/// MapScreen
///
/// Creation of the container
/// [lockers] : All the lockers of the container
/// [amount] : Price of the container
/// [containerMapping] : String that contains numbers representing where lockers is positioned in the container.
/// [container] : Informations about the container
/// [id] : User's Id
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

/// MapState
///
class MapsState extends State<MapsScreen> {
  String jwtToken = '';
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // default location (EPITECH Nantes)
  static CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(47.210528, -1.566956),
    zoom: 15,
  );

  LatLng location = _kGooglePlex.target;

  /// [Function] : Check the token in the storage service
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

  /// [Function] : Get the user position
  void getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _kGooglePlex = const CameraPosition(
            target: LatLng(47.210528, -1.566956),
            zoom: 15,
          );
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      );
    });
  }

  @override
  void initState() {
    checkToken();
    getPosition();

    super.initState();
  }

  /// [Function] : Go to the next page
  void goNext() {
    HttpService().putRequest(
      'http://$serverIp:3000/api/container/update-position',
      <String, String>{
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      {
        'id': widget.id,
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = {
          'amount': widget.amount,
          'containerMapping': widget.containerMapping,
          'lockers': widget.lockers,
          'id': widget.id,
          'container': widget.container,
        };
        context.go('/container-creation/payment', extra: jsonEncode(data));
      } else {
        showCustomToast(context, response.body, false);
      }
    });
  }

  /// [Function] : Go to the previous page
  void goPrevious() {
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'lockers': widget.lockers,
      'id': widget.id,
      'container': widget.container,
    };
    context.go('/container-creation/recap', extra: jsonEncode(data));
  }

  /// [Widget] : Build of the localisation page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Scaffold(
      body: FooterView(
        flex: 8,
        footer: Footer(
          padding: EdgeInsets.zero,
          child: CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            AppLocalizations.of(context)!.location,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenFormat == ScreenFormat.desktop
                  ? desktopBigFontSize
                  : tabletBigFontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.secondaryHeaderColor
                  : lightTheme.secondaryHeaderColor,
              shadows: [
                Shadow(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                  offset: const Offset(0.75, 0.75),
                  blurRadius: 1.5,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressBar(
                length: 6,
                progress: 4,
                previous: AppLocalizations.of(context)!.previous,
                next: AppLocalizations.of(context)!.next,
                previousFunc: goPrevious,
                nextFunc: goNext,
              ),
            ],
          ),
          Center(
            child: IconButton(
              hoverColor: Colors.transparent,
              iconSize: 30.0,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => HelpDialog(content: 'maps_screen'));
              },
              icon: Icon(
                Icons.help_outline,
                color: darkTheme.primaryColor,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: screenFormat == ScreenFormat.desktop
                    ? desktopWidthFactor
                    : tabletWidthFactor,
                heightFactor: screenFormat == ScreenFormat.desktop
                    ? desktopHeightFactor
                    : tabletHeightFactor,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GoogleMap(
                      key: UniqueKey(),
                      initialCameraPosition: _kGooglePlex,
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMove: (CameraPosition position) {
                        location = position.target;
                      },
                    ),
                    Positioned(
                      child: Icon(
                        size: screenFormat == ScreenFormat.desktop
                            ? desktopIconSize
                            : tabletIconSize,
                        Icons.room,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
