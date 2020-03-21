import 'package:flutter/material.dart';
import 'package:business_book/views/sale_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Sales';

    return MaterialApp(
      title: appTitle,
      home: SaleListView(),
    );
  }
}
