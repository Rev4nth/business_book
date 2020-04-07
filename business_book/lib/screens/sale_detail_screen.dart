import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';
import './tabs_screen.dart';

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

  Future<void> deleteSale(int saleId) async {
    final String url = '${ApiService.baseUrl}/api/sales/${saleId.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(TabsScreen.routeName);
    print(response);
  }

  Widget buildSaleDetailsItem(
      {String label, String value, Color valueColor = Colors.black}) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              color: valueColor,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Divider(),
        ],
      ),
    );
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
            : Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildSaleDetailsItem(
                          label: "Customer Name",
                          value: saleDetails['Customer']['name'],
                        ),
                        buildSaleDetailsItem(
                          label: "Amount",
                          value: 'Rs. ${saleDetails['amount'].toString()}',
                          valueColor: Colors.green,
                        ),
                        buildSaleDetailsItem(
                          label: "Description",
                          value: saleDetails['description'],
                        ),
                        buildSaleDetailsItem(
                          label: "Sale happened on",
                          value: DateFormat("d MMMM, y")
                              .format(DateTime.parse(saleDetails['saleDate'])),
                        ),
                        Center(
                          child: RaisedButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text("Delete Sale"),
                            onPressed: () {
                              deleteSale(saleDetails['id']);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
