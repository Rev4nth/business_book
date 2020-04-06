import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tabs_screen.dart';
import './screens/edit_sale_screen.dart';
import './screens/edit_customer_screen.dart';
import './screens/login_screen.dart';
import './providers/auth.dart';
import './providers/sales.dart';
import './providers/customers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProvider<Sales>(create: (_) => Sales()),
        ChangeNotifierProvider<Customers>(create: (_) => Customers()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: "Business Book",
          home: auth.isAuth ? TabsScreen() : LoginScreen(),
          routes: {
            '/tabs': (context) => TabsScreen(),
            '/auth': (context) => LoginScreen(),
            '/edit-sale': (context) => EditSale(),
            '/edit-customer': (context) => EditCustomer(),
          },
        ),
      ),
    );
  }
}
