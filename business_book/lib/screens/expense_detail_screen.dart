import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';
import '../models/expense.dart';

class ExpenseDetailScreen extends StatefulWidget {
  static const routeName = '/expense-detail';
  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  Expense expense;
  bool isLoading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final expenseId = ModalRoute.of(context).settings.arguments as int;
    if (expense == null) {
      expense = await ApiService.getExpenseDetails(expenseId);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    final response = await ApiService.deleteExpense(expenseId);
    if (response['isDeleted']) {
      Navigator.pop(context, true);
    }
  }

  Widget buildExpenseDetailsItem({
    String label,
    String value,
    Color valueColor = Colors.black,
  }) {
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
          "Do you want to delete the Expense?",
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
              deleteExpense(saleId);
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
        title: Text('Expense Details'),
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
                    child: ListView(
                      children: <Widget>[
                        buildExpenseDetailsItem(
                          label: "Customer Name",
                          value: expense.customer.name,
                        ),
                        buildExpenseDetailsItem(
                          label: "Amount",
                          value: 'Rs. ${expense.amount.toString()}',
                          valueColor: Colors.red,
                        ),
                        buildExpenseDetailsItem(
                          label: "Description",
                          value: expense.description,
                        ),
                        buildExpenseDetailsItem(
                          label: "Expense happened on",
                          value: DateFormat("d MMMM, y")
                              .format(expense.expenseDate),
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
                              expense.imageUrl != null
                                  ? Image.network(expense.imageUrl)
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
                            child: Text("Delete Expense"),
                            onPressed: () {
                              deleteDialog(context, expense.id);
                            },
                          ),
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
