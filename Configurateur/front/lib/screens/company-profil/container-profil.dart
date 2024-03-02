import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/components/items-information.dart';
// import 'package:front/screens/container-list/container_web.dart';
import 'package:front/screens/container-list/item-list/item_component.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ContainerProfilPage extends StatefulWidget {
  final CtnList container;
  const ContainerProfilPage({Key? key, required this.container})
      : super(key: key);

  @override
  _ContainerProfilPageState createState() =>
      _ContainerProfilPageState(container: container);
}

class _ContainerProfilPageState extends State<ContainerProfilPage> {
  final CtnList container;
  _ContainerProfilPageState({required this.container});
  List<ItemListInfo> items = [];
  String city = '';
  String address = '';
  String saveName = '';
  String information = '';
  late int containerId;

  @override
  void initState() {
    super.initState();
    fetchItemsi();
    if (container.city != null) {
      city = container.city!;
    }
    if (container.id != null) {
      containerId = container.id!;
    }
  }

  Future<void> showEditPopupCity(BuildContext context, String initialLastName,
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
                    "http://$serverIp:3000/api/container/update-city/$containerId";
                var body = {
                  'city': nameController.text,
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

  Future<void> showEditPopupAddress(BuildContext context, String initialAddress,
      Function(String) onEdit) async {
    TextEditingController addressController = TextEditingController();
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
                  controller: addressController,
                  decoration: InputDecoration(
                      labelText: "Nouveau nom", hintText: initialAddress),
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
                    "http://$serverIp:3000/api/container/update-address/$containerId";
                var body = {
                  'address': addressController.text,
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
                onEdit(addressController.text);
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

  Future<void> fetchItemsi() async {
    final response = await http.get(
      Uri.parse(
          'http://${serverIp}:3000/api/items/listAll?containerId=${container.id}'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> itemsData = responseData["item"];
      setState(() {
        items = itemsData.map((data) => ItemListInfo.fromJson(data)).toList();
      });
    } else {}
  }

  Future<void> deleteItem(ItemListInfo message) async {
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
      fetchItemsi();
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
                // width: 300,
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                              "Nom de la ville : ${container.city!}",
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
                                await showEditPopupCity(context, city,
                                    (String newcity) {
                                  setState(() {
                                    city = newcity;
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
                            Text(
                              "Adresse : ${container.address!}",
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
                                await showEditPopupAddress(context, address,
                                    (String newAddress) {
                                  setState(() {
                                    address = newAddress;
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
                      ],
                    ),
                  ],
                ),
              ),
              const Text("Nos Objets :",
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
                  return ItemCardInfo(
                    item: product,
                    onDelete: deleteItem,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
