import 'package:flutter/material.dart';
import 'package:front/components/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:front/components/custom_app_bar.dart';
// import 'package:front/components/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:front/network/informations.dart';

class MyContainerList {
  final int? id;
  final dynamic? createdAt;
  final dynamic? organization;
  final int? organizationId;
  final dynamic? containerMapping;
  final double? price;

  MyContainerList({
    required this.id,
    required this.createdAt,
    required this.organization,
    required this.organizationId,
    required this.containerMapping,
    required this.price,
  });

  factory MyContainerList.fromJson(Map<String, dynamic> json) {
    return MyContainerList(
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
  final MyContainerList container;

  const ContainerCard({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
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
          width: 300,
          child: Column(
            children: [
              ListTile(
                title: const Text("name"),
                leading: Image.asset(
                  'assets/container.png',
                  width: 150,
                ),
              ),
              Text(container.price.toString()),
            ],
          ),
        ),
      ],
    );
  }
}