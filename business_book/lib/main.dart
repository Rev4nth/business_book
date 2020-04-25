import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tabs_screen.dart';
import './screens/sale_add_screen.dart';
import './screens/customer_add_screen.dart';
import './screens/login_screen.dart';
import './screens/sale_detail_screen.dart';
import './screens/customer_detail_screen.dart';
import './screens/profile_screen.dart';

import './providers/auth.dart';
import './providers/sales.dart';
import './providers/customers.dart';
import './providers/user.dart';

void main() => runApp(MyApp());

Widget bhome(auth) {
  if (!auth.isAuth) {
    return LoginScreen();
  }
  if (auth.isAuth && auth.hasAccount) {
    return TabsScreen();
  }
  if (auth.isAuth && !auth.hasAccount) {
    return AccountScreen();
  }
}

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String accountName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Business"),
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 24),
          child: Form(
            key: this._formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      this.accountName = value.trim();
                    });
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    var isValid = this._formKey.currentState.validate();
                    if (!isValid) {
                      return;
                    }
                    _formKey.currentState.save();
                    Provider.of<Auth>(context, listen: false)
                        .saveAccount(this.accountName);
                  },
                  child: new Text('Save'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                )
              ],
            ),
          )),
    );
  }
}

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
          // home: auth.isAuth ? TabsScreen() : LoginScreen(),
          home: bhome(auth),
          routes: {
            '/tabs': (context) => TabsScreen(),
            '/auth': (context) => LoginScreen(),
            SaleAddScreen.routeName: (context) => SaleAddScreen(),
            CustomerAddScreen.routeName: (context) => CustomerAddScreen(),
            SaleDetailScreen.routeName: (context) => SaleDetailScreen(),
            CustomerDetailScreen.routeName: (context) => CustomerDetailScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen()
          },
        ),
      ),
    );
  }
}
