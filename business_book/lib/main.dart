import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tabs_screen.dart';
import './screens/sale_add_screen.dart';
import './screens/customer_add_screen.dart';
import './screens/expense_add_screen.dart';
import './screens/login_screen.dart';
import './screens/sale_detail_screen.dart';
import './screens/customer_detail_screen.dart';
import './screens/profile_screen.dart';
import './screens/expense_detail_screen.dart';

import './providers/user.dart';

void main() => runApp(MyApp());

Widget loadHomePage(user) {
  if (!user.isAuth) {
    return LoginScreen();
  }
  if (user.isAuth && user.hasAccount) {
    return TabsScreen();
  }
  if (user.isAuth && !user.hasAccount) {
    return AccountScreen();
  }
  return null;
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
                    Provider.of<User>(context, listen: false)
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
        ChangeNotifierProvider<User>(create: (_) => User()),
      ],
      child: Consumer<User>(
        builder: (context, user, _) => MaterialApp(
          title: "Business Book",
          home: loadHomePage(user),
          routes: {
            '/tabs': (context) => TabsScreen(),
            '/auth': (context) => LoginScreen(),
            SaleAddScreen.routeName: (context) => SaleAddScreen(),
            ExpenseAddScreen.routeName: (context) => ExpenseAddScreen(),
            CustomerAddScreen.routeName: (context) => CustomerAddScreen(),
            SaleDetailScreen.routeName: (context) => SaleDetailScreen(),
            ExpenseDetailScreen.routeName: (context) => ExpenseDetailScreen(),
            CustomerDetailScreen.routeName: (context) => CustomerDetailScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen()
          },
        ),
      ),
    );
  }
}
