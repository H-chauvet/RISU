import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/services/http_service.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/components/items-information.dart';
import 'package:front/network/informations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

/// ContainerPage
///
/// Page who list all the containers and users in the database
class ContainerPage extends StatefulWidget {
  const ContainerPage({Key? key}) : super(key: key);

  @override
  _ContainerPageState createState() => _ContainerPageState();
}

/// ContainerPageState
///
class _ContainerPageState extends State<ContainerPage> {
  List<ContainerListData> containers = [];
  List<ItemList> items = [];
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

  /// [Function] : Check the token in the storage service
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

  /// [Function] : Get all the containers in the database
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

  /// [Function] : Delete container
  /// [conteneur] : Container who will be deleted
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

  /// [Function] : Get all the items in the database
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
        items = itemsData.map((data) => ItemList.fromJson(data)).toList();
        categories =
            items.map((item) => item.category ?? 'Tous').toSet().toList();
        categories.sort();
      });
    } else {
      Fluttertoast.showToast(
        msg:
            "Erreur lors de l'envoi des informations de l'objet: ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  /// [Function] : Get all the items with the selected category in the database
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
        items = itemsData.map((data) => ItemList.fromJson(data)).toList();
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

  /// [Function] : Delete Item
  /// [item] : Item who will be deleted
  Future<void> deleteItem(ItemList item) async {
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

  /// [Function] : Update the item's informations
  ///
  /// [nameController] : Controller for the item's name
  /// [descController] : Controller for the item's description
  /// [isAvailable] : Boolean to know if the item is available or not
  /// [price] : Item's price
  /// [item] : Item's informations
  /// [itemId] : Item's id
  Future<void> apiUpdateItem(
      TextEditingController nameController,
      TextEditingController descController,
      bool isAvailable,
      double price,
      ItemList item,
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
        msg: "Erreur durant l'envoi de modification des informations",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
      );
    }
  }

  /// [Function] : Show a pop up to modify the item's informations
  ///
  /// [initialLastName] : Item's name
  /// [initialDesc] : Item's description
  /// [price] : Item's price
  /// [item] : Item's informations
  /// [itemId] : Item's id
  Future<void> showEditPopupName(
      BuildContext context,
      String initialLastName,
      String initialDesc,
      int itemId,
      ItemList item,
      Function(String, String) onEdit) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();
    bool isAvailable = item.available!;
    double price = item.price != null ? item.price! : 0.0;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        ScreenFormat screenFormat = SizeService().getScreenFormat(context);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Modifier un objet",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
              content: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                        Text(
                          "Disponible",
                          style: TextStyle(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                          ),
                        ),
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Annuler",
                    style: TextStyle(
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopFontSize
                          : tabletFontSize,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    apiUpdateItem(nameController, descController, available,
                        price, item, itemId);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Modifier",
                    style: TextStyle(
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopFontSize
                          : tabletFontSize,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// [Function] : Create new item in the database
  ///
  /// [nameController] : Controller for the item's name
  /// [descController] : Controller for the item's description
  /// [price] : Item's price
  /// [selectedContainerId] : Item's container id
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

  /// [Function] : Show pop up to create new item in the database
  ///
  Future<void> showCreateItems(BuildContext context,
      Function(String, bool, double, int, String) onEdit) async {
    TextEditingController nameController = TextEditingController();
    bool isAvailable = false;
    double price = 0.0;
    int selectedContainerId = 0;
    TextEditingController description = TextEditingController();
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Créer un nouvel objet",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletBigFontSize,
                ),
              ),
              content: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                        Text(
                          "Disponible",
                          style: TextStyle(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletBigFontSize,
                          ),
                        ),
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
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Annuler",
                    style: TextStyle(
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopFontSize
                          : tabletBigFontSize,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    apiCreateItem(nameController, description, available, price,
                        selectedContainerId);

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Créer",
                    style: TextStyle(
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopFontSize
                          : tabletBigFontSize,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildItemWidget(BuildContext context, ItemList item) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  "Nom : ${item.name}",
                  style: TextStyle(
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopFontSize
                        : tabletBigFontSize,
                  ),
                ),
                subtitle: item.description != null
                    ? Text(
                        "Description : ${item.description!}",
                        style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletBigFontSize,
                        ),
                      )
                    : Text(
                        "Description : Pas de description",
                        style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletBigFontSize,
                        ),
                      ),
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

  /// [Widget] : Build the container and items manager page
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          'Gestion des conteneurs et objets',
          context: context,
        ),
        body: FooterView(
          footer: Footer(
            child: CustomFooter(context: context),
          ),
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    floating: true,
                    elevation: 4,
                    backgroundColor: Colors.transparent,
                    bottom: TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            'Liste des conteneurs',
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              fontSize: screenFormat == ScreenFormat.desktop
                                  ? desktopFontSize
                                  : tabletBigFontSize,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Liste des objets',
                            style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletBigFontSize),
                          ),
                        ),
                      ],
                      labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      indicatorColor: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
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
                                    fontSize:
                                        screenFormat == ScreenFormat.desktop
                                            ? desktopFontSize
                                            : tabletBigFontSize,
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
                                    key: ValueKey<String>(
                                        'delete_${product.id}'),
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
                                    fontSize:
                                        screenFormat == ScreenFormat.desktop
                                            ? desktopFontSize
                                            : tabletBigFontSize,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Provider.of<ThemeService>(
                                                          context)
                                                      .isDark
                                                  ? darkTheme.primaryColor
                                                  : lightTheme.primaryColor,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Ajouter un article',
                                              style: TextStyle(
                                                color:
                                                    Provider.of<ThemeService>(
                                                                context)
                                                            .isDark
                                                        ? darkTheme.primaryColor
                                                        : lightTheme
                                                            .primaryColor,
                                                fontSize: screenFormat ==
                                                        ScreenFormat.desktop
                                                    ? desktopFontSize
                                                    : tabletBigFontSize,
                                              ),
                                            ),
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
                                              fontSize: screenFormat ==
                                                      ScreenFormat.desktop
                                                  ? desktopFontSize
                                                  : tabletBigFontSize,
                                              color: Color.fromARGB(
                                                  255, 211, 11, 11),
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
          ],
        ),
      ),
    );
  }
}
