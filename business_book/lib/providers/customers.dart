import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';

class Customer {
  int id;
  String name;
  String contact;
  String createdAt;
  String updatedAt;
  int userId;

  Customer(
      {this.id,
      this.name,
      this.contact,
      this.createdAt,
      this.updatedAt,
      this.userId});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    return data;
  }
}

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
