// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/dialog/dialog_cubit.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'rating_dialog_content_style.dart';

/// [Function] : get the user details
/// [email] : mail save in the storage service
/// return userDetails
Future<Map<String, dynamic>> fetchUserDetails(BuildContext context, String email) async {
  final String apiUrl = "http://$serverIp:3000/api/auth/user-details/$email";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> userDetails = json.decode(response.body);
      debugPrint('User details: $userDetails');
      return userDetails;
    } else {
      debugPrint(
          'Failed to fetch user details. Status code: ${response.statusCode}');
      return {"error": true};
    }
  } catch (error) {
    debugPrint('Error fetching user details: $error');
    return {};
  }
}

/// [Function] : Send feedback in the back end
/// [rating] : rating of Risu
/// [message] : client's message
///
Future<void> sendData(BuildContext context, String rating, String message,
    Function() onSubmit) async {
  String userMail = await storageService.getUserMail();
  final userDetails = await fetchUserDetails(context, userMail);
  if (userDetails['error'] == true) {
    if (context.mounted) {
      showCustomToast(context, "Failed to fetch user details.", false);
    }
    return;
  }
  String firstName = userDetails['firstName'];
  String lastName = userDetails['lastName'];

  

  var body = {
    'firstName': firstName,
    'lastName': lastName,
    'email': userMail,
    'message': message,
    'mark': rating,
  };

  var response = await http.post(
    Uri.parse('http://$serverIp:3000/api/feedbacks/create'),
    body: body,
  );

  debugPrint(response.toString());
  if (response.statusCode == 200) {
    showCustomToast(context, response.body, true);
    onSubmit();
  } else {
    showCustomToast(context, response.body, false);
  }
}

/// RatingDialogContent
///
/// Add a new dialog to create rating with message to an item
class RatingDialogContent extends StatelessWidget {
  final Function() onSubmit;

  const RatingDialogContent({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return BlocBuilder<DialogCubit, DialogState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12.0),
            RatingBar.builder(
              initialRating: state.rating.toDouble(),
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: screenFormat == ScreenFormat.desktop
                  ? desktopIconSize
                  : tabletIconSize,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: index < state.rating ? Colors.amber : Colors.grey,
              ),
              onRatingUpdate: (rating) {
                context.read<DialogCubit>().updateRating(rating.toInt());
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              constraints: BoxConstraints(
                maxWidth: 30.0.w,
              ),
              child: TextFormField(
                onChanged: (value) {
                  context.read<DialogCubit>().updateMessage(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Entrez votre message...',
                ),
                maxLines: 5,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez remplir ce champ';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed:  () async {
                await sendData(
                    context,
                    context.read<DialogCubit>().state.rating.toString(),
                    context.read<DialogCubit>().state.message,
                    onSubmit);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Soumettre',
                  style: TextStyle(
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopFontSize
                        : tabletFontSize,
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                  )),
            ),
          ],
        );
      },
    );
  }
}
