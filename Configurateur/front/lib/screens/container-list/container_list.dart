import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:front/services/http_service.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/components/items-information.dart';
import 'package:front/network/informations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({Key? key}) : super(key: key);

  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  List<ContainerListData> containers = [];
  List<ItemListInfo> items = [];
  String jwtToken = '';
  late String itemName = '';
  late String itemDesc = '';
  bool available = false;
  String name = "";
  double price = 0.0;
  int containerId = 0;
  String description = '';
  late String selectedCategory = "Tous";
  List<String> categories = [];

  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != null) {
      jwtToken = token!;
      fetchContainers();
      fetchItems();
    } else {
      jwtToken = "";
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
    MyAlertTest.checkSignInStatusAdmin(context);
  }

  Future<void> fetchContainers() async {
    final response = await http.get(
      Uri.parse('http://${serverIp}:3000/api/container/listAll'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> containersData = responseData["container"];
      setState(() {
        containers = containersData
            .map((data) => ContainerListData.fromJson(data))
            .toList();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> deleteContainer(ContainerListData conteneur) async {
    final Uri url = Uri.parse("http://${serverIp}:3000/api/container/delete");
    final response = await http.post(
      url,
      body: json.encode({'id': conteneur.id}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Conteneur supprimé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      fetchContainers();
    } else {
      Fluttertoast.showToast(
        msg:
            'Erreur lors de la suppression du conteneur: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> fetchItems() async {
    final response = await http.get(
      Uri.parse('http://${serverIp}:3000/api/items/listAll'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> itemsData = responseData["item"];
      setState(() {
        items = itemsData.map((data) => ItemListInfo.fromJson(data)).toList();
        categories =
            items.map((item) => item.category ?? 'Tous').toSet().toList();
        categories.sort();
      });
    } else {
      Fluttertoast.showToast(
        msg:
            "Erreur lors de l'envoie des informations de l'objet: ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> fetchItemsByCategory() async {
    if (selectedCategory == 'Tous') {
      fetchItems();
      return;
    }
    final response = await http.get(
      Uri.parse(
          'http://${serverIp}:3000/api/items/listAllByCategory?category=$selectedCategory'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> itemsData = responseData["item"];
      setState(() {
        items = itemsData.map((data) => ItemListInfo.fromJson(data)).toList();
      });
    } else {
      Fluttertoast.showToast(
        msg:
            'Erreur lors de la récupération des items par catégorie: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> deleteItem(ItemListInfo item) async {
    late int id;
    if (item.id != null) {
      id = item.id!;
    }
    final Uri url = Uri.parse("http://${serverIp}:3000/api/items/delete");
    final response = await http.post(
      url,
      body: json.encode({'id': id}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Objet supprimé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      fetchItems();
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la suppression du objet: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> apiUpdateItem(
      TextEditingController nameController,
      TextEditingController descController,
      bool isAvailable,
      double price,
      ItemListInfo item,
      int itemId) async {
    if (price <= 0) {
      Fluttertoast.showToast(
        msg: "Veuillez saisir un prix valide pour l'objet",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
      );
      return;
    }
    final String apiUrl = "http://$serverIp:3000/api/items/update/${itemId}";
    var body = {
      'name': nameController.text != '' ? nameController.text : item.name,
      'description':
          descController.text != '' ? descController.text : item.description,
      'price': price.toString(),
      'available': isAvailable.toString(),
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      body: body,
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Modification effectuée avec succès',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
      );
      fetchItemsByCategory();
    } else {
      Fluttertoast.showToast(
          msg: "Erreur durant l'envoi la modification des informations",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red);
    }
  }

  Future<void> showEditPopupName(
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
                    apiUpdateItem(nameController, descController, available,
                        price, item, itemId);
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

  Future<void> apiCreateItem(
      TextEditingController nameController,
      TextEditingController descController,
      bool isAvailable,
      double price,
      int selectedContainerId) async {
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
    if (descController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Veuillez saisir une description pour l'objet",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
      );
      return;
    }
    final String apiUrl = "http://$serverIp:3000/api/items/create";
    var body = {
      'name': nameController.text,
      'available': isAvailable,
      'price': price.toString(),
      'containerId': selectedContainerId.toString(),
      'description': descController.text,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Objet créé avec succès',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      fetchItemsByCategory();
    } else {
      Fluttertoast.showToast(
        msg: "Erreur lors de la création de l'objet",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
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
                height: 290.0,
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
                      items: containers.map((ContainerListData container) {
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
                    apiCreateItem(nameController, description, available, price,
                        selectedContainerId);

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
                  icon: const Icon(Icons.mode_outlined),
                  onPressed: () async {
                    await showEditPopupName(
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
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteItem(item),
                ),
              ],
            ),
          ],
        ),
      ),
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
              SliverAppBar(
                floating: true,
                elevation: 4,
                backgroundColor: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.colorScheme.background
                    : lightTheme.colorScheme.background,
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
                  labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                page: "/container-profil",
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
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  DropdownButton<String>(
                                    value: selectedCategory,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedCategory = newValue;
                                          fetchItemsByCategory();
                                        });
                                      }
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: 'Tous',
                                        child: Text('Tous'),
                                      ),
                                      for (var category in categories)
                                        if (category != 'Tous')
                                          DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                              items.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Aucun objet trouvé.',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 211, 11, 11),
                                        ),
                                      ),
                                    )
                                  : Wrap(
                                      spacing: 10.0,
                                      runSpacing: 8.0,
                                      children: List.generate(
                                        items.length,
                                        (index) => buildItemWidget(
                                            context, items[index]),
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
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
