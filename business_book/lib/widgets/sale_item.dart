import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/customers.dart';

class SaleItem extends StatelessWidget {
  final String description;
  final int amount;
  final DateTime saleDate;
  final Customer customer;

  SaleItem({this.description, this.amount, this.saleDate, this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(customer.name),
        subtitle: Text(description),
        trailing: Column(
          children: <Widget>[
            Text('INR $amount'),
            Text(DateFormat("d MMMM, y").format(saleDate)),
          ],
        ),
      ),
    );
  }
}
