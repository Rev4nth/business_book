import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/sale_detail_screen.dart';
import '../models/customer.dart';

class SaleItem extends StatelessWidget {
  final int id;
  final String description;
  final double amount;
  final DateTime saleDate;
  final Customer customer;

  SaleItem(
      {this.id, this.description, this.amount, this.saleDate, this.customer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          SaleDetailScreen.routeName,
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
              Flexible(
                child: Column(
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
                    DateFormat("d MMMM, y").format(saleDate),
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
