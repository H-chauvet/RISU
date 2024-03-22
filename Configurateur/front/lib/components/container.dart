import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/screens/company-profil/container-profil.dart';
import 'package:front/screens/container-list/item-list/item_list.dart';
import 'package:go_router/go_router.dart';

class CtnList {
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

  CtnList({
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

  factory CtnList.fromJson(Map<String, dynamic> json) {
    return CtnList(
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
  final CtnList container;
  final Function(CtnList) onDelete;
  final String page;

  const ContainerCards(
      {super.key, required this.container, required this.onDelete, required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(page, extra: container);
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title: container.city != null
                    ? Text("Ville : ${container.city!}")
                    : Text("Ville : pas de ville associé"),
                subtitle: container.address != null
                    ? Text("adresse : ${container.address!}")
                    : Text("adresse : pas de address"),
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
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => context.go(page, extra: jsonEncode(container)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
