import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add Sale';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: SaleForm(),
      ),
    );
  }
}

// Create a Form widget.
class SaleForm extends StatefulWidget {
  @override
  SaleFormState createState() {
    return SaleFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class SaleFormState extends State<SaleForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _saleDescriptionController = TextEditingController();
  final _saleAmountController = TextEditingController();

  int saleAmount;
  postSale(String saleDescription, String saleAmount) async {
    final uri = 'http://192.168.1.5:3000/api/sales/';
    var requestBody = Map<String, dynamic>();
    requestBody['description'] = saleDescription;
    requestBody['amount'] = saleAmount;

    http.Response response = await http.post(
      uri,
      body: requestBody,
    );

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Card(
            margin: const EdgeInsets.all(20.0),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    child: TextFormField(
                      maxLines: 4,
                      controller: _saleDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Sale Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter sale description!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    child: TextFormField(
                      controller: _saleAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Sale Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter sale amount!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          this.postSale(_saleDescriptionController.text,
                              _saleAmountController.text);
                          // If the form is valid, display a Snackbar.
                        }
                      },
                      child: Text('Add Sale'),
                    ),
                  ),
                ],
              ),
            )));
  }
}
