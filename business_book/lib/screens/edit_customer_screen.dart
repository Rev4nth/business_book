import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './customers_list_screen.dart';
import '../models/customer.dart';

class EditCustomer extends StatefulWidget {
  static const routeName = '/edit-customer';
  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final _form = GlobalKey<FormState>();
  final _baseUrl = 'http://192.168.1.7:3000';
  Customer _customer = Customer();

  void _saveCustomer() {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final url = '$_baseUrl/api/customers/';
    http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(_customer),
    );
    Navigator.of(context).popAndPushNamed(
      '/',
      arguments: 1,
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
