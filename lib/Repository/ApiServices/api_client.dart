import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final Map<String, String> defaultHeaders;

  ApiClient({this.defaultHeaders = const {}});

  Future<Map<String, dynamic>> get(String apiUrl,
      {Map<String, String>? headers}) async {
    final url = Uri.parse(apiUrl);
    final response = await http.get(
      url,
      headers: {...defaultHeaders, if (headers != null) ...headers},
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String apiUrl, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(apiUrl);
    final response = await http.post(
      url,
      headers: {...defaultHeaders, if (headers != null) ...headers},
      body: body,
    );
    // return _processResponse(response);
    final decoded = jsonDecode(response.body);
    return {
      'statusCode': response.statusCode,
      ...decoded,
    };
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode == 200 || statusCode == 401) {
      return jsonDecode(response.body);
    } else {
      debugPrint(
          'Error: ${response.reasonPhrase}, Status Code: $statusCode, Body: ${response.body}');
      throw Exception(
        'Error: ${response.reasonPhrase}, Status Code: $statusCode, Body: ${response.body}',
      );
    }
  }
}
