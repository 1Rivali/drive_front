class FileModel {
  int? id;
  int? idOwner;
  String? name;
  String? state;
  String? uploadDate;
  String? updateDate;
  String? createdAt;
  String? updatedAt;
  String? public;
  String? url;
  String? nameFile;
  String? userNameCheckIn;
  bool? isChecked;
  FileModel({
    this.id,
    this.idOwner,
    this.name,
    this.state,
    this.uploadDate,
    this.updateDate,
    this.createdAt,
    this.updatedAt,
    this.public,
    this.url,
    this.nameFile,
    this.userNameCheckIn,
    this.isChecked = false,
  });

  FileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idOwner = json['id_owner'];
    name = json['name'];
    state = json['state'];
    uploadDate = json['upload_date'];
    updateDate = json['update_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    public = json['public'];
    url = json['url'];
    nameFile = json['name_file'];
    userNameCheckIn = json['user_name_check_in'];
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_owner'] = idOwner;
    data['name'] = name;
    data['state'] = state;
    data['upload_date'] = uploadDate;
    data['update_date'] = updateDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['public'] = public;
    data['url'] = url;
    data['name_file'] = nameFile;
    data['user_name_check_in'] = userNameCheckIn;
    return data;
  }
}
