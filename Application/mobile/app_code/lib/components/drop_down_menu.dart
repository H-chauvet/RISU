import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {

  const MyDropdownButton({
    Key? key,
  }) : super(key: key);

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {

  String? _selectedItem = 'Clair';
  List<String> _items = ['Clair', 'Sombre'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
            itemHeight: null,
            value: _selectedItem,
            items: _items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? selectedItem) {
              setState(() {
                _selectedItem = selectedItem;
              });
            },
          );
  }
}
