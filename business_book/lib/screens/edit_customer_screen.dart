import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';
import '../services/api.dart';

class EditCustomer extends StatefulWidget {
  static const routeName = '/edit-customer';
  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final _form = GlobalKey<FormState>();
  final _baseUrl = ApiService.baseUrl;
  Customer _customer = Customer();

  void _saveCustomer() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final url = '$_baseUrl/api/customers/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(_customer),
    );
    Navigator.of(context).popAndPushNamed(
      '/',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Customer"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _customer.name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact'),
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
                  _customer.contact = value;
                },
              ),
              RaisedButton(
                onPressed: _saveCustomer,
                child: new Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
