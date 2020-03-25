class Sale {
  int id;
  String description;
  int amount;

  Sale({this.id, this.description, this.amount});

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = json['amount'];
  }
  Sale.empty() {
    id = null;
    description = '';
    amount = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['description'] = this.description;
    data['amount'] = this.amount;
    return data;
  }
}
