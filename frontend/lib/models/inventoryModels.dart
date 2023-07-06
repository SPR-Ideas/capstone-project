class Inventorymodel {
  Inventorymodel({
    required this.user,
    required this.teams,
    required this.matches,
  });
  late  User user;
  late  List<Teams> teams;
  late  List<dynamic> matches;

  Inventorymodel.fromJson(Map<String, dynamic> json){
    user = User.fromJson(json['user']);
    teams = List.from(json['teams']).map((e)=>Teams.fromJson(e)).toList();
    matches = List.castFrom<dynamic, dynamic>(json['matches']);
  }

  Map<String, dynamic> toJson() {
    var _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    _data['teams'] = teams.map((e)=>e.toJson()).toList();
    _data['matches'] = matches;
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.userName,
    required this.name,
    required this.age,
    required this.role,
    required this.battingStyles,
    required this.blowingStyles,
    required this.password,
    required this.isExternal,
    required this.runs,
    required this.wickets,
    required this.matches,
    required this.displayImage,
  });
  late  int id;
  late  String userName;
  late  String name;
  late  int age;
  late  String role;
  late  String battingStyles;
  late  String blowingStyles;
  late  String password;
  late  bool isExternal;
  late  int runs;
  late  int wickets;
  late  int matches;
  late  String displayImage;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userName = json['userName'];
    name = json['name'];
    age = json['age'];
    role = json['role'];
    battingStyles = json['battingStyles'];
    blowingStyles = json['blowingStyles'];
    password = json['password'];
    isExternal = json['isExternal'];
    runs = json['runs'];
    wickets = json['wickets'];
    matches = json['matches'];
    displayImage = json['displayImage'];
  }

  Map<String, dynamic> toJson() {
     var _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userName'] = userName;
    _data['name'] = name;
    _data['age'] = age;
    _data['role'] = role;
    _data['battingStyles'] = battingStyles;
    _data['blowingStyles'] = blowingStyles;
    _data['password'] = password;
    _data['isExternal'] = isExternal;
    _data['runs'] = runs;
    _data['wickets'] = wickets;
    _data['matches'] = matches;
    _data['displayImage'] = displayImage;
    return _data;
  }
}

class Teams {
  Teams({
    required this.id,
    required this.name,
    required this.members,
    required this.count,
    required this.captainId,
  });
  late  int id;
  late  String name;
  late  List<Members> members;
  late  int count;
  late  int captainId;

  Teams.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    members = List.from(json['members']).map((e)=>Members.fromJson(e)).toList();
    count = json['count'];
    captainId = json['captainId'];
  }

  Map<String, dynamic> toJson() {
    var  _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['members'] = members.map((e)=>e.toJson()).toList();
    _data['count'] = count;
    _data['captainId'] = captainId;
    return _data;
  }
}

class Members {
  Members({
    required this.id,
    required this.user,
    required this.isCaptain,
    required this.isPlaying,
  });
  late  int id;
  late  User user;
  late  bool isCaptain;
  late  bool isPlaying;

  Members.fromJson(Map<String, dynamic> json){
    id = json['id'];
    user = User.fromJson(json['user']);
    isCaptain = json['isCaptain'];
    isPlaying = json['isPlaying'];
  }

  Map<String, dynamic> toJson() {
    var _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user'] = user.toJson();
    _data['isCaptain'] = isCaptain;
    _data['isPlaying'] = isPlaying;
    return _data;
  }
}