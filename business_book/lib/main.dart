import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tabs_screen.dart';
import './screens/edit_sale_screen.dart';
import './screens/edit_customer_screen.dart';
import './screens/login_screen.dart';
import './screens/sale_detail_screen.dart';
import './screens/customer_detail_screen.dart';
import './screens/profile_screen.dart';

import './providers/auth.dart';
import './providers/sales.dart';
import './providers/customers.dart';
import './providers/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProvider<User>(create: (_) => User()),
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
            EditSaleScreen.routeName: (context) => EditSaleScreen(),
            EditCustomerScreen.routeName: (context) => EditCustomerScreen(),
            SaleDetailScreen.routeName: (context) => SaleDetailScreen(),
            CustomerDetailScreen.routeName: (context) => CustomerDetailScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen()
          },
        ),
      ),
    );
  }
}
