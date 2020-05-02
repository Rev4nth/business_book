import 'package:flutter/material.dart';

import '../services/api.dart';
import './customer_edit_screen.dart';
import '../models/customer.dart';

class CustomerDetailScreen extends StatefulWidget {
  static const routeName = '/customer-detail';
  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Customer customer;
  bool isLoading = true;
  bool refresh = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final customerId = ModalRoute.of(context).settings.arguments as int;
    if (customer == null) {
      customer = await ApiService.getCustomerDetails(customerId);
      setState(() {
        isLoading = false;
      });
    } else if (refresh) {
      customer = await ApiService.getCustomerDetails(customerId);
    }
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
      body: isLoading
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
                        value: customer.name,
                      ),
                      buildCustomerDetailsItem(
                        label: "Contact No.",
                        value: customer.contact,
                      ),
                      Center(
                        child: RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text("Edit Customer"),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerEditScreen(
                                  id: customer.id,
                                  name: customer.name,
                                  contact: customer.contact,
                                ),
                              ),
                            );
                            setState(() {
                              refresh = result == null ? true : result;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
