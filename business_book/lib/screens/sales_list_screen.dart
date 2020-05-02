import 'package:flutter/material.dart';

import '../services/api.dart';
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
      future: ApiService.getSales(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, index) {
              return SaleItem(
                id: snapshot.data[index].id,
                description: snapshot.data[index].description,
                amount: snapshot.data[index].amount,
                saleDate: snapshot.data[index].saleDate,
                customer: snapshot.data[index].customer,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
