import 'package:flutter/material.dart';

class CustomersListScreen extends StatefulWidget {
  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Customers List"),
      ),
    );
  }
}
