import 'package:flutter/material.dart';
import 'details_page.dart';

class ContainerList {
  final int? id;
  final dynamic? createdAt;
  final dynamic? organization;
  final int? organizationId;
  final dynamic? containerMapping;
  final int? price;

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

  const ContainerCard({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('container-list_card'),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute( // id must be the same from web to mobile
              builder: (context) => ContainerDetailsPage(containerId: container.id.toString())
            ));
      },
      child: Container(
      height: 120,
      margin: EdgeInsets.only(right:25.0, left: 25.0, top: 10.0), // Adjust the padding here
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
              title: Text(container.id.toString()),
              // subtitle: Text(container.price.toString()),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10,
                  ),
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