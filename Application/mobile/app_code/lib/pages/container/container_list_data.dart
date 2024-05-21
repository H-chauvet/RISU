import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/utils/providers/theme.dart';

class ContainerList {
  final int id;
  final String address;
  final String city;
  final double longitude;
  final double latitude;
  final int itemCount;
  double distance;

  ContainerList({
    required this.id,
    required this.address,
    required this.city,
    required this.longitude,
    required this.latitude,
    required this.itemCount,
    this.distance = 0,
  });

  factory ContainerList.fromJson(Map<String, dynamic> json) {
    return ContainerList(
        id: json['id'],
        address: json['address'],
        city: json['city'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        itemCount: json['_count']['items']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'city': city,
      'longitude': longitude,
      'latitude': latitude,
      'itemCount': itemCount,
      'distance': distance,
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

  String showDistance(BuildContext context, double distance) {
    if (distance < 10) {
      return AppLocalizations.of(context)!.containerDistanceLess10;
    } else if (distance > 1000) {
      return AppLocalizations.of(context)!
          .containerDistanceKm((distance / 1000).round());
    }
    return AppLocalizations.of(context)!.containerDistanceM(distance.round());
  }

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
        margin: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
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
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/logo.png'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          container.city,
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
                        Text(
                          AppLocalizations.of(context)!
                              .howManyAvailableArticles(container.itemCount),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          showDistance(context, container.distance),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
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
                        key: Key(
                            'container-list_icon-localization-${container.id}'),
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
