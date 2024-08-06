import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:http/http.dart' as http;

class ConfirmAccountPage extends StatefulWidget {
  final String token;

  const ConfirmAccountPage({
    super.key,
    required this.token,
  });

  @override
  State<ConfirmAccountPage> createState() => _ConfirmAccountPageState();
}

class _ConfirmAccountPageState extends State<ConfirmAccountPage> {
  String message = 'Confirming your account...';

  @override
  void initState() {
    super.initState();
    _confirmAccount();
  }

  Future<void> _confirmAccount() async {
    final url = Uri.parse(
        'http://$serverIp:3000/api/mobile/auth/mailVerification?token=${widget.token}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        message = 'Your account has been confirmed!';
      });
    } else {
      setState(() {
        message = 'Failed to confirm your account. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Risu",
        context: context,
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
