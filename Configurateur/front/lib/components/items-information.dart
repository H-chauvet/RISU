import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:http/http.dart' as http;

class ItemListInfo {
  final int? id;
  final dynamic? name;
  final bool? available;
  final int? container;
  final dynamic? createdAt;
  final dynamic? containerId;
  final double? price;
  final String? image;
  final String? description;
  final String? category;

  ItemListInfo({
    required this.id,
    required this.name,
    required this.available,
    required this.container,
    required this.createdAt,
    required this.containerId,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  factory ItemListInfo.fromJson(Map<String, dynamic> json) {
    return ItemListInfo(
      id: json['id'],
      name: json['name'],
      available: json['available'],
      container: json['container'],
      createdAt: json['createdAt'],
      containerId: json['containerId'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'available': available,
      'container': container,
      'createdAt': createdAt,
      'containerId': containerId,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
    };
  }
}
