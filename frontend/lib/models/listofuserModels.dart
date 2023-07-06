class ListOfUsers {
  ListOfUsers({
    this.users,
  });
  late final List<Users>? users;
  late int length;
  ListOfUsers.fromJson(Map<String, dynamic> json){
    users = List.from(json['users']).map((e)=>Users.fromJson(e)).toList();
    length =users!.length;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['users'] = users!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Users {
  Users({
    required this.Id,
    required this.UserName,
    required this.Name,
    required this.Age,
    required this.Role,
    required this.BattingStyles,
    required this.BlowingStyles,
    required this.Password,
    required this.IsExternal,
    required this.Runs,
    required this.Wickets,
    required this.Matches,
    required this.DisplayImage,
  });
  late final int Id;
  late final String UserName;
  late final String Name;
  late final int Age;
  late final String Role;
  late final String BattingStyles;
  late final String BlowingStyles;
  late final String Password;
  late final bool IsExternal;
  late final int Runs;
  late final int Wickets;
  late final int Matches;
  late final String DisplayImage;

  Users.fromJson(Map<String, dynamic> json){
    Id = json['id'];
    UserName = json['userName'];
    Name = json['name'];
    Age = json['age'];
    Role = json['role'];
    BattingStyles = json['battingStyles'];
    BlowingStyles = json['blowingStyles'];
    Password = json['password'];
    IsExternal = json['isExternal'];
    Runs = json['runs'];
    Wickets = json['wickets'];
    Matches = json['matches'];
    DisplayImage = json['displayImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = Id;
    _data['userName'] = UserName;
    _data['name'] = Name;
    _data['age'] = Age;
    _data['role'] = Role;
    _data['battingStyles'] = BattingStyles;
    _data['blowingStyles'] = BlowingStyles;
    _data['password'] = Password;
    _data['isExternal'] = IsExternal;
    _data['runs'] = Runs;
    _data['wickets'] = Wickets;
    _data['matches'] = Matches;
    _data['displayImage'] = DisplayImage;
    return _data;
  }
}