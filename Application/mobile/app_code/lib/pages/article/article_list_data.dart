import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/utils/image_loader.dart';

enum Status {
  GOOD,
  WORN,
  VERYWORN,
}

/// ArticleData class.
/// This class is used to store the data of an article.
/// params:
/// [id] - the id of the article.
/// [containerId] - the id of the container.
/// [name] - the name of the article.
/// [available] - the availability of the article.
/// [price] - the price of the article.
/// [categories] - the categories of the article.
/// returns:
/// [ArticleData] - an article data object.
class ArticleData {
  final int id;
  final int containerId;
  final String name;
  final bool available;
  final double price;
  final List categories;
  final Status status;
  final String? description;
  final List<dynamic>? imagesUrl;

  ArticleData({
    required this.id,
    required this.containerId,
    required this.name,
    required this.available,
    required this.price,
    required this.categories,
    required this.status,
    this.description,
    this.imagesUrl,
  });

  /// Factory method to create an ArticleData object from a JSON object
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
      status: Status.values.byName(json['status'] ?? 'VERYWORN'),
      description: json['description'] ?? "",
      imagesUrl: imagesUrl,
    );
  }

  /// Method to convert an ArticleData object to a JSON object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'containerId': containerId,
      'name': name,
      'available': available,
      'price': price,
      'categories': categories,
      'status': status,
      'description': description,
      'imageUrl': imagesUrl,
    };
  }
}

/// ArticleDataCard class.
/// This class is used to display the data of an article in a card.
/// It is used in the ArticleListPage.
/// params:
/// [articleData] - the data of the article to display.
class ArticleDataCard extends StatelessWidget {
  final ArticleData articleData;

  const ArticleDataCard({
    super.key,
    required this.articleData,
  });

  IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'beach':
        return Icons.beach_access;
      case 'sports':
        return Icons.sports_soccer;
      default:
        return Icons.category;
    }
  }

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
        color: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.inputDecorationTheme.fillColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: SizedBox(
                      key: const Key('article_image'),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: loadImageFromURL(articleData.imagesUrl?[0]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        key: const Key('article_availability-circle'),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              articleData.available ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        key: const Key('article_availability-text'),
                        articleData.available
                            ? AppLocalizations.of(context)!.available
                            : AppLocalizations.of(context)!.unavailable,
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key: const Key('article_name'),
                      articleData.name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      key: const Key('article_price'),
                      AppLocalizations.of(context)!
                          .priceXPerHour(articleData.price.toStringAsFixed(2)),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      key: const Key('article_categories-title'),
                      '${AppLocalizations.of(context)!.categories} :',
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    Row(
                      key: const Key('article_categories_icons'),
                      children: articleData.categories.map<Widget>((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            getCategoryIcon(category['name']),
                            size: 24.0,
                          ),
                        );
                      }).toList(),
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
