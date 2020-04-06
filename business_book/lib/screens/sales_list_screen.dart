import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/sale_item.dart';
import '../providers/sales.dart';

class SalesListScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Sales>(context).fetchAndSetSales().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final sales = Provider.of<Sales>(context);
    return Container(
      child: ListView.builder(
          itemCount: sales.items.length,
          itemBuilder: (context, index) {
            return SaleItem(
              description: sales.items[index].description,
              amount: sales.items[index].amount,
              saleDate: sales.items[index].saleDate,
              customer: sales.items[index].customer,
            );
          }),
    );
  }
}
