import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/customer.dart';
import '../screens/expense_detail_screen.dart';

class ExpenseItem extends StatelessWidget {
  final int id;
  final String description;
  final double amount;
  final DateTime expenseDate;
  final Customer customer;

  ExpenseItem({
    this.id,
    this.description,
    this.amount,
    this.expenseDate,
    this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ExpenseDetailScreen.routeName,
          arguments: id,
        );
      },
      child: Card(
        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    customer.name,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Rs. $amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    DateFormat("d MMMM, y").format(expenseDate),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
