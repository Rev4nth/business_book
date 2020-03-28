import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';
import '../storage_util.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'profile',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount _currentUser;
  final _baseUrl = ApiService.baseUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      setState(() {
        _currentUser = account;
      });
      final url = '$_baseUrl/api/users/token/';
      http
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "displayName": _currentUser.displayName,
          "email": _currentUser.email
        }),
      )
          .then((response) async {
        Map<String, Object> resp = json.decode(response.body);
        String token = resp["token"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleSignOut() {
    setState(() {
      _currentUser = null;
    });
    return _googleSignIn.signOut();
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text('Sales'),
            onPressed: () {
              Navigator.of(context).pushNamed('/tabs');
            },
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
