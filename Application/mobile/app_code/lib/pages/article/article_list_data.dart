import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/utils/providers/theme.dart';

class ArticleData {
  final int id;
  final int containerId;
  final String name;
  final bool available;
  final int price;
  final List categories;

  ArticleData({
    required this.id,
    required this.containerId,
    required this.name,
    required this.available,
    required this.price,
    required this.categories,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    return ArticleData(
      id: json['id'],
      containerId: json['containerId'],
      name: json['name'],
      available: json['available'],
      price: json['price'],
      categories: json['categories'],
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
    };
  }
}

class ArticleDataCard extends StatelessWidget {
  final ArticleData articleData;

  const ArticleDataCard({Key? key, required this.articleData})
      : super(key: key);

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
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(
            left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
        alignment: Alignment.center,
        height: 150.0,
        decoration: BoxDecoration(
          color: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.cardColor),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: context
                  .select((ThemeProvider themeProvider) => themeProvider
                      .currentTheme.bottomNavigationBarTheme.selectedItemColor!)
                  .withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 0.6,
              child: Image.asset('assets/volley.png'),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Transform.scale(
                  scale: 0.6,
                  child: Image.asset('assets/volley.png'),
                ),
              ),
              const SizedBox(width: 20),
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
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!
                          .priceXPerHour(articleData.price),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(height: 10),
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
                        const SizedBox(width: 5),
                        Text(
                          articleData.available
                              ? AppLocalizations.of(context)!.available
                              : AppLocalizations.of(context)!.unavailable,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
