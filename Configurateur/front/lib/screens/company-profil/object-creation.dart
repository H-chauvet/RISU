import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/container-creation/design_screen/design_screen_style.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:front/components/custom_toast.dart';

class Category {
  final int? id;
  final dynamic name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

enum Status {
  GOOD,
  WORN,
  VERYWORN,
}

class ObjectCreation extends StatefulWidget {
  const ObjectCreation({super.key});
  @override
  ObjectCreationState createState() => ObjectCreationState();
}

class ObjectCreationState extends State<ObjectCreation> {
  ObjectCreationState();
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  FilePickerResult? result;
  int containerId = 0;
  String jwtToken = '';
  List<Category> categories = [];
  String? selectedCategoryName = '';
  int selectedCategoryId = 0;
  int _currentIndex = 0;
  Status _selectedStatus = Status.GOOD;

  List<Uint8List?> _imageBytesList = [];
  final ImagePicker _picker = ImagePicker();
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    checkToken();
    checkContainerId();
  }

  void checkContainerId() async {
    String? ctnId = await storageService.readStorage('containerId');
    if (ctnId != '' || ctnId != null) {
      containerId = int.parse(ctnId!);
    }
  }

  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != null) {
      jwtToken = token;
      fetchCategories();
    } else {
      jwtToken = "";
    }
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('http://$serverIp:3000/api/itemCategory/listAll'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> containersData = responseData["itemCategories"];
      setState(() {
        categories =
            containersData.map((data) => Category.fromJson(data)).toList();
      });
    } else {
      showCustomToast(
        context,
        AppLocalizations.of(context)!
            .errorDuringInformationRetrievalData(response.statusCode),
        false,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> createItems() async {
    debugPrint('${_selectedStatus.toString().split('.').last}');
    final String apiUrl = "http://$serverIp:3000/api/items/create";
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..fields['name'] = _nameController.text
      ..fields['available'] = 'true'
      ..fields['price'] = _priceController.text.toString()
      ..fields['containerId'] = containerId.toString()
      ..fields['description'] = _descriptionController.text
      ..fields['status'] = _selectedStatus.toString().split('.').last
      ..headers['Authorization'] = 'Bearer $jwtToken';

    for (int i = 0; i < _imageBytesList.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'images',
        _imageBytesList[i]!,
        filename: 'image_$i.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        showCustomToast(
          context,
          AppLocalizations.of(context)!.objectCreationSuccess,
          true,
        );
      } else {
        showCustomToast(
          context,
          AppLocalizations.of(context)!.errorObjectCreationFailed,
          false,
        );
      }
    } catch (e) {
      print(e);
      showCustomToast(
        context,
        AppLocalizations.of(context)!.errorObjectCreationFailed,
        false,
      );
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate() && containerId != 0) {
      createItems().then((_) {
        context.go('/container-profil');
      });
    } else {
      showCustomToast(
        context,
        AppLocalizations.of(context)!.objectCreationFailed,
        false,
      );
    }
  }

  Future<void> _pickFile() async {
    // Récupération des images dans cette fonction
    final List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      if (pickedFiles.length > 5) {
        showCustomToast(
          context,
          AppLocalizations.of(context)!.tooManyFilesSelected,
          false,
        );
      } else {
        // Liste des images récupérées
        List<Uint8List?> images = await Future.wait(
          pickedFiles.map((file) => file.readAsBytes()).toList(),
        );

        setState(() {
          // Stockage des images dans la liste "_imageBytesList"
          _imageBytesList = images;
        });
      }
    }
  }

  void _removeImage(int index) {
    // Supression d'une image
    setState(() {
      _imageBytesList.removeAt(index);
    });
  }

  String _getStatusTranslation(Status status, BuildContext context) {
    switch (status) {
      case Status.GOOD:
        return AppLocalizations.of(context)!.goodStatus;
      case Status.WORN:
        return AppLocalizations.of(context)!.wornStatus;
      case Status.VERYWORN:
        return AppLocalizations.of(context)!.veryWornStatus;
    }
  }

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
            AppLocalizations.of(context)!.objectNew,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenFormat == ScreenFormat.desktop
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
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: _pickFile,
                        child: DottedBorder(
                          color: Colors.grey[600]!,
                          padding: EdgeInsets.zero,
                          strokeWidth: 3,
                          child: Container(
                            alignment: Alignment.center,
                            height: screenFormat == ScreenFormat.desktop
                                ? desktopImportContainerHeight
                                : tabletImportContainerHeight,
                            width: screenFormat == ScreenFormat.desktop
                                ? desktopImportContainerWidth
                                : tabletImportContainerWidth,
                            color: Colors.grey[400],
                            child: _imageBytesList.isNotEmpty
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CarouselSlider.builder(
                                        itemCount: _imageBytesList.length,
                                        options: CarouselOptions(
                                          height: 200.0,
                                          enlargeCenterPage: true,
                                          enableInfiniteScroll: false,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _currentIndex = index;
                                            });
                                          },
                                        ),
                                        itemBuilder:
                                            (context, index, realIndex) {
                                          // Affichage des images
                                          return Image.memory(
                                            _imageBytesList[index]!,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          );
                                        },
                                        carouselController: _carouselController,
                                      ),
                                      Positioned(
                                        left: 10,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            _carouselController.previousPage();
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            _carouselController.nextPage();
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _removeImage(_currentIndex);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cloud_upload,
                                        size: 32.0,
                                        color:
                                            Provider.of<ThemeService>(context)
                                                    .isDark
                                                ? darkTheme.primaryColor
                                                : lightTheme.primaryColor,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .imagesClickToAdd,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color:
                                              Provider.of<ThemeService>(context)
                                                      .isDark
                                                  ? darkTheme.primaryColor
                                                  : lightTheme.primaryColor,
                                          fontSize: screenFormat ==
                                                  ScreenFormat.desktop
                                              ? desktopFontSize
                                              : tabletFontSize,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        onPressed: _pickFile,
                                        child: Text(
                                          AppLocalizations.of(context)!.browse,
                                          style: TextStyle(
                                            color: Provider.of<ThemeService>(
                                                        context)
                                                    .isDark
                                                ? darkTheme.primaryColor
                                                : lightTheme.primaryColor,
                                            fontSize: screenFormat ==
                                                    ScreenFormat.desktop
                                                ? desktopFontSize
                                                : tabletFontSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              key: const Key('name'),
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.name,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.nameAsk;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: const Key('description'),
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.description,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .descriptionAsk;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: const Key('price'),
                              controller: _priceController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.price,
                                suffixText:
                                    AppLocalizations.of(context)!.pricePerHour,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.priceAsk;
                                }
                                if (double.tryParse(value) == null) {
                                  return AppLocalizations.of(context)!
                                      .priceAskValid;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: selectedCategoryId != 0
                                  ? selectedCategoryId.toString()
                                  : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategoryId =
                                      int.tryParse(newValue!) ?? 0;
                                });
                              },
                              items: categories.map((Category category) {
                                return DropdownMenuItem<String>(
                                  value: category.name,
                                  child: Text(category.name!),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .categorySelect,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<Status>(
                              value: _selectedStatus,
                              items: Status.values.map((Status status) {
                                return DropdownMenuItem<Status>(
                                  value: status,
                                  child: Text(
                                      _getStatusTranslation(status, context)),
                                );
                              }).toList(),
                              onChanged: (Status? newValue) {
                                setState(() {
                                  _selectedStatus = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                                child: Text(
                                  AppLocalizations.of(context)!.submit,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  _submitForm(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
