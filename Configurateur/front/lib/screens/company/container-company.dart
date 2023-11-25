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

class ProductCard extends StatelessWidget {
  final MyContainerList product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.white, // Couleur du conteneur
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xff4682B4).withOpacity(0.5), // Shadow color
                spreadRadius: 5, // How much the shadow should spread
                blurRadius: 7, // How blurry the shadow should be
                offset: Offset(0, 3), // Shadow offset
              ),
            ],
          ),
          width: 300,
          child: Column(
            children: [
              ListTile(
                title: Text(product.id.toString()),
                leading: Image.asset(
                  'assets/container.png', // Remplacez 'mon_image.png' par le chemin de votre image.
                  width: 150, // Largeur de l'image
                ),
              ),
              const Text('Price: 10'),
            ],
          ),
        ),
      ],
    );
  }
}