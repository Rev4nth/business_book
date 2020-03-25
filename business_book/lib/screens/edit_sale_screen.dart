import 'dart:convert';

import 'package:business_book/screens/sales_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/sale.dart';

class EditSale extends StatefulWidget {
  static const routeName = '/edit-sale';
  @override
  _EditSaleState createState() => _EditSaleState();
}

class _EditSaleState extends State<EditSale> {
  final _form = GlobalKey<FormState>();
  final _baseUrl = 'http://192.168.1.2:3000';
  Sale _sale = Sale();

  void _saveSale() {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final url = '$_baseUrl/api/sales/';
    http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(_sale),
    );
    Navigator.of(context).popAndPushNamed(SalesListScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Sale"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter sale description.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sale.description = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sale.amount = int.parse(value);
                },
              ),
              RaisedButton(
                onPressed: _saveSale,
                child: new Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
