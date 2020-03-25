import 'package:flutter/material.dart';

class CustomerItem extends StatelessWidget {
  final String name;
  final String contact;

  CustomerItem({this.name, this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(contact),
      ),
    );
  }
}
