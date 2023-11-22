import 'package:flutter/material.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/pages/article/article.dart';

class ArticleListState extends State<ArticleListPage> {
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
                SizedBox(height: 30),
                Text(
                  'Liste des articles',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Article(
                      article_name: 'Ballon de volley',
                      articlePrice: 2,
                    ),
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
