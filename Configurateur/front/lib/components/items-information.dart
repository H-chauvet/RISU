// import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/components/items-information.dart';
import 'package:front/screens/container-list/item-list/item_component.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ItemListInfo {
  final int? id;
  final dynamic? name;
  final bool? available;
  final int? container;
  final dynamic? createdAt;
  final dynamic? containerId;
  final double? price;
  final String? image;
  final String? description;
  final String? category;

  ItemListInfo({
    required this.id,
    required this.name,
    required this.available,
    required this.container,
    required this.createdAt,
    required this.containerId,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  factory ItemListInfo.fromJson(Map<String, dynamic> json) {
    return ItemListInfo(
      id: json['id'],
      name: json['name'],
      available: json['available'],
      container: json['container'],
      createdAt: json['createdAt'],
      containerId: json['containerId'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'available': available,
      'container': container,
      'createdAt': createdAt,
      'containerId': containerId,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
    };
  }
}

class ItemPagesModification extends StatefulWidget {
  final ItemListInfo item;
  const ItemPagesModification({Key? key, required this.item}) : super(key: key);

  @override
  _ItemPagesModificationtates createState() =>
      _ItemPagesModificationtates(item: item);
}

class _ItemPagesModificationtates extends State<ItemPagesModification> {
  final ItemListInfo item;
  _ItemPagesModificationtates({required this.item});
  late String itemName = '';
  late String itemDescription = '';
  late double itemPrice;
  late int itemId = item.id!;

  void initState() {
    super.initState();
    if (item.price != null) {
      itemPrice = item.price!;
    }
  }

  Future<void> showEditPopupName(BuildContext context, String initialLastName,
      Function(String) onEdit) async {
    TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier"),
          content: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Nouveau nom", hintText: initialLastName),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                final String apiUrl =
                    "http://$serverIp:3000/api/items/update-name/${item.id}";
                var body = {
                  'name': nameController.text,
                };

                var response = await http.post(
                  Uri.parse(apiUrl),
                  body: body,
                );

                if (response.statusCode == 200) {
                  Fluttertoast.showToast(
                    msg: 'Modification effectuée avec succès',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                  );
                } else {
                  Fluttertoast.showToast(
                      msg:
                          "Erreur durant l'envoi la modification des informations",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red);
                }
                onEdit(nameController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditPopupPrice(BuildContext context, String initialPrice,
      Function(String) onEdit) async {
    TextEditingController priceController = TextEditingController();
    double parsedInitialPrice = double.tryParse(initialPrice) ?? 0.0;
    priceController.text = parsedInitialPrice.toString();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier"),
          content: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      labelText: "Nouveau nom", hintText: initialPrice),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                final String apiUrl =
                    "http://$serverIp:3000/api/items/update-price/${item.id}";
                var body = {
                  'price': priceController.text,
                };

                var response = await http.post(
                  Uri.parse(apiUrl),
                  body: body,
                );

                if (response.statusCode == 200) {
                  Fluttertoast.showToast(
                    msg: 'Modification effectuée avec succès',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                  );
                } else {
                  Fluttertoast.showToast(
                      msg:
                          "Erreur durant l'envoi la modification des informations",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red);
                }
                onEdit(priceController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditPopupDescription(BuildContext context,
      String initialDescription, Function(String) onEdit) async {
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier"),
          content: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: "Nouveau nom", hintText: initialDescription),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                final String apiUrl =
                    "http://$serverIp:3000/api/items/update-description/${item.id}";
                var body = {
                  'description': descriptionController.text,
                };

                var response = await http.post(
                  Uri.parse(apiUrl),
                  body: body,
                );

                if (response.statusCode == 200) {
                  Fluttertoast.showToast(
                    msg: 'Modification effectuée avec succès',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                  );
                } else {
                  Fluttertoast.showToast(
                      msg:
                          "Erreur durant l'envoi la modification des informations",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red);
                }
                onEdit(descriptionController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(
        'Gestion des objets',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: Image.asset(
                          "assets/logo.png",
                          width: 90.0,
                          height: 90.0,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Nom de l'objet : ${item.name!}",
                              style: const TextStyle(
                                color: Color(0xff4682B4),
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Verdana',
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () async {
                                await showEditPopupName(context, itemName,
                                    (String newcity) {
                                  setState(() {
                                    itemName = newcity;
                                  });
                                });
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 15.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            item.description != null
                                ? Text(
                                    "Description de l'objet : ${item.description!}",
                                    style: const TextStyle(
                                      color: Color(0xff4682B4),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Verdana',
                                    ),
                                  )
                                : Text(
                                    "Description de l'objet : pas de description",
                                    style: const TextStyle(
                                      color: Color(0xff4682B4),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Verdana',
                                    ),
                                  ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () async {
                                await showEditPopupDescription(
                                  context,
                                  itemDescription,
                                  (String newPrice) {
                                    setState(() {
                                      itemDescription = newPrice;
                                    });
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 15.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            item.price != null
                                ? Text(
                                    "prix de l'objet : ${item.price!}",
                                    style: const TextStyle(
                                      color: Color(0xff4682B4),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Verdana',
                                    ),
                                  )
                                : Text(
                                    "prix de l'objet : pas de prix",
                                    style: const TextStyle(
                                      color: Color(0xff4682B4),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Verdana',
                                    ),
                                  ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () async {
                                await showEditPopupPrice(
                                  context,
                                  item.price.toString(),
                                  (String newPrice) {
                                    setState(() {
                                      itemPrice =
                                          double.tryParse(newPrice) ?? 0.0;
                                    });
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 15.0,
                              ),
                            ),
                          ],
                        ),
                        item.category != null
                            ? Text(
                                "category de l'objet : ${item.category!}",
                                style: const TextStyle(
                                  color: Color(0xff4682B4),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Verdana',
                                ),
                              )
                            : Text(
                                "category de l'objet : pas de category",
                                style: const TextStyle(
                                  color: Color(0xff4682B4),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Verdana',
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class ItemCardInfo extends StatelessWidget {
  final ItemListInfo item;
  final Function(ItemListInfo) onDelete;

  const ItemCardInfo({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemPagesModification(item: item),
          ),
        );
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title: Text("nom : ${item.name}"),
                subtitle: item.description != null
                    ? Text("description : ${item.description!}")
                    : Text("description : pas de description"),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(item),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemPagesModification(item: item),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
