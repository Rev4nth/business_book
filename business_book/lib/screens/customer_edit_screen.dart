import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/api.dart';
import '../models/customer.dart';

class CustomerEditScreen extends StatefulWidget {
  static String routeName = '/edit-customer';
  final int id;
  final String name;
  final String contact;

  CustomerEditScreen({this.id, this.name, this.contact});

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final formState = GlobalKey<FormState>();
  Customer customer = Customer();

  void updateCustomer(BuildContext context) async {
    var isValid = formState.currentState.validate();
    if (!isValid) {
      return;
    }
    formState.currentState.save();
    customer.id = widget.id;
    var requestBody = json.encode(customer);
    var response = await ApiService.updateCustomer(customer.id, requestBody);
    if (response.statusCode == 400) {
      final parsedResponse = json.decode(response.body);
      final snackBar = SnackBar(
        content: Text(parsedResponse['error']),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snackBar);
    } else if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
      ),
      body: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formState,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      initialValue: widget.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a name.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          customer.name = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      initialValue: widget.contact,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a number.';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          customer.contact = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    RaisedButton(
                      onPressed: () {
                        updateCustomer(context);
                      },
                      child: new Text('Update'),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
