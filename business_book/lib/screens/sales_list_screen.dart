import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sales.dart';
import '../widgets/sale_item.dart';

class SalesListScreen extends StatefulWidget {
  static const routeName = '/tabs';
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Sales>(context, listen: false).fetchAndSetSales(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Sales>(
                builder: (ctx, sales, child) => ListView.builder(
                  itemCount: sales.items == null ? 0 : sales.items.length,
                  itemBuilder: (context, index) {
                    return SaleItem(
                      id: sales.items[index].id,
                      description: sales.items[index].description,
                      amount: sales.items[index].amount,
                      saleDate: sales.items[index].saleDate,
                      customer: sales.items[index].customer,
                    );
                  },
                ),
              );
            }
          }
        });
  }
}
