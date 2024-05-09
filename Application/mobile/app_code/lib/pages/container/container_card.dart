import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/utils/providers/theme.dart';

class ContainerList {
  final int id;
  final String? address;
  final String? city;
  final double? longitude;
  final double? latitude;
  final int itemCount;

  ContainerList({
    required this.id,
    required this.address,
    required this.city,
    required this.longitude,
    required this.latitude,
    required this.itemCount,
  });

  factory ContainerList.fromJson(Map<String, dynamic> json) {
    return ContainerList(
      id: json['id'],
      address: json['address'],
      city: json['city'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      itemCount: json['_count']['items']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'city': city,
      'itemCount': itemCount,
    };
  }
}

class ContainerCard extends StatelessWidget {
  final ContainerList container;
  final Function(int?) onDirectionClicked;

  const ContainerCard({
    super.key,
    required this.container,
    required this.onDirectionClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('container-list_card'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleListPage(containerId: container.id),
          ),
        );
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0),
        child: Card(
          elevation: 5,
          shadowColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      container.city!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      container.address!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.directions),
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.primaryColor),
                        onPressed: () {
                          onDirectionClicked(container.id);
                        },
                      ),
                      const Icon(Icons.chevron_right),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
