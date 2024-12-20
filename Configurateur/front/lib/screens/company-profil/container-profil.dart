// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/dialog/confirmation_dialog.dart';
import 'package:front/network/informations.dart';
import 'package:front/components/items-information.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

/// ContainerProfilPage
///
/// Container profil page of the organization
/// [container] : Container selected in company profil page
class ContainerProfilPage extends StatefulWidget {
  const ContainerProfilPage({super.key});

  @override
  ContainerProfilPageState createState() => ContainerProfilPageState();
}

/// CompanyProfilPageState
///
class ContainerProfilPageState extends State<ContainerProfilPage> {
  ContainerProfilPageState();
  late List<ItemList> items = [];
  late String itemName = '';
  late String itemDesc = '';
  late String city = '';
  late String address = '';
  late String saveName = '';
  late String information = '';
  late int containerId;
  late ContainerListData tmp = ContainerListData(
    id: null,
    createdAt: null,
    organization: null,
    organizationId: null,
    containerMapping: null,
    price: null,
    address: null,
    city: null,
    design: null,
    informations: null,
    saveName: null,
  );
  String jwtToken = '';

  /// [Function] : get information about the containers
  /// [id] : Container's id
  Future<void> fetchContainer(String id) async {
    final response = await http.get(
      Uri.parse('http://$serverIp:3000/api/container/listByContainer/$id'),
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
      showCustomToast(context, response.body, false);
    }
  }

  /// [Function] : Check the container id in the storage service
  void checkContainerId() async {
    String? ctnId = await storageService.readStorage('containerId');
    if (ctnId != '' || ctnId != null) {
      containerId = int.parse(ctnId!);
      fetchContainer(ctnId);
      fetchItemsbyCtnId();
    }
  }

  /// [Function] : Check the token in the storage service
  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != null) {
      jwtToken = token;
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
      showCustomToast(
          context, AppLocalizations.of(context)!.modifySuccess, true);
      checkToken();
    } else {
      showCustomToast(context, response.body, false);
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
            AppLocalizations.of(context)!.modify,
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
          ),
          content: SizedBox(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  key: const Key("city"),
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.cityNew,
                      hintText: initialLastName),
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
                AppLocalizations.of(context)!.cancel,
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
                AppLocalizations.of(context)!.modify,
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
      showCustomToast(
          context, AppLocalizations.of(context)!.modifySuccess, true);
      checkToken();
    } else {
      showCustomToast(context, response.body, false);
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
            AppLocalizations.of(context)!.modify,
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
          ),
          content: SizedBox(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  key: const Key("address"),
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.addressPostal,
                    hintText: initialAddress,
                  ),
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
                AppLocalizations.of(context)!.cancel,
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
                AppLocalizations.of(context)!.modify,
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
          'http://$serverIp:3000/api/items/listAllByContainerId?containerId=$containerId'),
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
      showCustomToast(context, response.body, false);
    }
  }

  /// [Function] : Delete the selected item
  /// [item] : The item who will be deleted
  Future<void> deleteItem(ItemList item) async {
    late int id;
    final Uri url = Uri.parse("http://$serverIp:3000/api/items/delete");
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
      showCustomToast(
        context,
        AppLocalizations.of(context)!.itemDeleteSuccess,
        true,
      );
      checkToken();
      // fetchItemsbyCtnId();
    } else {
      showCustomToast(context, response.body, false);
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
      showCustomToast(context, "Veuillez entrer un prix valide", false);
      return;
    }
    final String apiUrl = "http://$serverIp:3000/api/items/update/$itemId";
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
      showCustomToast(
          context, AppLocalizations.of(context)!.modifySuccess, true);
      checkToken();
      // fetchItemsbyCtnId();
    } else {
      showCustomToast(context, response.body, false);
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
                AppLocalizations.of(context)!.objectEdit,
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                ),
              ),
              content: SizedBox(
                height: 250.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.nameNew,
                        hintText: initialLastName,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.available,
                          style: TextStyle(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
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
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.objectPrice),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.descriptionNew,
                        hintText: initialDesc,
                      ),
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
                    AppLocalizations.of(context)!.cancel,
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
                  child: Text(
                    AppLocalizations.of(context)!.modify,
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
                title: Text(AppLocalizations.of(context)!.nameData(item.name)),
                subtitle: item.description != null
                    ? Text(AppLocalizations.of(context)!
                        .descriptionData(item.description!))
                    : Text(AppLocalizations.of(context)!.descriptionEmpty),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  key: const Key("edit-item"),
                  icon: Icon(
                    Icons.mode_outlined,
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                  ),
                  onPressed: () async {
                    await showUpdateItem(
                        context, itemName, itemDesc, item.id!, item,
                        (String newcity, String DescriptionNew) {
                      setState(() {
                        itemName = newcity;
                        itemDesc = DescriptionNew;
                      });
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                  ),
                  onPressed: () async {
                    var confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmationDialog(),
                    );

                    if (confirm == true) {
                      deleteItem(item);
                    }
                  },
                ),
                const SizedBox(
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
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Scaffold(
      body: FooterView(
        flex: 6,
        footer: Footer(
          padding: EdgeInsets.zero,
          child: const CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            AppLocalizations.of(context)!.container,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenFormat == ScreenFormat.desktop
                  ? desktopBigFontSize
                  : tabletBigFontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.secondaryHeaderColor
                  : lightTheme.secondaryHeaderColor,
              shadows: [
                Shadow(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                  offset: const Offset(0.75, 0.75),
                  blurRadius: 1.5,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    // width: 500,
                    // height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
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
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                tmp.city != null
                                    ? Text(
                                        AppLocalizations.of(context)!
                                            .cityNameData(tmp.city!),
                                        style: TextStyle(
                                          color:
                                              Provider.of<ThemeService>(context)
                                                      .isDark
                                                  ? darkTheme.primaryColor
                                                  : lightTheme.primaryColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Verdana',
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!
                                            .cityNotLinked,
                                        style: TextStyle(
                                          color:
                                              Provider.of<ThemeService>(context)
                                                      .isDark
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
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
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
                                tmp.address != null
                                    ? Text(
                                        AppLocalizations.of(context)!
                                            .addressData(tmp.address!),
                                        style: TextStyle(
                                          color:
                                              Provider.of<ThemeService>(context)
                                                      .isDark
                                                  ? darkTheme.primaryColor
                                                  : lightTheme.primaryColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Verdana',
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!.addressNo,
                                        style: TextStyle(
                                          color:
                                              Provider.of<ThemeService>(context)
                                                      .isDark
                                                  ? darkTheme.primaryColor
                                                  : lightTheme.primaryColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Verdana',
                                        ),
                                      ),
                                const SizedBox(width: 5.0),
                                InkWell(
                                  key: const Key("edit-address"),
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
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
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
                  Text(
                    AppLocalizations.of(context)!.ourObjects,
                    style: TextStyle(
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopMediumFontSize
                          : tabletMediumFontSize,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2.0,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    key: Key("objectCreation"),
                    onPressed: () {
                      storageService.writeStorage(
                        'containerId',
                        containerId.toString(),
                      );
                      context.go("/object-creation");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.objectCreate,
                      style: TextStyle(
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  items.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.objectEmpty,
                            style: const TextStyle(
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
        ],
      ),
    );
  }
}
