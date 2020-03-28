import 'package:flutter/material.dart';

import './screens/tabs_screen.dart';
import './screens/edit_sale_screen.dart';
import './screens/edit_customer_screen.dart';
import './screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Business Book",
      routes: {
        '/tabs': (context) => TabsScreen(),
        '/': (context) => LoginScreen(),
        '/edit-sale': (context) => EditSale(),
        '/edit-customer': (context) => EditCustomer(),
      },
    );
  }
}
