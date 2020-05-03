import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
      ),
      body: Consumer<User>(builder: (context, auth, _) {
        return auth.isAuth
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Signed in successfully."),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("You are not currently signed in."),
                    RaisedButton(
                      child: const Text('SIGN IN'),
                      onPressed: () async {
                        await Provider.of<User>(context, listen: false)
                            .signIn();
                      },
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
