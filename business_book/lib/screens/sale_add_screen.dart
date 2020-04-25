import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api.dart';
import '../models/customer.dart';
import '../models/sale.dart';

class SaleAddScreen extends StatefulWidget {
  static const routeName = '/edit-sale';
  @override
  _SaleAddScreenState createState() => _SaleAddScreenState();
}

class _SaleAddScreenState extends State<SaleAddScreen> {
  final _form = GlobalKey<FormState>();
  final _baseUrl = ApiService.baseUrl;
  Sale _sale = Sale();

  List<Customer> _customersList = [];
  bool _loading = true;
  File _image;

  void getCustomers() async {
    final url = '$_baseUrl/api/customers/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.get(url, headers: {
      'Authorization': 'Bearer $token',
    }).then((response) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Customer> customersList =
          parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
      setState(() {
        _customersList = customersList;
      });
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _sale.saleDate = pickedDate;
      });
    });
  }

  dynamic encodeDateToString(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  void _saveSale() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final url = '$_baseUrl/api/sales/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(_sale.toJson(), toEncodable: encodeDateToString),
    );
    Navigator.of(context).pop();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _asyncFileUpload("bho", image);
    setState(() {
      _image = image;
    });
  }

  _asyncFileUpload(String text, File file) async {
    final url = '${ApiService.baseUrl}/api/images/upload';
    var request = http.MultipartRequest("POST", Uri.parse(url));
    //add text fields
    request.fields["text_field"] = text;
    var pic = await http.MultipartFile.fromPath("image", file.path);
    request.files.add(pic);
    var response = await request.send();
    print(response);

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    setState(() {
      _sale.imageUrl = responseString;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      _loading = false;
      getCustomers();
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Add Sale"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Customer",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        DropdownButton<int>(
                          value: _sale.customerId,
                          hint: Text('Select a customer'),
                          items: _customersList.map((Customer customer) {
                            return DropdownMenuItem(
                                value: customer.id, child: Text(customer.name));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _sale.customerId = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter sale description.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _sale.description = value;
                    },
                  ),
                  SizedBox(height: 6),
                  Divider(),
                  SizedBox(height: 6),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an amount.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter a number greater than zero.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _sale.amount = int.parse(value);
                    },
                  ),
                  SizedBox(height: 6),
                  Divider(),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Sale happened on",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  _sale.saleDate == null
                                      ? 'No Date Chosen!'
                                      : '${DateFormat("d MMMM, y").format(_sale.saleDate)}',
                                ),
                              ),
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                child: Text(
                                  'Choose Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: _presentDatePicker,
                              ),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(height: 6),
                  Center(
                    child: _image == null
                        ? Text('No image selected.')
                        : Image.file(_image),
                  ),
                  RaisedButton(
                    onPressed: getImage,
                    child: new Text('Add Image'),
                  ),
                  Divider(),
                  SizedBox(height: 6),
                  RaisedButton(
                    onPressed: _saveSale,
                    child: new Text('Save'),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
