import 'package:flutter/material.dart';

class SaleItem extends StatelessWidget {
  final String description;
  final int amount;

  SaleItem({this.description, this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(description),
        trailing: Text('INR $amount'),
      ),
    );
  }
}
