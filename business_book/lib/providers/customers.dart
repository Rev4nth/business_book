import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';
import '../models/customer.dart';

class Customers with ChangeNotifier {
  List<Customer> _customers = [];

  List<Customer> get items {
    return [..._customers];
  }

  Future<void> fetchAndSetCustomers() async {
    final url = '${ApiService.baseUrl}/api/customers/';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      final parsed = json.decode(response.body);
      final List<Customer> loadedCustomers =
          parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
      _customers = loadedCustomers;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
