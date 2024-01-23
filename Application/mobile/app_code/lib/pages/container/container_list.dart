import 'package:flutter/material.dart';

import 'details_page.dart';

class ContainerList {
  final String id;
  final String localization;
  final String owner;
  // final dynamic createdAt;
  // final dynamic organization;
  // final int? organizationId;
  // final dynamic? containerMapping;
  // final double? price;
  // final String? adress;
  // final String? city;
  // final String? design;
  // final String? image;
  // final String? informations;

  ContainerList({
    required this.id,
    required this.localization,
    required this.owner,
    // required this.createdAt,
    // required this.organization,
    // required this.organizationId,
    // required this.containerMapping,
    // required this.price,
    // required this.adress,
    // required this.city,
    // required this.design,
    // required this.image,
    // required this.informations,
  });

  factory ContainerList.fromJson(Map<String, dynamic> json) {
    return ContainerList(
      id: json['id'],
      localization: json['localization'],
      owner: json['owner'],
      // createdAt: json['createdAt'],
      // organization: json['organization'],
      // organizationId: json['organizationId'],
      // containerMapping: json['containerMapping'],
      // price: json['price'],
      // adress: json['adress'],
      // city: json['city'],
      // design: json['design'],
      // image: json['image'],
      // informations: json['informations'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'localization': localization,
      'owner': owner,
      // 'createdAt': createdAt,
      // 'organization': organization,
      // 'organizationId': organizationId,
      // 'containerMapping': containerMapping,
      // 'price': price,
      // 'adress': adress,
      // 'city': design,
      // 'image': image,
      // 'informations': informations,
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
                // id must be the same from web to mobile
                builder: (context) => ContainerDetailsPage(
                    containerId: container.id)));
      },
      child: Container(
        height: 120,
        margin: EdgeInsets.only(
            right: 25.0, left: 25.0, top: 10.0), // Adjust the padding here
        child: Container(
          child: Card(
            elevation: 5,
            shadowColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                ListTile(
                  title: container.localization != null ? Text(container.localization!) : null,
                  subtitle: container.owner != null ? Text(container.owner!) : null,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text("prix : " + "test" /* container.price.toString() */),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
