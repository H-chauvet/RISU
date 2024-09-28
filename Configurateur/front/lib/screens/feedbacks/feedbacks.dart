// feedbacks_page.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_popup.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/dialog/dialog_cubit.dart';
import 'package:front/components/dialog/rating_dialog_content/rating_dialog_content.dart';
import 'package:front/components/footer.dart';
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

/// FeedbacksPage
///
/// Page to show the feedbacks about Risu
class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({Key? key}) : super(key: key);

  @override
  _FeedbacksPageState createState() => _FeedbacksPageState();
}

/// FeedbacksPageState
///
class _FeedbacksPageState extends State<FeedbacksPage> {
  String jwtToken = '';
  List<Feedbacks> feedbacks = [];

  /// [Function] : Check the token in the storage service
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

  /// [Function] : Get all the feedbacks in the database
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
      showCustomToast(context, response.body, false);
    }
  }

  /// [Widget] : Build the feedback page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return BlocProvider(
      create: (context) => DialogCubit(),
      child: Scaffold(
        body: FooterView(
          footer: Footer(
            padding: EdgeInsets.zero,
            child: const CustomFooter(),
          ),
          children: [
            Column(
              children: [
                LandingAppBar(context: context),
                Text(
                  AppLocalizations.of(context)!.opinionConsultCreate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                      key: const Key('feedbacks-post_opinion'),
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
                            return CustomPopup(
                              title: AppLocalizations.of(context)!.opinionPost,
                              content: Column(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.opinionShare,
                                    style: TextStyle(
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                      fontSize:
                                          screenFormat == ScreenFormat.desktop
                                              ? desktopFontSize
                                              : tabletFontSize,
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => DialogCubit(),
                                    child: RatingDialogContent(
                                      onSubmit: fetchFeedbacks,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.opinionPage,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
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
          ],
        ),
      ),
    );
  }
}
