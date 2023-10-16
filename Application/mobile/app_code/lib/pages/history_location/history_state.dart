import 'package:flutter/material.dart';
import 'package:risu/pages/history_location/article_location.dart';
import 'package:risu/pages/history_location/history_page.dart';

class HistoryLocationState extends State<HistoryLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30), // Espace ajouté
                Text(
                  'Historique de locations', // Texte "Paramètres"
                  style: TextStyle(
                    fontSize: 36, // Taille de la police
                    fontWeight: FontWeight.bold, // Gras
                    color: Color(0xFF4682B4),
                  ),
                ),
                SizedBox(height: 30), // Espace ajouté

                Column(
                  children: [
                    ArticleLocation(),
                    ArticleLocation(),
                    ArticleLocation(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
