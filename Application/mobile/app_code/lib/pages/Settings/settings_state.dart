import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/drop_down_menu.dart';

import 'settings_functional.dart';
import 'settings_page.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/utils/theme.dart';
import 'package:provider/provider.dart';

class SettingsPageState extends State<SettingsPage> {
  /// Update state function
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updatePage = update;
  }

  /// Re sync all flutter object
  void homeSync() async {
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomShapedAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: true,
        showLogo: true,
        showBurgerMenu: false,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 51),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 30), // Espace ajouté
                const Text(
                  'Paramètres', // Texte "Paramètres"
                  style: TextStyle(
                    fontSize: 36, // Taille de la police
                    fontWeight: FontWeight.bold, // Gras
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Thème : ',
                      style: TextStyle(
                        fontSize: 20, // Taille de la police
                        fontWeight: FontWeight.bold, // Gras
                        color: Color(0xFF4682B4),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          MyDropdownButton(
                            key: Key('drop_down'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MyOutlinedButton(
                  key: const Key('settings-button_go_to_parameter_page'),
                  onPressed: () {
                    print(context);
                  },
                  text: "Modification d'information",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class MyDropdownButton extends StatefulWidget {

//   const MyDropdownButton({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _MyDropdownButtonState createState() => _MyDropdownButtonState();
// }

// class _MyDropdownButtonState extends State<MyDropdownButton> {

//   String? _selectedItem = 'Clair';
//   List<String> _items = ['Clair', 'Sombre'];

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton(
//             itemHeight: null,
//             value: _selectedItem,
//             items: _items.map((String item) {
//               return DropdownMenuItem(
//                 value: item,
//                 child: Text(item),
//               );
//             }).toList(),
//             onChanged: (String? selectedItem) {
//               setState(() {
//                 _selectedItem = selectedItem;
//               });
//             },
//           );
//   }
// }