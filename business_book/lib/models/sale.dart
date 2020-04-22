import './customer.dart';

class Sale {
  int id;
  String description;
  int amount;
  DateTime saleDate;
  int customerId;
  String imageUrl;
  Customer customer;

  Sale(
      {this.id,
      this.description,
      this.amount,
      this.saleDate,
      this.imageUrl,
      this.customer,
      this.customerId});

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = json['amount'];
    imageUrl = json['imageUrl'];
    saleDate =
        json['saleDate'] != null ? DateTime.parse(json['saleDate']) : null;
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
    data['saleDate'] = this.saleDate;
    data['customerId'] = this.customerId;
    if (this.customer != null) {
      data['Customer'] = this.customer.toJson();
    }
    return data;
  }
}
