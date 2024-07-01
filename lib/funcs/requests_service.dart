import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Requests{
  Future<Map<String, dynamic>> httpRequest(String url, {int timeoutInSeconds = 3}) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> data = json.decode(responseBody);
        return data;
      } else {
        Map<String, dynamic> data = {};
        throw Exception(data);
      }
    } on TimeoutException {
      Map<String, dynamic> data = {};
      return data;
    } catch (error) {
      Map<String, dynamic> data = {};
      return data;
    }
  }

  Future<Map> loginRequest(String url, String username, String salt, String token) async {
    return await httpRequest("$url/rest/ping.view?v=1.12.0&c=myapp&f=json&u=$username&t=$token&s=$salt");
  }
}