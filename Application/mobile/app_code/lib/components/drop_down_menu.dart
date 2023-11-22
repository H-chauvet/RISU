import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({
    Key? key,
  }) : super(key: key);

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  late Future<String> _selectedItem;
  List<String> _items = ['Clair', 'Sombre'];

  Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return _items[prefs.getBool('isDarkTheme') == true ? 1 : 0];
  }

  @override
  void initState() {
    super.initState();
    _selectedItem = getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _selectedItem,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DropdownButton(
            itemHeight: null,
            value: null,
            items: [DropdownMenuItem(child: Text('Loading...'))],
            onChanged: null,
          );
        } else if (snapshot.hasError) {
          return DropdownButton(
            itemHeight: null,
            value: null,
            items: [DropdownMenuItem(child: Text('Error'))],
            onChanged: null,
          );
        } else {
          return DropdownButton(
            key: widget.key,
            itemHeight: null,
            value: snapshot.data,
            items: _items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? selectedItem) {
              setState(() {
                if (snapshot.data != selectedItem) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                }
                _selectedItem = Future.value(selectedItem!);
              });
            },
          );
        }
      },
    );
  }
}
