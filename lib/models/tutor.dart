class Tutor {
  String? id;
  String? name;
  String? email;
  String? phoneNo;
  String? address;
  String? pass;
  String? datereg;

  Tutor({this.id, this.name, this.email, this.phoneNo, this.address, this.pass, this.datereg});

  Tutor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNo = json['phoneNo'];
    address = json['address'];
    pass = json['pass'];
    datereg = json['datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneNo'] = phoneNo;
    data['address'] = address;
    data['pass'] = pass;
    data['datereg'] = datereg;
    return data;
  }
}