import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/sale_item.dart';
import '../models/sale.dart';

class SalesListScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final _baseUrl = 'http://192.168.1.7:3000';
  List<Sale> _salesList = [];
  bool _loading = true;

  void getSales() {
    final url = '$_baseUrl/api/sales/';
    http.get(url).then((response) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Sale> salesList =
          parsed.map<Sale>((json) => Sale.fromJson(json)).toList();
      setState(() {
        _salesList = salesList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      _loading = false;
      getSales();
    }
    return Container(
      child: ListView.builder(
          itemCount: _salesList.length,
          itemBuilder: (context, index) {
            return SaleItem(
              description: _salesList[index].description,
              amount: _salesList[index].amount,
            );
          }),
    );
  }
}
