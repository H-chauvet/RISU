// import 'dart:ffi';

import 'package:flutter/material.dart';

class ItemList {
  final int? id;
  final dynamic name;
  final bool? available;
  final int? container;
  final dynamic createdAt;
  final dynamic containerId;
  final double? price;
  final String? image;
  final String? description;

  ItemList({
    required this.id,
    required this.name,
    required this.available,
    required this.container,
    required this.createdAt,
    required this.containerId,
    required this.price,
    required this.image,
    required this.description,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      id: json['id'],
      name: json['name'],
      available: json['available'],
      container: json['container'],
      createdAt: json['createdAt'],
      containerId: json['containerId'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
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
    };
  }
}

class ItemCard extends StatelessWidget {
  final ItemList item;
  final Function(ItemList) onDelete;

  const ItemCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(item.id.toString()),
            subtitle: Text(item.name),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(item),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (item.description != null) Text(item.description!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
