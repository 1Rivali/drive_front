class AuthModel {
  String? token;
  int? id;
  String? name;

  AuthModel({this.token, this.id, this.name});

  AuthModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
