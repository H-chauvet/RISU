import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/screens/company-profil/container-profil.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:go_router/go_router.dart';

class ContainerListData {
  final int? id;
  final dynamic? createdAt;
  final dynamic? organization;
  final int? organizationId;
  final dynamic? containerMapping;
  final double? price;
  final String? address;
  final String? city;
  final String? design;
  final String? informations;
  final String? saveName;

  ContainerListData({
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
    required this.saveName,
  });

  factory ContainerListData.fromJson(Map<String, dynamic> json) {
    return ContainerListData(
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
      saveName: json['saveName'],
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
      'city': city,
      'design': design,
      'informations': informations,
      'saveName': saveName,
    };
  }
}

class ContainerCards extends StatelessWidget {
  final ContainerListData container;
  final Function(ContainerListData) onDelete;
  final String page;

  late ContainerListData ctnInfo;

  ContainerCards(
      {super.key,
      required this.container,
      required this.onDelete,
      required this.page});

  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return GestureDetector(
      onTap: () {
        if (container.id != null) {
          storageService.writeStorage(
            'containerId',
            container.id.toString(),
          );
        }
        context.go(page, extra: container);
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title: container.city != null
                    ? Text(
                        "Ville : ${container.city!}",
                        style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      )
                    : Text(
                        "Ville : Pas de ville associée",
                        style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
                subtitle: container.address != null
                    ? Text(
                        "Adresse : ${container.address!}",
                        style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      )
                    : Text(
                        "Adresse : Aucune adresse",
                        style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(container),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => context.go(page, extra: container),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}