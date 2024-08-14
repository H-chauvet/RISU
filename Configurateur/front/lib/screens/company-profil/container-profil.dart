import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/components/items-information.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

/// ContainerProfilPage
///
/// Container profil page of the organization
/// [container] : Container selected in company profil page
class ContainerProfilPage extends StatefulWidget {
  const ContainerProfilPage({Key? key})
      : super(key: key);

  @override
  _ContainerProfilPageState createState() =>
      _ContainerProfilPageState();
}

/// CompanyProfilPageState
///
class _ContainerProfilPageState extends State<ContainerProfilPage> {
  _ContainerProfilPageState();
  late List<ItemList> items;
  late String itemName = '';
  late String itemDesc = '';
  late String city;
  late String address;
  late String saveName;
  late String information;
  late int containerId;
  late ContainerListData tmp;
  String jwtToken = '';

  /// [Function] : get information about the containers
  /// [id] : Container's id
  Future<void> fetchContainer(String id) async {
    final response = await http.get(
      Uri.parse('http://${serverIp}:3000/api/container/listByContainer/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final dynamic containersData = responseData["container"];
      setState(() {
        tmp = ContainerListData.fromJson(containersData);
        if (tmp.address != null) {
          address = tmp.address!;
        }
        if (tmp.city != null) {
          city = tmp.city!;
        }
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  /// [Function] : Check the container id in the storage service
  void checkContainerId() async {
    String? ctnId = await storageService.readStorage('containerId');
    if (ctnId != '' || ctnId != null) {
      containerId = int.parse(ctnId!);
      fetchContainer(ctnId!);
      fetchItemsbyCtnId();
    }
  }

  /// [Function] : Check the token in the storage service
  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != null) {
      jwtToken = token!;
      checkContainerId();
    } else {}
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  /// [Function] : Update the city of the container
  /// [nameController] : Controller for the container's name
  Future<void> apiUpdateCity(TextEditingController nameController) async {
    final String apiUrl =
        "http://$serverIp:3000/api/container/update-city/$containerId";
    var body = {
      'city': nameController.text,
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
      checkToken();
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

  /// [Function] : Display pop up to modify the container's city
  Future<void> showEditPopupCity(BuildContext context, String initialLastName,
      Function(String) onEdit) async {
    TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Modifier",
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
          ),
          content: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  key: const Key("city"),
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
              child: Text(
                "Annuler",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                ),
                key: const Key('cancel-edit-city'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                apiUpdateCity(nameController);
                onEdit(nameController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                "Modifier",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// [Function] : Update the address of the container
  /// [addressController] : Controller of the container's address
  Future<void> apiUpdateAddress(TextEditingController addressController) async {
    final String apiUrl =
        "http://$serverIp:3000/api/container/update-address/$containerId";
    var body = {
      'address': addressController.text,
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
      checkToken();
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

  /// [Function] : Display pop up to modify the container's address
  Future<void> showEditPopupAddress(BuildContext context, String initialAddress,
      Function(String) onEdit) async {
    TextEditingController addressController = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Modifier",
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
          ),
          content: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  key: const Key("address"),
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
              child: Text(
                "Annuler",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                ),
                key: const Key('cancel-edit-address'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                apiUpdateAddress(addressController);
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
              child: Text(
                "Modifier",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// [Function] : Get all the items with the container id
  Future<void> fetchItemsbyCtnId() async {
    final response = await http.get(
      Uri.parse(
          'http://${serverIp}:3000/api/items/listAllByContainerId?containerId=${containerId}'),
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
            "Erreur lors de l'envoi des informations de l'objet: ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  /// [Function] : Delete the selected item
  /// [item] : The item who will be deleted
  Future<void> deleteItem(ItemList item) async {
    late int id;
    final Uri url = Uri.parse("http://${serverIp}:3000/api/items/delete");
    if (item.id != null) {
      id = item.id!;
    }
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
      checkToken();
      // fetchItemsbyCtnId();
    } else {
      Fluttertoast.showToast(
        msg: "Erreur lors de la suppression de l'objet: ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  /// [Function] : Update the selected item
  /// [nameController] : Controller of the item's name
  /// [descController] : Controller of the item's description
  /// [price] : Item's price
  /// [item] : Item's informations
  /// [itemId] : Item's id
  ///
  Future<void> apiUpdateItem(
      TextEditingController nameController,
      TextEditingController descController,
      double price,
      ItemList item,
      int itemId) async {
    bool isAvailable = item.available!;
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
      checkToken();
      // fetchItemsbyCtnId();
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

  /// [Function] : Display pop up to modify the item
  ///
  /// [initialLastName] : Item's name
  /// [initialDesc] : Item's description
  /// [itemId] : Item's id
  /// [item] : Item's informations
  Future<void> showUpdateItem(
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Modifier un objet",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                ),
              ),
              content: Container(
                height: 250.0,
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
                        Text("Disponible",
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                            )),
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
                    ),
                    key: const Key('cancel-edit-item'),
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
                    apiUpdateItem(
                        nameController, descController, price, item, itemId);
                    Navigator.of(context).pop();
                  },
                  child: Text("Modifier",
                      style: TextStyle(
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      )),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// [Widget] : Build card component for the items
  Widget buildItemWidget(BuildContext context, ItemList item) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title: Text("Nom : ${item.name}"),
                subtitle: item.description != null
                    ? Text("Description : ${item.description!}")
                    : Text("Description : Pas de description"),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.mode_outlined,
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                  ),
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
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                  ),
                  onPressed: () => deleteItem(item),
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

  /// [Widget] : build the containers profil page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
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
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Verdana',
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              key: const Key('edit-city'),
                              onTap: () async {
                                await showEditPopupCity(context, city,
                                    (String newcity) {
                                  setState(() {
                                    city = newcity;
                                  });
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                size: 15.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Text(
                              "Adresse : ${tmp.address!}",
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Verdana',
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              key: Key("edit-city"),
                              onTap: () async {
                                await showEditPopupAddress(context, address,
                                    (String newAddress) {
                                  setState(() {
                                    address = newAddress;
                                  });
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.go(
                      "/object-creation",
                    );
                  },
                  child: Text('Nouvel Objet'),
                ),
              ),
              Text(
                "Nos Objets :",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2.0,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
              SizedBox(
                height: 65,
              ),
              items.isEmpty
                  ? const Center(
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
