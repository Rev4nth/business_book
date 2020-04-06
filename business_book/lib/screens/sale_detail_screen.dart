import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';

class SaleDetailScreen extends StatefulWidget {
  static const routeName = '/sale-detail';
  @override
  _SaleDetailScreenState createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends State<SaleDetailScreen> {
  Map<String, dynamic> saleDetails;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    final saleId = ModalRoute.of(context).settings.arguments as int;
    if (saleDetails == null) {
      fetchSaleDetails(saleId);
    }
    super.didChangeDependencies();
  }

  Future<void> fetchSaleDetails(int saleId) async {
    final String url = '${ApiService.baseUrl}/api/sales/${saleId.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    setState(() {
      saleDetails = json.decode(response.body);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sale Details'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Text(saleDetails['description']),
                  Text(saleDetails['amount'].toString()),
                  Text(saleDetails['saleDate']),
                  Text(saleDetails['Customer']['name']),
                ],
              ));
  }
}
