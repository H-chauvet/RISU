import 'package:http/http.dart' as http;
import 'dart:convert';

/// Http service to do requests easier
class HttpService {
  /// [Function] : Post request
  ///
  /// [path] : request's path
  /// [header] : request's header
  /// [body] : request's body
  Future<http.Response> request(path, header, body) async {
    return http.post(
      Uri.parse(path),
      headers: header,
      body: jsonEncode(body),
    );
  }

  /// [Function] : Put request
  ///
  /// [path] : request's path
  /// [header] : request's header
  /// [body] : request's body
  Future<http.Response> putRequest(path, header, body) async {
    return http.put(
      Uri.parse(path),
      headers: header,
      body: jsonEncode(body),
    );
  }

  /// [Function] : Get request
  ///
  /// [path] : request's path
  /// [header] : request's header
  Future<http.Response> getRequest(path, header) async {
    return http.get(
      Uri.parse(path),
      headers: header,
    );
  }
}
