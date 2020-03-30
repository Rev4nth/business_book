import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sale.dart';
import '../models/customer.dart';
import './sales_list_screen.dart';
import '../services/api.dart';

class EditSale extends StatefulWidget {
  static const routeName = '/edit-sale';
  @override
  _EditSaleState createState() => _EditSaleState();
}

class _EditSaleState extends State<EditSale> {
  final _form = GlobalKey<FormState>();
  final _baseUrl = ApiService.baseUrl;
  Sale _sale = Sale();

  List<Customer> _customersList = [];
  bool _loading = true;

  void getCustomers() async {
    final url = '$_baseUrl/api/customers/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.get(url, headers: {
      'Authorization': 'Bearer $token',
    }).then((response) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Customer> customersList =
          parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
      setState(() {
        _customersList = customersList;
      });
    });
  }

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

  void _saveSale() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final url = '$_baseUrl/api/sales/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(_sale.toJson(), toEncodable: encodeDateToString),
    );
    Navigator.of(context).popAndPushNamed(
      SalesListScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      _loading = false;
      getCustomers();
    }
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Customer"),
                    DropdownButton<int>(
                      value: _sale.customerId,
                      items: _customersList.map((Customer customer) {
                        return DropdownMenuItem(
                            value: customer.id, child: Text(customer.name));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _sale.customerId = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
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
