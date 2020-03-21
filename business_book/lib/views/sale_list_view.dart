import 'package:flutter/material.dart';
import 'package:business_book/api/client.dart';
import 'package:business_book/models.dart';
import 'package:business_book/views/sale_detail_view.dart';

class SaleListView extends StatefulWidget {
  @override
  _SaleListViewState createState() => _SaleListViewState();
}

class _SaleListViewState extends State<SaleListView> {
  List<Sale> _sales;
  bool _refresh = true;

  _loadSales(BuildContext context) {
    ApiClient().fetchSales().then((sales) {
      setState(() {
        _sales = sales;
      });
    });
  }

  _navigateToSale(BuildContext context, String saleId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SaleDetailWidget(saleId)),
    );
  }

  _refreshEmployees() {
    setState(() {
      _refresh = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_refresh) {
      _refresh = false;
      _loadSales(context);
    }

    ListView builder = ListView.builder(
        itemCount: _sales != null ? _sales.length : 0,
        itemBuilder: (context, index) {
          Sale sale = _sales[index];
          return ListTile(
              title: Text('${sale.description}'),
              subtitle: Text('Amount: ${sale.amount}'));
        });

    return new Scaffold(
        appBar: new AppBar(title: new Text("Sales"), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add Sale',
              onPressed: () {
                _navigateToSale(context, null);
              }),
          IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                _refreshEmployees();
              })
        ]),
        body: new Center(
          child: builder,
        ));
  }
}
