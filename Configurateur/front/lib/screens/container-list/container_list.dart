import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/components/items-information.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/container-list/item-list/item_component.dart';
import 'package:front/screens/container-list/item-list/item_list.dart';
import 'package:front/screens/messages/messages_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/services/storage_service.dart';
import 'package:http/http.dart' as http;

class ContainerPage extends StatefulWidget {
  const ContainerPage({Key? key}) : super(key: key);

  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  List<CtnList> containers = [];
  List<ItemListInfo> items = [];
  bool jwtToken = false;
  bool available = false;
  String name = "";
  double price = 0.0;
  int containerId = 0;
  String description = '';

  @override
  void initState() {
    super.initState();
    fetchContainers();
    fetchItems();
    MyAlertTest.checkSignInStatusAdmin(context);
  }

  Future<void> fetchContainers() async {
    final response = await http
        .get(Uri.parse('http://${serverIp}:3000/api/container/listAll'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> containersData = responseData["container"];
      setState(() {
        containers =
            containersData.map((data) => CtnList.fromJson(data)).toList();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> deleteContainer(CtnList message) async {
    final Uri url = Uri.parse("http://${serverIp}:3000/api/container/delete");
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
      fetchContainers();
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la suppression du message: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> fetchItems() async {
    final response = await http.get(
      Uri.parse('http://${serverIp}:3000/api/items/listAll'),
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
      fetchItems();
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la suppression du message: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> showCreateItems(BuildContext context,
      Function(String, bool, double, int, String) onEdit) async {
    TextEditingController nameController = TextEditingController();
    bool isAvailable = false;
    double price = 0.0;
    int selectedContainerId = 0;
    TextEditingController description = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Créer un nouvel objet"),
              content: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: "Nom de l'objet"),
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
                    DropdownButtonFormField<String>(
                      value: selectedContainerId.toString(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedContainerId = int.tryParse(newValue!) ?? 0;
                        });
                      },
                      items: containers.map((CtnList container) {
                        return DropdownMenuItem<String>(
                          value: container.id.toString(),
                          child: Text(container.city!),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          labelText: 'Sélectionnez le conteneur'),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: description,
                      decoration: const InputDecoration(
                          labelText: "Description de l'objet"),
                    ),
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
                    if (nameController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Veuillez saisir un nom pour l'objet",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    if (price <= 0) {
                      Fluttertoast.showToast(
                        msg: "Veuillez saisir un prix valide pour l'objet",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    if (selectedContainerId == 0) {
                      Fluttertoast.showToast(
                        msg: "Veuillez sélectionner un conteneur",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    if (description.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Veuillez saisir une description pour l'objet",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    final String apiUrl =
                        "http://$serverIp:3000/api/items/create";
                    var body = {
                      'name': nameController.text,
                      'available': isAvailable,
                      'price': price.toString(),
                      'containerId': selectedContainerId.toString(),
                      'description': description.text,
                    };

                    var response = await http.post(
                      Uri.parse(apiUrl),
                      body: json.encode(body),
                      headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                      },
                    );
                    if (response.statusCode == 200) {
                      Fluttertoast.showToast(
                        msg: 'Objet créé avec succès',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                      );
                      fetchItems();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Erreur lors de la création de l'objet",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                      );
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

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          'Gestion des conteneurs et objets',
          context: context,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Liste des conteneurs',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Liste des objets',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                  indicatorColor: Colors.blue,
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    containers.isEmpty
                        ? Center(
                            child: Text(
                              'Aucun conteneur trouvé.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 211, 11, 11),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: containers.length,
                            itemBuilder: (context, index) {
                              final product = containers[index];
                              return ContainerCards(
                                container: product,
                                onDelete: deleteContainer,
                                page: "/item-page",
                                key: ValueKey<String>('delete_${product.id}'),
                              );
                            },
                          ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    containers.isEmpty
                        ? Center(
                            child: Text(
                              'Aucun objet trouvé.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 211, 11, 11),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await showCreateItems(
                                    context,
                                    (String newName,
                                        bool newAvailable,
                                        double newPrice,
                                        int newContainerId,
                                        String newDescription) {
                                      setState(() {
                                        name = newName;
                                        available = newAvailable;
                                        price = newPrice;
                                        containerId = newContainerId;
                                        description = newDescription;
                                        fetchItems();
                                      });
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 28, 125, 182),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add),
                                    SizedBox(width: 8),
                                    Text('Ajouter un items'),
                                  ],
                                ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
