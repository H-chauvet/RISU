import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';

import 'details_page.dart';

class ContainerList {
  final int id;
  final dynamic createdAt;
  final dynamic containerMapping;
  final double? price;
  final String? address;
  final String? city;
  final String? designs;
  final dynamic items;
  final String? informations;
  final bool? paid;
  final String? saveName;

  ContainerList({
    required this.id,
    required this.createdAt,
    required this.containerMapping,
    required this.price,
    required this.address,
    required this.city,
    required this.designs,
    required this.items,
    required this.informations,
    required this.paid,
    required this.saveName,
  });

  factory ContainerList.fromJson(Map<String, dynamic> json) {
    return ContainerList(
      id: json['id'],
      createdAt: json['createdAt'],
      containerMapping: json['containerMapping'],
      price: json['price'],
      address: json['address'],
      city: json['city'],
      designs: json['designs'],
      items: json['items'],
      informations: json['informations'],
      paid: json['paid'],
      saveName: json['saveName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'containerMapping': containerMapping,
      'price': price,
      'address': address,
      'city': city,
      'designs': designs,
      'items': items,
      'informations': informations,
      'paid': paid,
      'saveName': saveName,
    };
  }
}

class ContainerCard extends StatelessWidget {
  final ContainerList container;

  const ContainerCard({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('container-list_card'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ContainerDetailsPage(containerId: container.id),
          ),
        );
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0),
        child: Card(
          elevation: 5,
          shadowColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              ListTile(
                title: container.city != null ? Text(container.city!) : null,
                subtitle:
                    container.address != null ? Text(container.address!) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
