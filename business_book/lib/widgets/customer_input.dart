import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';
import '../models/customer.dart';

class CustomerInput extends StatefulWidget {
  final Function onChange;
  CustomerInput({this.onChange});

  @override
  _CustomerInputState createState() => _CustomerInputState();
}

class _CustomerInputState extends State<CustomerInput> {
  List<Customer> customersList = [];
  int customerId;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    final _baseUrl = ApiService.baseUrl;
    final url = '$_baseUrl/api/customers/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Customer> customers =
          parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
      setState(() {
        customersList = customers;
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Customer",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          DropdownButton<int>(
            value: customerId,
            hint: Text('Select a customer'),
            items: customersList.map((Customer customer) {
              return DropdownMenuItem(
                child: Text(customer.name),
                value: customer.id,
              );
            }).toList(),
            onChanged: (value) {
              widget.onChange(value);
              setState(() {
                customerId = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
