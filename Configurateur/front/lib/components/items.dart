import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/container-list/container_web.dart';
// import 'package:front/screens/container-list/container_web.dart';
import 'package:front/screens/container-list/item-list/item_component.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ItemPages extends StatefulWidget {
  final CtnList container;
  const ItemPages({Key? key, required this.container}) : super(key: key);

  @override
  _ItemPagesState createState() => _ItemPagesState(container: container);
}

class _ItemPagesState extends State<ItemPages> {
  final CtnList container;
  _ItemPagesState({required this.container});
  List<ItemList> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final response = await http.get(
      Uri.parse(
          'http://${serverIp}:3000/api/items/listAll?containerId=${container.id}'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> itemsData = responseData["item"];
      setState(() {
        items = itemsData.map((data) => ItemList.fromJson(data)).toList();
      });
    } else {}
  }

  Future<void> deleteItem(ItemList message) async {
    final Uri url = Uri.parse("http://${serverIp}:3000/api/items/delete");
    final response = await http.post(
      url,
      body: json.encode({'id': message.id}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Message supprimé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      fetchItems();
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la suppression du message: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(
        'Gestion des conteneurs',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300,
                height: 200,
                child: Card(
                  child: Row(
                    children: [
                      Image.asset("assets/logo.png"),
                      Column(
                        children: [
                          if (container != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nom de l\'entreprise : ${container.city ?? 'N/A'}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Type de l\'entreprise : ${container.address ?? 'N/A'}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          if (container == null)
                            Text(
                              'Les informations de l\'entreprise ne sont pas disponibles.',
                              style: TextStyle(fontSize: 18),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Text("Nos Conteneurs :",
                  style: TextStyle(
                    color: Color.fromRGBO(70, 130, 180, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                    decorationStyle: TextDecorationStyle.solid,
                  )),
              SizedBox(
                height: 65,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final product = items[index];
                  return ItemCard(
                    item: product,
                    onDelete: deleteItem,
                  );
                  // return Text("$itemId");
                },
              ),
            ],
          ),
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       const SizedBox(
      //         height: 30,
      //       ),
      //
      //     ],
      //   ),
      // ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
