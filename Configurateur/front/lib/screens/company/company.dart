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

  MyContainerList({required this.id});

  factory MyContainerList.fromJson(Map<String, dynamic> json) {
    return MyContainerList(
      id: json['id'],
    );
  }
}

class ProductCard extends StatelessWidget {
  

  const ProductCard({required this.user});

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
                title: Text(user.id.toString()),
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
  List<MyContainerList> users = [];
  late List<String> members = [
    'assets/Henri.png',
    'assets/Louis.png',
    'assets/Hugo.png',
    'assets/Quentin.png',
    'assets/Tanguy.png',
    'assets/Cédric.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchContainers();
  }

  Future<void> fetchContainers() async {
    final response =
        await http.get(Uri.parse('http://${serverIp}:3000/api/container/listAll'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> usersData = responseData["user"];
      setState(() {
        users = usersData.map((data) => MyContainerList.fromJson(data)).toList();
      });
    } else {
      // Fluttertoast.showToast(
      //   msg: 'Erreur lors de la récupération: ${response.statusCode}',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
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
          const Text("Notre équipe :",
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
              members.length,
              (index) => Column(children: [
                  Image.asset(
                    members[index],
                    width: 95,
                    height: 95,
                ),
                const SizedBox(height: 5,),
                Text(
                  members[index].substring(members[index].indexOf('/') + 1, members[index].indexOf('.')).toUpperCase(),
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
          ListView.builder(
              shrinkWrap:
                  true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final product = users[index];
                return ProductCard(
                  user: product,
                  onDelete: deleteContainer,
                );
              },
            ),
        ],
      ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
