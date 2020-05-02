import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';
import '../models/sale.dart';

class SaleDetailScreen extends StatefulWidget {
  static const routeName = '/sale-detail';
  @override
  _SaleDetailScreenState createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends State<SaleDetailScreen> {
  Sale sale;
  bool isLoading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final saleId = ModalRoute.of(context).settings.arguments as int;
    if (sale == null) {
      sale = await ApiService.getSaleDetails(saleId);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteSale(int saleId) async {
    final response = await ApiService.deleteSale(saleId);
    if (response['isDeleted']) {
      Navigator.pop(context, true);
    }
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

  void deleteDialog(BuildContext context, int saleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "Do you want to delete the sale?",
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.pop(
              context,
              'Cancel',
            ),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              deleteSale(saleId);
              Navigator.pop(context, 'OK');
            },
          ),
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Builder(
                builder: (context) => Container(
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
                            value: sale.customer.name,
                          ),
                          buildSaleDetailsItem(
                            label: "Amount",
                            value: 'Rs. ${sale.amount.toString()}',
                            valueColor: Colors.green,
                          ),
                          buildSaleDetailsItem(
                            label: "Description",
                            value: sale.description,
                          ),
                          buildSaleDetailsItem(
                            label: "Sale happened on",
                            value:
                                DateFormat("d MMMM, y").format(sale.saleDate),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Image",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                sale.imageUrl != null
                                    ? Image.network(sale.imageUrl)
                                    : Text(
                                        "No image selected",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                SizedBox(
                                  height: 6,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                          Center(
                            child: RaisedButton(
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("Delete Sale"),
                              onPressed: () {
                                deleteDialog(context, sale.id);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
