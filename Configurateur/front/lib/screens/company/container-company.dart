import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:front/components/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:front/components/custom_app_bar.dart';;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:front/network/informations.dart';
import 'package:provider/provider.dart';

class MyContainerList {
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

class ContainerCard extends StatelessWidget {
  final MyContainerList container;

  const ContainerCard({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 7, right: 7),
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          decoration: BoxDecoration(
            color: Provider.of<ThemeService>(context).isDark ?
              darkTheme.colorScheme.background.withOpacity(0.8) : lightTheme.colorScheme.background.withOpacity(0.8),
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
          width: 350,
          child: Column(
            children: [
              ListTile(
                title: Container(
                  child: Row(
                    children: [
                      Text("Ville : ${container.city != null ? container.city! : "inconnue"}",
                      ),
                    ],
                  ),
                ),
                subtitle:
                    Text("prix du conteneur : " + container.price.toString()),
                leading: Image.asset(
                  'assets/container.png',
                  width: 150,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
