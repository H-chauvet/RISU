import 'package:flutter/material.dart';

class ArticleLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
      alignment: Alignment.center,
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.white, // Couleur du conteneur
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Color(0xff4682B4).withOpacity(0.5), // Shadow color
            spreadRadius: 5, // How much the shadow should spread
            blurRadius: 7, // How blurry the shadow should be
            offset: Offset(0, 3), // Shadow offset
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 0.6, // Facteur d'échelle pour réduire la taille à 50%
            child: Image.asset('assets/volley.png'), // Remplacez 'your_image.png' par le chemin de votre image
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("Ballon de volley",
                    style: TextStyle(
                      color: Color(0xFF4682B4),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              Text('La Baule - Casier N°A4',
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
                  Text('Date: ',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  Text('13/09/2023',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Durée: ',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  Text('1:45 h',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Statut: ',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  Row(
                    children: [
                      Text('En cours',
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
    );
  }
}
