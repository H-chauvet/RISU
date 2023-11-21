import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/text_input.dart';
import '../../network/informations.dart';
import '../../utils/theme.dart';
import 'rent_page.dart';
import '../../components/alert_dialog.dart';

class RentArticlePageState extends State<RentArticlePage> {
  int _rentalHours = 1;
  int _rentalPrice = 5;
  String _articleName = 'Nom de l\'article';

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
          'Authorization': '$token',
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
  void initState() {
    super.initState();
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
                Text(
                  'Location de l\'article',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 16),
                // image
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/volley.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                            style: TextStyle(
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
                                        child: Text(
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
                                        color: Color(0xFF4682B4),
                                        child: Text(
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
                                          _rentalPrice.toString() + ' €',
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
                                        color:
                                            Color(0xFF4682B4).withOpacity(0.6),
                                        child: Text(
                                          (_rentalPrice * _rentalHours)
                                                  .toString() +
                                              ' €',
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
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
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
                                    key: Key('decrement-hours-button'),
                                    icon: Icon(Icons.remove),
                                    onPressed: _decrementHours,
                                  ),
                                  Text('$_rentalHours heures'),
                                  IconButton(
                                    key: Key('increment-hours-button'),
                                    icon: Icon(Icons.add),
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

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    key: Key('confirm-rent-button'),
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
