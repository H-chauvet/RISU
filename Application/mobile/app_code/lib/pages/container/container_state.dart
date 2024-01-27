import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';

import 'container_list.dart';
import 'container_page.dart';

class ContainerPageState extends State<ContainerPage> {
  List<ContainerList> containers = [];
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();
    getContainer();
  }

  void getContainer() async {
    try {
      _loaderManager.setIsLoading(true);
      final response = await http.get(
        Uri.parse('http://$serverIp:8080/api/container/listall'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);
        await Future.delayed(const Duration(milliseconds: 500));
        _loaderManager.setIsLoading(false);
        final List<dynamic> containersData = responseData;
        setState(() {
          containers = containersData
              .map((data) => ContainerList.fromJson(data))
              .toList();
        });
      } else {
        _loaderManager.setIsLoading(false);
        if (context.mounted) {
          printServerResponse(context, response, 'getContainer');
        }
      }
    } catch (err, stacktrace) {
      _loaderManager.setIsLoading(false);
      if (context.mounted) {
        printCatchError(context, err, stacktrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Liste des conteneurs',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          if (containers.isEmpty)
                            Text(
                              'Aucun conteneur trouvé.',
                              style: TextStyle(
                                fontSize: 18,
                                color: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.primaryColor),
                              ),
                            )
                          else ...[
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: containers.length,
                              itemBuilder: (context, index) {
                                final product = containers.elementAt(index);
                                return ContainerCard(
                                  container: product,
                                );
                              },
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
