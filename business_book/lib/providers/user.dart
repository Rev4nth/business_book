import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';

class User with ChangeNotifier {
  String displayName;
  String email;
  String accountName;

  Future<void> fetchUser() async {
    final _baseUrl = ApiService.baseUrl;
    final url = '$_baseUrl/api/users/profile/';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final parsed = json.decode(response.body);
      displayName = parsed["displayName"];
      email = parsed["email"];
      accountName = parsed["Account"]["name"];
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}
