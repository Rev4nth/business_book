import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/customers.dart';
import '../services/api.dart';

class CustomerEditScreen extends StatefulWidget {
  static String routeName = '/edit-customer';
  final int id;
  final String name;
  final String contact;

  CustomerEditScreen({this.id, this.name, this.contact});

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrl = ApiService.baseUrl;
  Customer _customer = Customer();

  void _updateCustomer(BuildContext context) async {
    var isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    _customer.id = widget.id;
    final url = '$_baseUrl/api/customers/${widget.id}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(_customer),
    );
    if (response.statusCode == 400) {
      final parsedResponse = json.decode(response.body);
      final snackBar = SnackBar(
        content: Text(parsedResponse['error']),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      Navigator.of(context).pop(true);
      // Navigator.of(context).pushNamed(TabsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
      ),
      body: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      initialValue: widget.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a name.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _customer.name = value.trim();
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
                      initialValue: widget.contact,
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
                        _customer.contact = value;
                      },
                    ),
                    SizedBox(height: 16),
                    RaisedButton(
                      onPressed: () {
                        _updateCustomer(context);
                      },
                      child: new Text('Update'),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
