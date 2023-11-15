import 'package:flutter/material.dart';
import 'package:front/components/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:front/network/informations.dart';

class MyContainerList {
  final int id;
  final String? containerMapping;

  MyContainerList({required this.id, required this.containerMapping});

  factory MyContainerList.fromJson(Map<String, dynamic> json) {
    return MyContainerList(
      id: json['id'],
      containerMapping: json['containerMapping'],
    );
  }
}

class ProductCard extends StatelessWidget {
  final MyContainerList product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
          width: 300,
          child: Column(
            children: [
              ListTile(
                title: Text('${product.id}'),
                leading: Image.asset(
                  'assets/container.png', // Remplacez 'mon_image.png' par le chemin de votre image.
                  width: 150, // Largeur de l'image
                ),
              ),
              const Text('Price: 10'),
            ],
          ),
        ),
      ],
    );
  }
}

class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  State<CompanyPage> createState() => CompanyPageState();
}

class CompanyPageState extends State<CompanyPage> {
  late List<String> products = [
    'assets/henri.png',
    'assets/louis.png',
    'assets/hugo.png',
    'assets/quentin.png',
    'assets/tanguy.png',
    'assets/cédric.png',
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<List<MyContainerList>> fetchData() async {
    final response = await http
        .get(Uri.parse('http://$serverIp:3000/api/container/list-container'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<MyContainerList> containerList = data.map((json) {
        MyContainerList container = MyContainerList.fromJson(json);
        return container;
      }).toList();
      return containerList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Entreprise',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          SizedBox(height:  15,),
          const Text("Nos Conteneurs :",
            style: TextStyle(
              color: Color.fromRGBO(70, 130, 180, 1),
              fontSize: 30,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationThickness: 2.0,
              decorationStyle: TextDecorationStyle.solid,
            )),
          SizedBox(height:  70,),
          Center(child: Wrap(
            spacing: 70.0,
            runSpacing: 20.0,
            children: List.generate(
              products.length,
              (index) => Column(children: [
                  Image.asset(
                    products[index],
                    width: 95,
                    height: 95,
                ),
                const SizedBox(height: 5,),
                Text(
                  products[index].substring(products[index].indexOf('/') + 1, products[index].indexOf('.')).toUpperCase(),
                  style: const TextStyle(
                    color: Color.fromRGBO(70, 130, 180, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ),
          ),
          ),
          SizedBox(height: 80,),
          const Text("Nos Conteneurs :",
              style: TextStyle(
                color: Color.fromRGBO(70, 130, 180, 1),
                fontSize: 30,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationThickness: 2.0,
                decorationStyle: TextDecorationStyle.solid,
              )),
          SizedBox(height: 80,),
          FutureBuilder<List<MyContainerList>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                print('Stack trace:\n${snapshot.stackTrace}');
                return Text('Error occurred. See console for details.');
              } else {
                List<MyContainerList> data = snapshot.data!;
                if (data.isEmpty) {
                  return (const Center(
                    child: Center(child: Text("Aucun conteneur n'a été créer"),)
                  ));
                }
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Wrap(
                      spacing: 50.0,
                      runSpacing: 20.0,
                      children: List.generate(
                        data.length,
                        (index) => ProductCard(product: data[index]),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
