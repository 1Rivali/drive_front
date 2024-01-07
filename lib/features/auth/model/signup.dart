class SignupModel {
  String? email;
  String? userName;
  String? lastName;
  String? firstName;
  String? password;
  String? cPassword;

  SignupModel(
      {this.email,
      this.userName,
      this.lastName,
      this.firstName,
      this.password,
      this.cPassword});

  SignupModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userName = json['user_name'];
    lastName = json['last_name'];
    firstName = json['first_name'];
    password = json['password'];
    cPassword = json['c_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['user_name'] = userName;
    data['last_name'] = lastName;
    data['first_name'] = firstName;
    data['password'] = password;
    data['c_password'] = cPassword;
    return data;
  }
}
