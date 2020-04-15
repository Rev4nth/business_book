import 'package:flutter/material.dart';

import '../screens/customer_detail_screen.dart';

class CustomerItem extends StatelessWidget {
  final int id;
  final String name;
  final String contact;

  CustomerItem({this.id, this.name, this.contact});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          CustomerDetailScreen.routeName,
          arguments: id,
        );
      },
      child: Card(
        child: ListTile(
          title: Text(name),
          subtitle: Text(contact),
        ),
      ),
    );
  }
}
