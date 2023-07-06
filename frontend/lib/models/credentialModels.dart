class CredentialModel {
  CredentialModel({
    required this.username,
    required this.password,
    required this.isExternal,
  });
  late final String username;
  late final String password;
  late final bool isExternal;

  CredentialModel.fromJson(Map<String, dynamic> json){
    username = json['username'];
    password = json['password'];
    isExternal = json['isExternal'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['password'] = password;
    _data['isExternal'] = isExternal;
    return _data;
  }
}