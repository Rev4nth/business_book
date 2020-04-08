import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';
import '../models/sale.dart';

class Sales with ChangeNotifier {
  List<Sale> _sales = [];

  List<Sale> get items {
    return [..._sales];
  }

  Future<void> fetchAndSetSales() async {
    final url = '${ApiService.baseUrl}/api/sales/';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final parsed = json.decode(response.body);
      final List<Sale> loadedSales =
          parsed.map<Sale>((json) => Sale.fromJson(json)).toList();
      _sales = loadedSales;
      print(loadedSales[0].saleDate);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
