import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/api.dart';
import '../models/customer.dart';
import './tabs_screen.dart';

class CustomerAddScreen extends StatefulWidget {
  static const routeName = '/add-customer';
  @override
  _CustomerAddScreenState createState() => _CustomerAddScreenState();
}

class _CustomerAddScreenState extends State<CustomerAddScreen> {
  final formState = GlobalKey<FormState>();
  Customer customer = Customer();

  void saveCustomer(BuildContext context) async {
    var isValid = formState.currentState.validate();
    if (!isValid) {
      return;
    }
    formState.currentState.save();
    var requestBody = json.encode(customer.toJson());
    var response = await ApiService.postCustomer(requestBody);
    if (response.statusCode == 400) {
      final parsedResponse = json.decode(response.body);
      final snackBar = SnackBar(
        content: Text(parsedResponse['error']),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(TabsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Add Customer"),
      ),
      body: Builder(
        builder: (context) => Container(
          padding: EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formState,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                          customer.name = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a number.';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          customer.contact = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    RaisedButton(
                      onPressed: () {
                        saveCustomer(context);
                      },
                      child: new Text('Save'),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
