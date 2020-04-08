import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/sale_item.dart';
import '../services/api.dart';
import '../models/sale.dart';

class SalesListScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  var _isLoading = true;
  List salesList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (salesList == null) {
      fetchSales();
    }
  }

  Future<void> fetchSales() async {
    final String url = '${ApiService.baseUrl}/api/sales/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final parsed = json.decode(response.body);
    final List<Sale> loadedSales =
        parsed.map<Sale>((json) => Sale.fromJson(json)).toList();
    setState(() {
      salesList = loadedSales;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final sales = Provider.of<Sales>(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: ListView.builder(
                itemCount: salesList == null ? 0 : salesList.length,
                itemBuilder: (context, index) {
                  return SaleItem(
                    id: salesList[index].id,
                    description: salesList[index].description,
                    amount: salesList[index].amount,
                    saleDate: salesList[index].saleDate,
                    customer: salesList[index].customer,
                  );
                }),
          );
  }
}
