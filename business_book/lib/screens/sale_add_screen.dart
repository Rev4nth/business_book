import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api.dart';
import '../models/sale.dart';
import "../widgets/customer_input.dart";
import "../widgets/decimal_text_input_formatter.dart";

class SaleAddScreen extends StatefulWidget {
  static const routeName = '/add-sale';
  @override
  _SaleAddScreenState createState() => _SaleAddScreenState();
}

class _SaleAddScreenState extends State<SaleAddScreen> {
  final form = GlobalKey<FormState>();
  Sale sale = Sale();
  File image;

  @override
  void initState() {
    super.initState();
    sale.saleDate = new DateTime.now();
  }

  void onCustomerChange(value) {
    setState(() {
      sale.customerId = value;
    });
  }

  void presentDatePicker() {
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
        sale.saleDate = pickedDate;
      });
    });
  }

  Future getImage() async {
    FocusScope.of(context).unfocus();
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = imageFile;
    });
    var imageUrl = await asyncFileUpload(imageFile);
    setState(() {
      sale.imageUrl = imageUrl;
    });
  }

  dynamic encodeDateToString(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  void saveSale() async {
    var isValid = form.currentState.validate();
    if (!isValid) {
      return;
    }
    form.currentState.save();
    var requestBody =
        json.encode(sale.toJson(), toEncodable: encodeDateToString);
    var response = await ApiService.postSale(requestBody);
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              key: form,
              child: ListView(
                children: <Widget>[
                  CustomerInput(
                    onChange: onCustomerChange,
                    initialValue: sale.customerId,
                  ),
                  Divider(),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    initialValue: sale.description,
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
                    onChanged: (value) {
                      setState(() {
                        sale.description = value;
                      });
                    },
                  ),
                  SizedBox(height: 6),
                  Divider(),
                  SizedBox(height: 6),
                  TextFormField(
                    initialValue:
                        sale.amount == null ? "" : sale.amount.toString(),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
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
                    onChanged: (value) {
                      setState(() {
                        sale.amount = double.parse(value);
                      });
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
                                  sale.saleDate == null
                                      ? 'No Date Chosen!'
                                      : '${DateFormat("d MMMM, y").format(sale.saleDate)}',
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
                                onPressed: presentDatePicker,
                              ),
                            ],
                          ),
                        ]),
                  ),
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
                      children: <Widget>[
                        Center(
                          child: image == null
                              ? Text('No image selected.')
                              : Image.file(image),
                        ),
                        RaisedButton(
                          onPressed: getImage,
                          child: new Text('Add Image'),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 6),
                  RaisedButton(
                    onPressed: saveSale,
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
