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

  Future<http.Response> putRequest(path, header, body) async {
    return http.put(
      Uri.parse(path),
      headers: header,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getRequest(path, header) async {
    return http.get(
      Uri.parse(path),
      headers: header,
    );
  }
}
