// feedbacks_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/dialog/dialog_cubit.dart';
import 'package:front/components/dialog/rating_dialog_content/rating_dialog_content.dart';
import 'package:front/components/footer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/screens/feedbacks/feedbacks_card.dart';
import 'package:front/screens/feedbacks/feedbacks_style.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({Key? key}) : super(key: key);

  @override
  _FeedbacksPageState createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  String jwtToken = '';
  List<Feedbacks> feedbacks = [];

  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != "") {
      jwtToken = token!;
    } else {
      context.go(
        '/login',
      );
    }
  }

  @override
  void initState() {
    checkToken();
    super.initState();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    final response = await http
        .get(Uri.parse('http://${serverIp}:3000/api/feedbacks/listAll'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> feedbacksData = responseData["feedbacks"];
      setState(() {
        feedbacks =
            feedbacksData.map((data) => Feedbacks.fromJson(data)).toList();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return BlocProvider(
      create: (context) => DialogCubit(),
      child: Scaffold(
        appBar: CustomAppBar('Les avis de RISU', context: context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider(
                          create: (context) => DialogCubit(),
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 0,
                            backgroundColor:
                                Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.colorScheme.background
                                    : lightTheme.colorScheme.background,
                            child: Container(
                              width: screenFormat == ScreenFormat.desktop
                                  ? desktopContainerWidth
                                  : tabletContainerWidth,
                              height: screenFormat == ScreenFormat.desktop
                                  ? desktopContainerHeight
                                  : tabletContainerHeight,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Poster un avis',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            screenFormat == ScreenFormat.desktop
                                                ? desktopFontSize
                                                : tabletFontSize,
                                      ),
                                    ),
                                  ),
                                  RatingDialogContent(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Poster un avis',
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
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: feedbacks.length,
                itemBuilder: (context, index) {
                  final product = feedbacks[index];
                  return FeedbacksCard(
                    fb: product,
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
