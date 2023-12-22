// import 'dart:ffi';

import 'package:flutter/material.dart';

class ObjectList {
  final int? id;
  final dynamic? name;
  final bool? available;
  final int? container;
  final dynamic? createdAt;
  final dynamic? containerId;
  final double? price;

  ObjectList({
    required this.id,
    required this.name,
    required this.available,
    required this.container,
    required this.createdAt,
    required this.containerId,
    required this.price,
  });

  factory ObjectList.fromJson(Map<String, dynamic> json) {
    return ObjectList(
      id: json['id'],
      name: json['name'],
      available: json['available'],
      container: json['container'],
      createdAt: json['createdAt'],
      containerId: json['containerId'],
      price: json['price'],
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
    };
  }
}

class ObjectCard extends StatelessWidget {
  final ObjectList object;
  final Function(ObjectList) onDelete;

  const ObjectCard({super.key, required this.object, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(object.id.toString()),
            subtitle: Text(object.name),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(object),
                ),
              SizedBox(width: 10,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
