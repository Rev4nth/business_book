import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import "../widgets/customer_input.dart";
import "../widgets/decimal_text_input_formatter.dart";
import '../models/expense.dart';
import "../services/api.dart";

class ExpenseAddScreen extends StatefulWidget {
  static const routeName = "/add-expense";
  @override
  _ExpenseAddScreenState createState() => _ExpenseAddScreenState();
}

class _ExpenseAddScreenState extends State<ExpenseAddScreen> {
  final formState = GlobalKey<FormState>();
  Expense expense = Expense();
  File image;

  @override
  void initState() {
    super.initState();
    expense.expenseDate = new DateTime.now();
  }

  void onCustomerChange(value) {
    setState(() {
      expense.customerId = value;
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
        expense.expenseDate = pickedDate;
      });
    });
  }

  Future getImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    var imageUrl = await asyncFileUpload(imageFile);
    setState(() {
      image = imageFile;
      expense.imageUrl = imageUrl;
    });
  }

  dynamic encodeDateToString(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  void saveExpense() async {
    var isValid = formState.currentState.validate();
    if (!isValid) {
      return;
    }
    formState.currentState.save();
    var requestBody =
        json.encode(expense.toJson(), toEncodable: encodeDateToString);
    var response = await ApiService.postExpense(requestBody);
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formState,
              child: ListView(
                children: <Widget>[
                  CustomerInput(
                    onChange: onCustomerChange,
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
                      setState(() {
                        expense.description = value;
                      });
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
                    onSaved: (value) {
                      setState(() {
                        expense.amount = double.parse(value);
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
                                  expense.expenseDate == null
                                      ? 'No Date Chosen!'
                                      : '${DateFormat("d MMMM, y").format(expense.expenseDate)}',
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
                  SizedBox(height: 6),
                  RaisedButton(
                    onPressed: () {
                      saveExpense();
                    },
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
