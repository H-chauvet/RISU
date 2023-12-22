// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:front/screens/container-list/object-list/object_list.dart';

class ContainerList {
  final int? id;
  final dynamic? createdAt;
  final dynamic? organization;
  final int? organizationId;
  final dynamic? containerMapping;
  final double? price;

  ContainerList({
    required this.id,
    required this.createdAt,
    required this.organization,
    required this.organizationId,
    required this.containerMapping,
    required this.price,
  });

  factory ContainerList.fromJson(Map<String, dynamic> json) {
    return ContainerList(
      id: json['id'],
      createdAt: json['createdAt'],
      organization: json['organization'],
      organizationId: json['organizationId'],
      containerMapping: json['containerMapping'],
      price: json['price'],
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
    };
  }
}

class ContainerCard extends StatelessWidget {
  final ContainerList container;
   final Function(ContainerList) onDelete;

  const ContainerCard({super.key, required this.container, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Action à effectuer lorsqu'on clique sur la carte
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ObjectPage(containerId: container.id),
            ),
          );
        },
        child: Card(
          child: ListTile(
            title: Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(container.id.toString()),
                    subtitle: Text(container.price.toString()),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => onDelete(container),
                        ),
                      SizedBox(width: 10,),
                      Text("name"),
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
