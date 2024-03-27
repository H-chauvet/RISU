import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
// import 'package:front/screens/container-list/container_web.dart';
import 'package:front/screens/container-list/item-list/item_component.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ItemPage extends StatefulWidget {
  final int? containerId;
  const ItemPage({Key? key, required int? this.containerId}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState(containerId: containerId);
}

class _ItemPageState extends State<ItemPage> {
  final int? containerId;
  _ItemPageState({required this.containerId});
  List<ItemList> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final response = await http.get(
      Uri.parse(
          'http://${serverIp}:3000/api/items/listAll?containerId=$containerId'),
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
      appBar: CustomAppBar(
        'Gestion des conteneurs',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
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
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
