// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:front/screens/container-list/item-list/item_list.dart';

/// Représente un conteneur.
class ContainerList {
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

  /// Crée une nouvelle instance de [ContainerList].
  ///
  /// [id] : Contient l'id d'un avis
  /// [firstName] : Contient le prénom de l'utilisateur
  /// [lastName] : Contient le nom de l'utilsateur
  /// [email] : Contient l'email de l'utilisateur
  /// [message] : Contenu du message de l'utilisateur
  /// [mark] : Contient le nombre de marque de l'utilisateur
  ContainerList({
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

  /// Crée une instance de [ContainerList] à partir d'un objet JSON.
  factory ContainerList.fromJson(Map<String, dynamic> json) {
    return ContainerList(
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

/// Widget représentant une carte d'avis.
class ContainerCard extends StatelessWidget {
  final ContainerList container;
  final Function(ContainerList) onDelete;

  /// Crée une nouvelle instance de [ContainerCard].
  ///
  /// [container] : informations du conteneur stockées.
  /// [onDelete] : permet de supprimer un conteneur.
  const ContainerCard(
      {super.key, required this.container, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemPage(containerId: container.id),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text("Conteneur N° : ${container.id}"),
                  subtitle: Text("Prix de création : ${container.price}"),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => onDelete(container),
                      ),
                      const SizedBox(
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
