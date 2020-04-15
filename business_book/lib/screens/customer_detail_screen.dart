import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';

class CustomerDetailScreen extends StatefulWidget {
  static const routeName = '/customer-detail';
  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Map<String, dynamic> customerDetails;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    final customerId = ModalRoute.of(context).settings.arguments as int;
    if (customerDetails == null) {
      fetchCustomerDetails(customerId);
    }
    super.didChangeDependencies();
  }

  Future<void> fetchCustomerDetails(int customerId) async {
    final String url =
        '${ApiService.baseUrl}/api/customers/${customerId.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    setState(() {
      customerDetails = json.decode(response.body);
      _isLoading = false;
    });
  }

  Widget buildCustomerDetailsItem(
      {String label, String value, Color valueColor = Colors.black}) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              color: valueColor,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Customer Details'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildCustomerDetailsItem(
                          label: "Name",
                          value: customerDetails['name'],
                        ),
                        buildCustomerDetailsItem(
                            label: "Contact No.",
                            value: customerDetails['contact']),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
