// import 'dart:ffi';

import 'package:flutter/material.dart';

/// Représente un item.
class ItemList {
  final int? id;
  final dynamic? name;
  final bool? available;
  final int? container;
  final dynamic? createdAt;
  final dynamic? containerId;
  final double? price;
  final String? image;
  final String? description;

  /// Crée une nouvelle instance de [ItemList].
  ///
  /// [id] : Contient l'id d'un objet
  /// [name] : Contient le nom d'un objet
  /// [available] : Explique si l'objet est disponible ou non
  /// [container] : Contient le conteneur dans lequel l'objet est.
  /// [createdAt] : Contient la date de création de l'objet
  /// [containerId] : Contient l'id du conteneur dans lequel l'objet est.
  /// [price] : Contient le prix de l'objet
  /// [image] : Contient l'image de l'objet
  /// [description] : Contient la description de l'objet
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

  /// Crée une instance de [ItemList] à partir d'un objet JSON.
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

  /// Convertit l'objet en une carte JSON.
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

/// Widget représentant une carte d'objet.
class ItemCard extends StatelessWidget {
  final ItemList item;
  final Function(ItemList) onDelete;

  /// Crée une nouvelle instance de [ItemCard].
  ///
  /// [item] : informations de l'objet stockées.
  /// [onDelete] : permet de supprimer un objet.
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
