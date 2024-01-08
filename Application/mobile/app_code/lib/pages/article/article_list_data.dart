import 'package:flutter/material.dart';
import 'package:risu/pages/article/details_page.dart';

class ArticleData {
  final String id;
  final String containerId;
  final String name;
  final bool available;
  final int price;

  ArticleData({
    required this.id,
    required this.containerId,
    required this.name,
    required this.available,
    required this.price,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    return ArticleData(
      id: json['id'],
      containerId: json['containerId'],
      name: json['name'],
      available: json['available'],
      price: json['price'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'containerId': containerId,
      'name': name,
      'available': available,
      'price': price,
    };
  }
}

class ArticleDataCard extends StatelessWidget {
  final ArticleData articleData;

  ArticleDataCard({super.key, required this.articleData});

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
        margin:
            EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
        alignment: Alignment.center,
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xff4682B4).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      articleData.name,
                      style: TextStyle(
                        color: Color(0xFF4682B4),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Prix : ' + articleData.price.toString() + '€ de l\'heure',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Statut: ',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          articleData.available == true
                              ? 'Disponible'
                              : 'Indisponible',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: articleData.available == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
