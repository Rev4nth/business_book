import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'profile',
  ],
);

class User with ChangeNotifier {
  String _token;
  int userAccount;
  String displayName;
  String email;
  String accountName;

  bool get isAuth {
    return _token != null;
  }

  bool get hasAccount {
    return userAccount != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signIn() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await account.authentication;

    final _baseUrl = ApiService.baseUrl;
    final url = '$_baseUrl/api/users/token/';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'idToken': googleAuth.idToken}),
      );
      print(response);
      final responseData = json.decode(response.body);
      userAccount = responseData['user']['accountId'];
      _token = responseData['token'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signOut() async {
    _token = null;
    _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<void> saveAccount(String accountName) async {
    final _baseUrl = ApiService.baseUrl;
    final url = '$_baseUrl/api/users/account/';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"accountName": accountName}),
      );
      final responseData = json.decode(response.body);
      userAccount = responseData['user']['accountId'];
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

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
