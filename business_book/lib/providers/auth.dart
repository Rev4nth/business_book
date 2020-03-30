import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
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

class Auth with ChangeNotifier {
  String _token;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signIn() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    final _baseUrl = ApiService.baseUrl;
    final url = '$_baseUrl/api/users/token/';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            'email': account.email,
            'displayName': account.displayName,
          },
        ),
      );
      final responseData = json.decode(response.body);
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
}
