import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/customer_item.dart';
import '../models/customer.dart';

class CustomersListScreen extends StatefulWidget {
  static const routeName = '/customers';
  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  final _baseUrl = 'http://192.168.1.2:3000';
  List<Customer> _customersList = [];
  bool _loading = true;

  void getCustomers() {
    final url = '$_baseUrl/api/customers/';
    http.get(url).then((response) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Customer> customersList =
          parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
      setState(() {
        _customersList = customersList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      _loading = false;
      getCustomers();
    }
    return Container(
      child: ListView.builder(
          itemCount: _customersList.length,
          itemBuilder: (context, index) {
            return CustomerItem(
              name: _customersList[index].name,
              contact: _customersList[index].contact,
            );
          }),
    );
  }
}
