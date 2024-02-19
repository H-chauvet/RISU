import 'package:flutter/material.dart';
import 'package:front/components/items.dart';
import 'package:front/screens/container-list/item-list/item_list.dart';

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

class ContainerCards extends StatelessWidget {
  final CtnList container;
  final Function(CtnList) onDelete;

  const ContainerCards(
      {super.key, required this.container, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemPages(container: container,),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text("id du conteneur : " + container.id.toString()),
                  subtitle:
                      Text("prix du conteneur : " + container.price.toString()),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => onDelete(container),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      if (container.city != null) Text(container.city!),
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
