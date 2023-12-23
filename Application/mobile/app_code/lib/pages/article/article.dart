import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:risu/globals.dart';

import 'rent_page.dart';

class Article extends StatefulWidget {
  final String articleName;
  final int articlePrice;

  Article({
    Key? key,
    required this.articleName,
    required this.articlePrice,
  }) : super(key: key);

  @override
  _ArticleState createState() => _ArticleState(
        articleName: articleName,
        articlePrice: articlePrice,
      );
}

class _ArticleState extends State<Article> {
  bool available = true;
  late List<dynamic> locations;
  final String articleName;
  final int articlePrice;

  _ArticleState({
    Key? key,
    required this.articleName,
    required this.articlePrice,
  });

  void getLocations() async {
    try {
      final response = await http.get(
        Uri.parse('http://$serverIp:8080/api/locations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 201) {
        locations = jsonDecode(response.body)['locations'];
        if (locations.length > 0) {
          searchAvailable();
        }
      } else {
        print('Error getLocations(): ${response.statusCode}');
      }
    } catch (e) {
      print('Error getLocations(): $e');
    }
  }

  void searchAvailable() {
    DateTime now = DateTime.now();
    for (var location in locations) {
      DateTime createdAt = DateTime.parse(location['createdAt']);
      int duration = location['duration'];
      DateTime endTime = createdAt.add(Duration(hours: duration));
      if (!now.isAfter(endTime)) {
        setState(() {
          available = false;
        });
        return;
      }
    }

    setState(() {
      available = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentArticlePage(
              name: articleName,
              price: articlePrice,
              containerId: 1,
              locations: ['La Baule - Casier N°A4'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
            left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
        alignment: Alignment.center,
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff4682B4).withOpacity(0.5),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      articleName,
                      style: const TextStyle(
                        color: Color(0xFF4682B4),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const Text(
                  'La Baule - Casier N°A4',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Prix: $articlePrice€/Heure',
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Statut: ',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          available == true ? 'Disponible' : 'Indisponible',
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                available == true ? Colors.green : Colors.red,
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
