import 'package:flutter/material.dart';

import '../widgets/customer_item.dart';
import '../services/api.dart';

class CustomersListScreen extends StatefulWidget {
  static const routeName = '/customers';
  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getCustomers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, index) {
              return CustomerItem(
                id: snapshot.data[index].id,
                name: snapshot.data[index].name,
                contact: snapshot.data[index].contact,
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
