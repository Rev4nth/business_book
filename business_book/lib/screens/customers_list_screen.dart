import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../widgets/customer_item.dart';
import '../providers/customers.dart';

class CustomersListScreen extends StatefulWidget {
  static const routeName = '/customers';
  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Customers>(context).fetchAndSetCustomers().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<Customers>(context);
    return Container(
      child: ListView.builder(
          itemCount: customers.items.length,
          itemBuilder: (context, index) {
            return CustomerItem(
              name: customers.items[index].name,
              contact: customers.items[index].contact,
            );
          }),
    );
  }
}
