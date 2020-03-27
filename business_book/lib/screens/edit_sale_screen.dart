import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/sale.dart';
import './sales_list_screen.dart';

class EditSale extends StatefulWidget {
  static const routeName = '/edit-sale';
  @override
  _EditSaleState createState() => _EditSaleState();
}

class _EditSaleState extends State<EditSale> {
  final _form = GlobalKey<FormState>();
  final _baseUrl = 'http://192.168.1.7:3000';
  Sale _sale = Sale();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _sale.date = pickedDate;
      });
    });
  }

  dynamic encodeDateToString(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

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
      body: json.encode(_sale.toJson(), toEncodable: encodeDateToString),
    );
    Navigator.of(context).popAndPushNamed(
      SalesListScreen.routeName,
    );
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
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _sale.date == null
                            ? 'No Date Chosen!'
                            : 'Sale Date: ${DateFormat.yMd().format(_sale.date)}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
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
