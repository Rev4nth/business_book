import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';
import '../models/sale.dart';
import '../models/customer.dart';
import "../models/user.dart";

class ApiService {
  static const baseUrl =
      'http://business-book-staging.ap-south-1.elasticbeanstalk.com';
  // static const baseUrl = 'http://192.168.1.6:8080';

  static Future<http.Response> postSale(body) async {
    final url = '$baseUrl/api/sales/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    return response;
  }

  static Future getSales() async {
    final url = '$baseUrl/api/sales/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    final parsed = json.decode(response.body);
    final List<Sale> sales =
        parsed.map<Sale>((json) => Sale.fromJson(json)).toList();
    return sales;
  }

  static Future getSaleDetails(int saleId) async {
    final String url = '$baseUrl/api/sales/${saleId.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final expense = Sale.fromJson(json.decode(response.body));
    return expense;
  }

  static Future deleteSale(int saleId) async {
    final String url = '$baseUrl/api/sales/${saleId.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future<http.Response> postExpense(body) async {
    final url = '$baseUrl/api/expenses/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    return response;
  }

  static Future getExpenses() async {
    final url = '$baseUrl/api/expenses/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    final parsed = json.decode(response.body);
    final List<Expense> expenses =
        parsed.map<Expense>((json) => Expense.fromJson(json)).toList();
    return expenses;
  }

  static Future getExpenseDetails(int expenseId) async {
    final String url = '$baseUrl/api/expenses/${expenseId.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final expense = Expense.fromJson(json.decode(response.body));
    return expense;
  }

  static Future deleteExpense(int expenseId) async {
    final String url = '$baseUrl/api/expenses/${expenseId.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future getCustomers() async {
    final url = '$baseUrl/api/customers/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    final parsed = json.decode(response.body);
    final List<Customer> customers =
        parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
    return customers;
  }

  static Future getCustomerDetails(int customerId) async {
    final String url = '$baseUrl/api/customers/${customerId.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final customer = Customer.fromJson(json.decode(response.body));
    return customer;
  }

  static Future<http.Response> postCustomer(body) async {
    final url = '$baseUrl/api/customers/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    return response;
  }

  static Future<http.Response> updateCustomer(customerId, body) async {
    final url = '$baseUrl/api/customers/$customerId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    return response;
  }

  static Future getProfile() async {
    final url = '$baseUrl/api/users/profile/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    final parsed = json.decode(response.body);
    final user = User.fromJson(parsed);
    return user;
  }
}

Future<String> asyncFileUpload(File file) async {
  final url = '${ApiService.baseUrl}/api/images/upload';
  var request = http.MultipartRequest("POST", Uri.parse(url));
  var pic = await http.MultipartFile.fromPath("image", file.path);
  request.files.add(pic);
  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  return responseString;
}
