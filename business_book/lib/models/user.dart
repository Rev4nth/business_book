class User {
  int id;
  String displayName;
  String email;
  Account account;

  User({this.id, this.displayName, this.email, this.account});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    email = json['email'];
    account =
        json['Account'] != null ? new Account.fromJson(json['Account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    if (this.account != null) {
      data['Account'] = this.account.toJson();
    }
    return data;
  }
}

class Account {
  int id;
  String name;

  Account({this.id, this.name});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
