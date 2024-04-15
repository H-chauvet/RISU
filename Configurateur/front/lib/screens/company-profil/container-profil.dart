import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/components/items-information.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/services/storage_service.dart';
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
  late List<ItemListInfo> items;
  late String itemName = '';
  late String itemDesc = '';
  late String city;
  late String address;
  late String saveName;
  late String information;
  late int containerId;
  late CtnList tmp;

  Future<void> fetchContainer(String id) async {
    final response = await http
        .get(Uri.parse('http://${serverIp}:3000/api/container/list-by-id/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final dynamic containersData = responseData["container"];
      setState(() {
        tmp = CtnList.fromJson(containersData);
        if (tmp.address != null) {
          address = tmp.address!;
        }
        if (tmp.city != null) {
          city = tmp.city!;
        }
        print(tmp);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void checkContainerId() async {
    String? ctnId = await storageService.readStorage('containerId');
    if (ctnId != '' ) {
      containerId = int.parse(ctnId!);
      fetchContainer(ctnId!);
      fetchItemsbyCtnId();
    }
  }

  @override
  void initState() {
    super.initState();
    checkContainerId();
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
                      labelText: "Nouvelle ville", hintText: initialLastName),
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
                  fetchContainer(containerId.toString());
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
                      labelText: "Adresse postale", hintText: initialAddress),
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
                  fetchContainer(containerId.toString());
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

  Future<void> fetchItemsbyCtnId() async {
    final response = await http.get(
      Uri.parse(
          'http://${serverIp}:3000/api/items/listAllByContainerId?containerId=${containerId}'),
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
      fetchItemsbyCtnId();
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la suppression du message: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> showUpdateItem(
      BuildContext context,
      String initialLastName,
      String initialDesc,
      int itemId,
      ItemListInfo item,
      Function(String, String) onEdit) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();
    bool isAvailable = item.available!;
    double price = item.price != null ? item.price! : 0.0;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Modifier un nouvel objet"),
              content: Container(
                height: 220.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: "Nouveau nom", hintText: initialLastName),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Text("Disponible"),
                        Switch(
                          value: isAvailable,
                          onChanged: (bool newValue) {
                            setState(() {
                              isAvailable = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      onChanged: (value) {
                        price = double.tryParse(value) ?? 0.0;
                      },
                      decoration:
                          const InputDecoration(labelText: "Prix de l'objet"),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                          labelText: "Nouvelle description",
                          hintText: initialDesc),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (price <= 0) {
                      Fluttertoast.showToast(
                        msg: "Veuillez saisir un prix valide pour l'objet",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    final String apiUrl =
                        "http://$serverIp:3000/api/items/update/${itemId}";
                    var body = {
                      'name': nameController.text != ''
                          ? nameController.text
                          : item.name,
                      'description': descController.text != ''
                          ? descController.text
                          : item.description,
                      'price': price.toString(),
                      'available': isAvailable.toString(),
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
                      fetchItemsbyCtnId();
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Erreur durant l'envoi la modification des informations",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text("Créer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildItemWidget(BuildContext context, ItemListInfo item) {
    return GestureDetector(
      onTap: () {},
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
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () async {
                    await showUpdateItem(
                        context, itemName, itemDesc, item.id!, item,
                        (String newcity, String newDescription) {
                      setState(() {
                        itemName = newcity;
                        itemDesc = newDescription;
                      });
                    });
                  },
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
                width: 500,
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
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            Text(
                              "Nom de la ville : ${tmp.city!}",
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
                              "Adresse : ${tmp.address!}",
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
              items.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun objet trouvé.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 211, 11, 11),
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: 10.0,
                      runSpacing: 8.0,
                      children: List.generate(
                        items.length,
                        (index) => buildItemWidget(context, items[index]),
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
