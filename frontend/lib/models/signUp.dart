class SignUpmodel {
  SignUpmodel({
    required this.id,
    required this.userName,
    required this.password,
    required this.name,
    required this.age,
    required this.role,
    required this.battingStyles,
    required this.blowingStyles,
    required this.isExternal,
    required this.matches,
    required this.runs,
    required this.wickets,
    required this.displayImage

  });
  late final int id;
  late final String userName;
  late final String password;
  late final String name;
  late final int age;
  late final String role;
  late final String battingStyles;
  late final String blowingStyles;
  late final bool isExternal;
  late final int runs;
  late final int wickets;
  late final int matches;
  late final String displayImage;

  SignUpmodel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userName = json['userName'];
    password = json['password'];
    name = json['name'];
    age = json['age'];
    role = json['role'];
    battingStyles = json['battingStyles'];
    blowingStyles = json['blowingStyles'];
    isExternal = json['isExternal'];
    runs = json['runs'];
    wickets = json['wickets'];
    matches = json['matches'];
    displayImage = json['displayImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userName'] = userName;
    _data['password'] = password;
    _data['name'] = name;
    _data['age'] = age;
    _data['role'] = role;
    _data['battingStyles'] = battingStyles;
    _data['blowingStyles'] = blowingStyles;
    _data['isExternal'] = isExternal;
    _data['runs'] = runs;
    _data['wickets'] = wickets;
    _data['matches'] = matches;
    _data['displayImage'] = displayImage;
    return _data;
  }
}