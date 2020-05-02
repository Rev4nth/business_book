import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/expense_item.dart';

class ExpensesListScreen extends StatelessWidget {
  static const route = "/expense-list";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getExpenses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, index) {
              return ExpenseItem(
                id: snapshot.data[index].id,
                description: snapshot.data[index].description,
                amount: snapshot.data[index].amount,
                expenseDate: snapshot.data[index].expenseDate,
                customer: snapshot.data[index].customer,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
