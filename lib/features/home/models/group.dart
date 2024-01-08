class GroupModel {
  int? id;
  int? idGroup;
  int? idUser;
  int? counterFile;
  String? createdAt;
  String? updatedAt;
  String? numberUser;
  String? userAdmin;
  String? emailAdmin;
  int? idAdmin;
  String? nameGroup;

  GroupModel(
      {this.id,
      this.idGroup,
      this.idUser,
      this.counterFile,
      this.createdAt,
      this.updatedAt,
      this.numberUser,
      this.userAdmin,
      this.emailAdmin,
      this.idAdmin,
      this.nameGroup});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idGroup = json['id_group'];
    idUser = json['id_user'];
    counterFile = json['counter_file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    numberUser = json['number_user'];
    userAdmin = json['user_admin'];
    emailAdmin = json['email_admin'];
    idAdmin = json['id_admin'];
    nameGroup = json['name_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_group'] = idGroup;
    data['id_user'] = idUser;
    data['counter_file'] = counterFile;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['number_user'] = numberUser;
    data['user_admin'] = userAdmin;
    data['email_admin'] = emailAdmin;
    data['id_admin'] = idAdmin;
    data['name_group'] = nameGroup;
    return data;
  }
}
