import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/pop_scope_parent.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'opinion_page.dart';

class OpinionPageState extends State<OpinionPage> {
  int itemId;

  OpinionPageState({required this.itemId, this.opinionsList = const []});

  List<dynamic> opinionsList = [];
  int selectedStarFilter = 6;
  final LoaderManager _loaderManager = LoaderManager();

  void getOpinions(itemId) async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      var url = '';
      if (selectedStarFilter == 6) {
        url = '$baseUrl/api/mobile/opinion?itemId=$itemId';
      } else {
        url =
            '$baseUrl/api/mobile/opinion?note=$selectedStarFilter&itemId=$itemId';
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
      switch (response.statusCode) {
        case 201:
          final data = json.decode(response.body);
          setState(() {
            opinionsList = data['opinions'];
          });
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'getOpinions',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringGettingReviews);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringGettingReviews);
        return;
      }
      return;
    }
  }

  void postOpinion(note, comment) async {
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.post(
        Uri.parse('$baseUrl/api/mobile/opinion?itemId=$itemId'),
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
      switch (response.statusCode) {
        case 201:
          if (mounted) {
            getOpinions(itemId);
            await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.reviewAdded,
              message: AppLocalizations.of(context)!.reviewAddedSuccessfully,
            );
          }
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'postOpinion',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringSavingReview);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return;
      }
      return;
    }
  }

  void updateOpinion(opinionId, note, comment) async {
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.put(
        Uri.parse('$baseUrl/api/mobile/opinion/$opinionId'),
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
      switch (response.statusCode) {
        case 201:
          if (mounted) {
            getOpinions(itemId);
            await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.reviewUpdated,
              message: AppLocalizations.of(context)!.reviewUpdatedSuccessfully,
            );
          }
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'updateOpinion',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringReviewUpdate);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return;
      }
    }
  }

  void deleteOpinion(opinionId) async {
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.delete(
        Uri.parse('$baseUrl/api/mobile/opinion/$opinionId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userInformation?.token}',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      switch (response.statusCode) {
        case 201:
          if (mounted) {
            getOpinions(itemId);
            await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.reviewDeleted,
              message: AppLocalizations.of(context)!.reviewDeletedSuccessfully,
            );
          }
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'deleteOpinion',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringReviewDeletion);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
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
      builder: (BuildContext ontext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.reviewAdd),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        if (comment == '') {
                          MyAlertDialog.showInfoAlertDialog(
                            context: context,
                            title: AppLocalizations.of(context)!.invalidForm,
                            message: AppLocalizations.of(context)!.fillComment,
                          );
                          return;
                        }
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

  void _showUpdateOpinionDialog(opinionId, currentNote, currentComment) {
    String comment = currentComment;
    int selectedStar = int.parse(currentNote);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.reviewUpdate),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    initialValue: currentComment,
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
                      text: AppLocalizations.of(context)!.update,
                      key: const Key('opinion-button_add'),
                      onPressed: () {
                        updateOpinion(opinionId, selectedStar, comment);
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

  void _showParameterDialog(opinionId, note, comment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.settings),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyOutlinedButton(
                      text: AppLocalizations.of(context)!.delete,
                      key: const Key('delete-button'),
                      onPressed: () {
                        deleteOpinion(opinionId);
                        Navigator.of(context).pop();
                      },
                    ),
                    MyOutlinedButton(
                      text: AppLocalizations.of(context)!.update,
                      key: const Key('update-button'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showUpdateOpinionDialog(opinionId, note, comment);
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
    if (widget.testOpinions.isNotEmpty) {
      setState(() {
        opinionsList = widget.testOpinions;
      });
    } else {
      getOpinions(itemId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyPopScope(
      child: Scaffold(
        appBar: MyAppBar(
          curveColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor),
          showBackButton: false,
          textTitle: AppLocalizations.of(context)!.reviewsList,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.colorScheme.surface),
        body: (_loaderManager.getIsLoading())
            ? Center(child: _loaderManager.getLoader())
            : SingleChildScrollView(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                          AppLocalizations.of(context)!
                                              .starsX(0),
                                        ),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 1,
                                        key: const Key(
                                            'opinion-filter_dropdown_1'),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .starsX(1),
                                        ),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 2,
                                        key: const Key(
                                            'opinion-filter_dropdown_2'),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .starsX(2),
                                        ),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 3,
                                        key: const Key(
                                            'opinion-filter_dropdown_3'),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .starsX(3),
                                        ),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 4,
                                        key: const Key(
                                            'opinion-filter_dropdown_4'),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .starsX(4),
                                        ),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 5,
                                        key: const Key(
                                            'opinion-filter_dropdown_5'),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .starsX(5),
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
                                      getOpinions(itemId);
                                    },
                                  ),
                                  if (opinionsList.isNotEmpty)
                                    for (var i = 0;
                                        i < opinionsList.length;
                                        i++)
                                      Card(
                                        key: Key('opinion-card_$i'),
                                        elevation: 5,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 15, 15, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    key: Key('opinion-user_$i'),
                                                    child: Text(
                                                      (opinionsList[i][
                                                                      'user'] !=
                                                                  null &&
                                                              opinionsList[i][
                                                                          'user']
                                                                      [
                                                                      'firstName'] !=
                                                                  null &&
                                                              opinionsList[i][
                                                                          'user']
                                                                      [
                                                                      'lastName'] !=
                                                                  null)
                                                          ? '${opinionsList[i]['user']['firstName']} ${opinionsList[i]['user']['lastName']}'
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .anonymous,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (opinionsList[i]
                                                          ['userId'] ==
                                                      userInformation?.ID)
                                                    IconButton(
                                                      key: Key(
                                                          'opinion-settings_button_$i'),
                                                      icon: const Icon(
                                                          Icons.more_vert),
                                                      onPressed: () {
                                                        _showParameterDialog(
                                                            opinionsList[i]
                                                                ['id'],
                                                            opinionsList[i]
                                                                ['note'],
                                                            opinionsList[i]
                                                                ['comment']);
                                                      },
                                                    ),
                                                ],
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(20)
                                                      .copyWith(top: 0),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: List.generate(
                                                      5,
                                                      (index) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 2),
                                                        child: Icon(
                                                          key: Key(
                                                              'opinion-star_$i-$index'),
                                                          index <
                                                                  int.parse(
                                                                      opinionsList[
                                                                              i]
                                                                          [
                                                                          'note'])
                                                              ? Icons.star
                                                              : Icons
                                                                  .star_border,
                                                          color: index <
                                                                  int.parse(
                                                                      opinionsList[
                                                                              i]
                                                                          [
                                                                          'note'])
                                                              ? Colors.yellow
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    key: Key(
                                                        'opinion-comment_$i'),
                                                    opinionsList[i]['comment'],
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  if (opinionsList.isEmpty)
                                    Text(
                                      key: const Key('opinion-empty_text'),
                                      AppLocalizations.of(context)!
                                          .reviewsEmpty,
                                      style: const TextStyle(fontSize: 16),
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
          onPressed: () async {
            bool signIn = await checkSignin(context);
            if (!signIn) {
              return;
            }
            _showAddOpinionDialog();
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
