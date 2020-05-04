import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../services/api.dart';

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
        future: ApiService.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              print(snapshot);
              return Container(
                height: 160,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Center(
                        child: Text(
                          snapshot.data.displayName,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          snapshot.data.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Divider(),
                      Center(
                        child: Text(
                          "Business Name: ${snapshot.data.account.name}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ]),
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
