import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  Future<http.Response> request(path, header, body) async {
    return http.post(
      Uri.parse(path),
      headers: header,
      body: jsonEncode(body),
    );
  }
}
