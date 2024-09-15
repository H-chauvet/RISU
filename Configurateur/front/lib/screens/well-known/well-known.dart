import 'package:flutter/material.dart';
import 'package:front/network/informations.dart';
import 'package:http/http.dart' as http;

class WellKnownPage extends StatefulWidget {
  const WellKnownPage({super.key});

  @override
  _WellKnownPageState createState() => _WellKnownPageState();
}

class _WellKnownPageState extends State<WellKnownPage> {
  String? _response;

  @override
  void initState() {
    super.initState();
    fetchApiResponse();
  }

  Future<void> fetchApiResponse() async {
    final url = Uri.parse('http://$serverIp:3000/.well-known/assetlinks.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _response = response.body;
        });
      } else {
        setState(() {
          _response =
              'Failed to load data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _response != null
            ? SingleChildScrollView(child: Text(_response!))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
