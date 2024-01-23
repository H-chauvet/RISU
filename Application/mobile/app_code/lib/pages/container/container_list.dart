import 'package:flutter/material.dart';

import 'details_page.dart';

class ContainerList {
  final String id;
  final dynamic createdAt;
  final dynamic? containerMapping;
  final double? price;
  final String? adress;
  final String? city;
  final String? designs;
  final dynamic? items;
  final String? informations;
  final bool? paid;
  final String? saveName;

  ContainerList({
    required this.id,
    required this.createdAt,
    required this.containerMapping,
    required this.price,
    required this.adress,
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
      adress: json['adress'],
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
      'adress': adress,
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
                  title: container.city != null ? Text(container.city!) : null,
                  subtitle: container.adress != null ? Text(container.adress!) : null,
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
