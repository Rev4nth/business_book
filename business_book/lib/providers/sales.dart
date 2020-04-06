import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';
import './customers.dart';

class Sale {
  int id;
  String description;
  int amount;
  DateTime saleDate;
  int customerId;
  Customer customer;

  Sale(
      {this.id,
      this.description,
      this.amount,
      this.saleDate,
      this.customer,
      this.customerId});

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = json['amount'];
    saleDate =
        json['saleDate'] != null ? DateTime.parse(json['saleDate']) : null;
    customerId = json['customerId'];
    customer = json['Customer'] != null
        ? new Customer.fromJson(json['Customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['saleDate'] = this.saleDate;
    data['customerId'] = this.customerId;
    if (this.customer != null) {
      data['Customer'] = this.customer.toJson();
    }
    return data;
  }
}

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
