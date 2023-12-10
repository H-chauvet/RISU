import 'package:flutter/material.dart';
import 'package:risu/utils/check_signin.dart';
import 'rent_page.dart';

class Article extends StatelessWidget {
  final String article_name;
  final int articlePrice;

  const Article({
    Key? key,
    required this.article_name,
    required this.articlePrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool signIn = await checkSignin(context);
        if (signIn == false) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentArticlePage(
              name: article_name,
              price: articlePrice,
              containerId: 1,
              locations: ['La Baule - Casier N°A4'],
            ),
          ),
        );
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
                      article_name,
                      style: TextStyle(
                        color: Color(0xFF4682B4),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                Text(
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
                      'Prix: ' + articlePrice.toString() + '€/Heure',
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
                          'Disponible',
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
                            color: Colors.green,
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
