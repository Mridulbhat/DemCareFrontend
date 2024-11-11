class SignupBody {
  String? name;
  String? age;
  String? gender;
  String? email;
  String? contact;

  SignupBody({this.name, this.age, this.gender, this.email, this.contact});

  SignupBody.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    email = json['email'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['contact'] = this.contact;
    return data;
  }
}