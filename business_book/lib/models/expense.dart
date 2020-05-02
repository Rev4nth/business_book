import './customer.dart';

class Expense {
  int id;
  String description;
  double amount;
  DateTime expenseDate;
  int customerId;
  String imageUrl;
  Customer customer;

  Expense(
      {this.id,
      this.description,
      this.amount,
      this.expenseDate,
      this.imageUrl,
      this.customer,
      this.customerId});

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = double.parse(json['amount'].toString());
    imageUrl = json['imageUrl'];
    expenseDate = json['expenseDate'] != null
        ? DateTime.parse(json['expenseDate'])
        : null;
    customerId = json['customerId'];
    customer = json['Customer'] != null
        ? new Customer.fromJson(json['Customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['imageUrl'] = this.imageUrl;
    data['expenseDate'] = this.expenseDate;
    data['customerId'] = this.customerId;
    if (this.customer != null) {
      data['Customer'] = this.customer.toJson();
    }
    return data;
  }
}
