class Sale {
  int id;
  String description;
  int amount;
  DateTime date;

  Sale({this.id, this.description, this.amount, this.date});

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = json['amount'];
    date = json['date'];
  }
  Sale.empty() {
    id = null;
    description = '';
    amount = null;
    date = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['date'] = this.date;
    return data;
  }
}
