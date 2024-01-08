import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';

import '../../globals.dart';
import '../../utils/theme.dart';
import 'rent_page.dart';

class RentArticlePageState extends State<RentArticlePage> {
  int _rentalHours = 1;

  //String _articleName = 'Nom de l\'article';

  late int _rentalPrice;
  late String _articleName;
  late int _price;
  late String _containerId;
  late List<String> _locations;

  @override
  void initState() {
    super.initState();
    _articleName = widget.name;
    _rentalPrice = widget.price;
    _containerId = widget.containerId;
    _locations = widget.locations;
  }

  void _incrementHours() {
    setState(() {
      _rentalHours++;
    });
  }

  void _decrementHours() {
    if (_rentalHours > 1) {
      setState(() {
        _rentalHours--;
      });
    }
  }

  void confirmRent() async {
    await MyAlertDialog.showChoiceAlertDialog(
      context: context,
      title: 'Confirmer la location',
      message: 'Êtes-vous sûr de vouloir louer cet article ?',
      onOkName: 'Confirmer',
      onCancelName: 'Annuler',
    ).then(
      (value) => {
        if (value)
          {
            rentArticle(),
          }
      },
    );
  }

  void rentArticle() async {
    /*print("Renting article");
    print('_rentalHours: $_rentalHours');
    print('_rentalPrice: $_rentalPrice');
    print('_articleName: $_articleName');*/
    final token = userInformation?.token ?? 'defaultToken';
    late http.Response response;
    try {
      response = await http.post(
        Uri.parse('http://$serverIp:8080/api/rent/article'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'itemId': '1',
          'duration': _rentalHours.toString(),
          'price': _rentalPrice.toString(),
        }),
      );
    } catch (err) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context, title: 'Contact', message: 'Connection refused.');
        print(err);
        print(response.statusCode);
      }
    }
    if (response.statusCode == 201) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Contact',
            message: 'Location enregistrée.');
      }
    } else {
      if (context.mounted) {
        print(response.statusCode);
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Contact',
            message: 'Erreur lors de la location.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
        showBurgerMenu: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Location de l\'article',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 8),
                // image
                Container(
                  width: 256,
                  height: 192,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage('assets/volley.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            _articleName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            color: Colors.white,
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1.0),
                                1: FlexColumnWidth(1.0),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: Color(0xFF4682B4),
                                        child: const Text(
                                          'Prix par heure',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: const Color(0xFF4682B4),
                                        child: const Text(
                                          'Coût total',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color:
                                            Color(0xFF4682B4).withOpacity(0.6),
                                        child: Text(
                                          '$_rentalPrice €',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: const Color(0xFF4682B4)
                                            .withOpacity(0.6),
                                        child: Text(
                                          '${_rentalPrice * _rentalHours} €',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    key: const Key('decrement-hours-button'),
                                    icon: const Icon(Icons.remove),
                                    onPressed: _decrementHours,
                                  ),
                                  Text(
                                      '$_rentalHours heure${_rentalHours > 1 ? 's' : ''}'),
                                  IconButton(
                                    key: const Key('increment-hours-button'),
                                    icon: const Icon(Icons.add),
                                    onPressed: _incrementHours,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    key: const Key('confirm-rent-button'),
                    text: 'Louer',
                    onPressed: () {
                      confirmRent();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
