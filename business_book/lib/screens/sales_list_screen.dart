import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/sale_item.dart';
import '../models/sale.dart';
import '../services/api.dart';
import '../storage_util.dart';

class SalesListScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final _baseUrl = ApiService.baseUrl;
  List<Sale> _salesList = [];
  bool _loading = true;

  void getSales() async {
    final url = '$_baseUrl/api/sales/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.get(url, headers: {
      'Authorization': 'Bearer $token',
    }).then((response) {
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
