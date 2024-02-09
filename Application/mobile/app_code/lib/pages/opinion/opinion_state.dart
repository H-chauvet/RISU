import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'opinion_page.dart';

class OpinionPageState extends State<OpinionPage> {
  List<dynamic> opinionsList = [];
  int selectedStarFilter = 6;
  final LoaderManager _loaderManager = LoaderManager();

  void getOpinions() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      var url = '';
      if (selectedStarFilter == 6) {
        url = 'http://$serverIp:8080/api/opinion';
      } else {
        url = 'http://$serverIp:8080/api/opinion?note=$selectedStarFilter';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userInformation?.token}',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final opinions = data['result'];
        if (opinions == null) {
          opinionsList = [];
          return;
        }
        setState(() {
          opinionsList = opinions;
        });
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'getOpinions',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringGettingReviews);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringGettingReviews);
        return;
      }
    }
  }

  void postOpinion(note, comment) async {
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.post(
        Uri.parse('http://$serverIp:8080/api/opinion'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userInformation?.token}',
        },
        body: jsonEncode(<String, String>{
          'note': note.toString(),
          'comment': comment,
        }),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 201) {
        if (context.mounted) {
          getOpinions();
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.reviewAdded,
            message: AppLocalizations.of(context)!.reviewAddedSuccessfully,
          );
        }
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'postOpinion',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringSavingReview);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return;
      }
    }
  }

  void _showAddOpinionDialog() {
    String comment = '';
    int selectedStar = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.reviewAdd),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Champ de note
                  Row(
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        key: Key('opinion-star_$index'),
                        icon: Icon(
                          index < selectedStar ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedStar = index + 1;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextInput(
                    key: const Key('opinion-textinput_comment'),
                    labelText: AppLocalizations.of(context)!.comment,
                    keyboardType: TextInputType.text,
                    icon: Icons.comment,
                    onChanged: (value) => comment = value,
                    height: 100,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyOutlinedButton(
                      text: AppLocalizations.of(context)!.cancel,
                      key: const Key('cancel-button'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    MyOutlinedButton(
                      text: AppLocalizations.of(context)!.add,
                      key: const Key('opinion-button_add'),
                      onPressed: () {
                        postOpinion(selectedStar, comment);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getOpinions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.reviewsList,
                            key: const Key('opinion-title'),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                DropdownButton<int>(
                                  key: const Key('opinion-filter_dropdown'),
                                  value: selectedStarFilter,
                                  items: [
                                    DropdownMenuItem<int>(
                                      value: 0,
                                      key: const Key(
                                          'opinion-filter_dropdown_0'),
                                      child: Text(
                                        AppLocalizations.of(context)!.starsX(0),
                                      ),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 1,
                                      key: const Key(
                                          'opinion-filter_dropdown_1'),
                                      child: Text(
                                        AppLocalizations.of(context)!.starsX(1),
                                      ),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 2,
                                      key: const Key(
                                          'opinion-filter_dropdown_2'),
                                      child: Text(
                                        AppLocalizations.of(context)!.starsX(2),
                                      ),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 3,
                                      key: const Key(
                                          'opinion-filter_dropdown_3'),
                                      child: Text(
                                        AppLocalizations.of(context)!.starsX(3),
                                      ),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 4,
                                      key: const Key(
                                          'opinion-filter_dropdown_4'),
                                      child: Text(
                                        AppLocalizations.of(context)!.starsX(4),
                                      ),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 5,
                                      key: const Key(
                                          'opinion-filter_dropdown_5'),
                                      child: Text(
                                        AppLocalizations.of(context)!.starsX(5),
                                      ),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: 6,
                                      key: const Key(
                                          'opinion-filter_dropdown_all'),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .reviewsAll,
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStarFilter = value ?? 0;
                                    });
                                    getOpinions();
                                  },
                                ),
                                if (opinionsList.isNotEmpty)
                                  for (var opinion in opinionsList)
                                    Card(
                                      elevation: 5,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        key: Key(
                                            'opinion-listTile_${opinion['id']}'),
                                        title: Text(
                                          '${(opinion['firstName'] ?? AppLocalizations.of(context)!.anonymous)} ${(opinion['lastName'] ?? '')}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            Row(
                                              children: List.generate(
                                                5,
                                                (index) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: Icon(
                                                    index <
                                                            int.parse(
                                                                opinion['note'])
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: index <
                                                            int.parse(
                                                                opinion['note'])
                                                        ? Colors.yellow
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              opinion['comment'],
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                if (opinionsList.isEmpty)
                                  Text(
                                    AppLocalizations.of(context)!.reviewsEmpty,
                                    style: TextStyle(fontSize: 16),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_opinion-button'),
        onPressed: () {
          _showAddOpinionDialog();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
