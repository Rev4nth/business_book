import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:business_book/models.dart';

class ApiClient {
  final _baseUrl = 'http://192.168.1.6:3000';

  Future<List<Sale>> fetchSales() async {
    final url = '$_baseUrl/api/sales/';
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw new Exception('error getting sales');
    }
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    var list = parsed.map<Sale>((json) => Sale.fromJson(json)).toList();
    return list;
  }

  Future<Sale> fetchSale(String id) async {
    var url = '$_baseUrl/api/sales/$id';
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw new Exception('error getting sales');
    }
    final parsed = json.decode(response.body);
    return Sale.fromJson(parsed);
  }

  Future<dynamic> saveSale(Sale sale) async {
    print(sale.toJson());
    print(json.encode(sale));
    bool isUpdate = (sale.id != null);
    final uri = _baseUrl + (isUpdate ? '/api/sales/${sale.id}' : '/api/sales/');
    // profile image does not seem to update
    final response = isUpdate
        ? await http.put(uri,
            headers: {"Content-Type": "application/json"},
            body: json.encode(sale))
        : await http.post(uri,
            headers: {"Content-Type": "application/json"},
            body: json.encode(sale));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }
}
