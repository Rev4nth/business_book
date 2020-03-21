import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:business_book/models.dart';
import 'package:business_book/api/client.dart';

class SaleDetailWidget extends StatefulWidget {
  String _saleId;

  SaleDetailWidget(this._saleId);

  @override
  _SaleDetailState createState() => _SaleDetailState(this._saleId);
}

class _SaleDetailState extends State<SaleDetailWidget> {
  String _saleId;
  Sale _sale;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _descriptionTextController = TextEditingController();
  TextEditingController _amountTextController = TextEditingController();

  _SaleDetailState(this._saleId);

  TextFormField _createDescriptionWidget() {
    return new TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the name.';
        }
      },
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Name',
          labelText: 'Enter the name'),
      onSaved: (String value) {
        this._sale.description = value;
      },
      controller: _descriptionTextController,
      autofocus: true,
    );
  }

  TextFormField _createAmountWidget() {
    return new TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the amount.';
        }
        int amount = int.parse(value);
        if (amount == null) {
          return 'Please enter the amount as a number.';
        }
      },
      maxLength: 6,
      maxLengthEnforced: true,
      keyboardType: TextInputType.phone,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Amount',
          labelText: 'Enter the Amount'),
      onSaved: (String value) {
        this._sale.amount = int.parse(value);
      },
      controller: _amountTextController,
    );
  }

  _loadSale(BuildContext context) {
    try {
      ApiClient().fetchSale(_saleId).then((sale) {
        setState(() {
          _sale = sale;
          _descriptionTextController.text = sale.description;
          _amountTextController.text = sale.amount.toString();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _saveSale(BuildContext context) {
    try {
      ApiClient().saveSale(_sale).then((sale) {
        Navigator.pop(context, true);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_saleId == null) {
      _sale = Sale.empty();
    } else {
      _loadSale(context);
    }

    List<Widget> formWidgetList = [
      _createDescriptionWidget(),
      _createAmountWidget(),
      RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _saveSale(context);
          }
        },
        child: new Text('Save'),
      )
    ];
    Form form = Form(key: _formKey, child: ListView(children: formWidgetList));

    return new Scaffold(
        appBar: new AppBar(
          title: new Row(children: [
            Text("Back"),
            Spacer(),
            Text(_saleId == null ? "Create Sale" : "Edit Sale")
          ]),
        ),
        body: new Padding(padding: EdgeInsets.all(20.0), child: form));
  }
}
