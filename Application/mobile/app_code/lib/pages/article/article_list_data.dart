import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/utils/image_loader.dart';

class ArticleData {
  final int id;
  final int containerId;
  final String name;
  final bool available;
  final double price;
  final List categories;
  final List<dynamic>? imagesUrl;

  ArticleData({
    required this.id,
    required this.containerId,
    required this.name,
    required this.available,
    required this.price,
    required this.categories,
    this.imagesUrl,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    double price = json['price'] != null ? json['price'].toDouble() : 0.0;
    List<dynamic>? imagesUrl;
    if (json['imageUrl'] is String) {
      imagesUrl = [json['imageUrl']];
    } else if (json['imageUrl'] is List) {
      imagesUrl = json['imageUrl'];
    }
    return ArticleData(
      id: json['id'],
      containerId: json['containerId'],
      name: json['name'],
      available: json['available'],
      price: price,
      categories: json['categories'],
      imagesUrl: imagesUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'containerId': containerId,
      'name': name,
      'available': available,
      'price': price,
      'categories': categories,
      'imageUrl': imagesUrl,
    };
  }
}

class ArticleDataCard extends StatelessWidget {
  final ArticleData articleData;

  const ArticleDataCard({
    super.key,
    required this.articleData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('articles-list_card'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailsPage(
              articleId: articleData.id,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Transform.scale(
                  scale: 1.0,
                  child: loadImageFromURL(articleData.imagesUrl?[0]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      articleData.name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!
                          .priceXPerHour(articleData.price.toStringAsFixed(2)),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.status}: ",
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: articleData.available
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          articleData.available
                              ? AppLocalizations.of(context)!.available
                              : AppLocalizations.of(context)!.unavailable,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${AppLocalizations.of(context)!.category}: ${articleData.categories.map((category) => category['name']).join(", ")}",
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
