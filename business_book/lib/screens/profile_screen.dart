import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<User>(context, listen: false).fetchUser(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<User>(
                builder: (ctx, user, child) => Container(
                  height: 120,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Center(
                          child: Text(
                            user.displayName,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            user.accountName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
