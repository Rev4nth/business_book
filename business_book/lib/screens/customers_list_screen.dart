import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/customer_item.dart';
import '../providers/customers.dart';
import '../services/api.dart';
// import '../models/customer.dart';

class CustomersListScreen extends StatefulWidget {
  static const routeName = '/customers';
  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  var _isLoading = false;
  List customersList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (customersList == null) {
      fetchCustomers();
    }
  }

  Future<void> fetchCustomers() async {
    final String url = '${ApiService.baseUrl}/api/customers/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final parsed = json.decode(response.body);
    final List<Customer> loadedCustomers =
        parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
    setState(() {
      customersList = loadedCustomers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: ListView.builder(
                itemCount: customersList == null ? 0 : customersList.length,
                itemBuilder: (context, index) {
                  return CustomerItem(
                    id: customersList[index].id,
                    name: customersList[index].name,
                    contact: customersList[index].contact,
                  );
                }),
          );
  }
}
