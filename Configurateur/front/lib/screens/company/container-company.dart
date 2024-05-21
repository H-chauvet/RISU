import 'package:flutter/material.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

import 'container-company_style.dart';

/// MyContainerList
///
/// Define the data of container in back end
/// [id] : Container's id
/// [createdAt] : Creation of the container
/// [organization] : Organization having created the container
/// [organizationId] : Id of the organization
/// [containerMapping] : String that contains numbers representing where lockers is positioned in the container.
/// [price] : Price of the container
/// [design] : List of design for the container's faces
/// [informations] : Informations about the container
class MyContainerList {
  final int? id;
  final dynamic createdAt;
  final dynamic organization;
  final int? organizationId;
  final dynamic containerMapping;
  final double? price;
  final String? address;
  final String? city;
  final String? design;
  final String? informations;

  MyContainerList({
    required this.id,
    required this.createdAt,
    required this.organization,
    required this.organizationId,
    required this.containerMapping,
    required this.price,
    required this.address,
    required this.city,
    required this.design,
    required this.informations,
  });

  factory MyContainerList.fromJson(Map<String, dynamic> json) {
    return MyContainerList(
      id: json['id'],
      createdAt: json['createdAt'],
      organization: json['organization'],
      organizationId: json['organizationId'],
      containerMapping: json['containerMapping'],
      price: json['price'],
      address: json['address'],
      city: json['city'],
      design: json['design'],
      informations: json['informations'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'organization': organization,
      'organizationId': organizationId,
      'containerMapping': containerMapping,
      'price': price,
      'address': address,
      'city': design,
      'informations': informations,
    };
  }
}

/// ContainerCards
///
/// Component to create card for the container list
/// [container] : Data of the container
class ContainerCard extends StatelessWidget {
  final MyContainerList container;
  const ContainerCard({super.key, required this.container});

  /// [Widget] : build the Card component
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 7, right: 7),
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          decoration: BoxDecoration(
            color: Provider.of<ThemeService>(context).isDark
                ? darkTheme.colorScheme.background.withOpacity(0.8)
                : lightTheme.colorScheme.background.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xff4682B4).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          width: screenFormat == ScreenFormat.desktop
              ? desktopContainerWidth
              : tabletContainerWidth,
          child: Column(
            children: [
              ListTile(
                title: Container(
                  child: Row(
                    children: [
                      Text(
                        "Ville : ${container.city != null ? container.city! : "inconnue"}",
                        style: TextStyle(
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize),
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  "Prix du conteneur : ${container.price.toString()} €",
                  style: TextStyle(
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopFontSize
                          : tabletFontSize),
                ),
                leading: Image.asset(
                  'assets/container.png',
                  width: imageWidth,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
