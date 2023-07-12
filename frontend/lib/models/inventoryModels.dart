class Inventorymodel {
  Inventorymodel({
    this.user,
    required this.teams,
    required this.matches,
  });
  late final User? user;
  late final List<Teams> teams;
  late final List<Matches> matches;

  Inventorymodel.fromJson(Map<String, dynamic> json){
    user = User.fromJson(json['user']);
    teams = List.from(json['teams']).map((e)=>Teams.fromJson(e)).toList();
    matches = List.from(json['matches']).map((e)=>Matches.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user!.toJson();
    _data['teams'] = teams.map((e)=>e.toJson()).toList();
    _data['matches'] = matches.map((e)=>e.toJson()).toList();
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
  late int matches;
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
    final _data = <String, dynamic>{};
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
  late final int id;
  late final String name;
  late final List<Members> members;
  late final int count;
  late final int captainId;

  Teams.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    members = List.from(json['members']).map((e)=>Members.fromJson(e)).toList();
    count = json['count'];
    captainId = json['captainId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
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
  late final int id;
  late final User user;
  late final bool isCaptain;
  late final bool isPlaying;

  Members.fromJson(Map<String, dynamic> json){
    id = json['id'];
    user = User.fromJson(json['user']);
    isCaptain = json['isCaptain'];
    isPlaying = json['isPlaying'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user'] = user.toJson();
    _data['isCaptain'] = isCaptain;
    _data['isPlaying'] = isPlaying;
    return _data;
  }
}

class Matches {
  Matches({
    required this.id,
    required this.hostTeamId,
    required this.visitorTeamId,
    required this.overs,
    required this.wickets,
    required this.victoryTeamId,
    required this.startDate,
    required this.isCompleted,
    required this.scoreCard,
    required this.isHostInnings,
    required this.result,
  });
  late final int id;
  late final int hostTeamId;
  late final int visitorTeamId;
  late final int overs;
  late final int wickets;
  late final int victoryTeamId;
  late final int startDate;
  late final bool isCompleted;
  late final ScoreCard scoreCard;
  late final bool isHostInnings;
  late final String result;

  Matches.fromJson(Map<String, dynamic> json){
    id = json['id'];
    hostTeamId = json['hostTeamId'];
    visitorTeamId = json['visitorTeamId'];
    overs = json['overs'];
    wickets = json['wickets'];
    victoryTeamId = json['victoryTeamId'];
    startDate = json['startDate'];
    isCompleted = json['isCompleted'];
    scoreCard = ScoreCard.fromJson(json['scoreCard']);
    isHostInnings = json['isHostInnings'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['hostTeamId'] = hostTeamId;
    _data['visitorTeamId'] = visitorTeamId;
    _data['overs'] = overs;
    _data['wickets'] = wickets;
    _data['victoryTeamId'] = victoryTeamId;
    _data['startDate'] = startDate;
    _data['isCompleted'] = isCompleted;
    _data['scoreCard'] = scoreCard.toJson();
    _data['isHostInnings'] = isHostInnings;
    _data['result'] = result;
    return _data;
  }
}

class ScoreCard {
  ScoreCard({
    this.id=0,
    this.overs=0,
    this.hostTeamId=0,
    this.visitorTeamId=0,
    this.hostTeamName="",
    this.visitorTeamName="",
    this.hostTeamInnings,
    this.visitorTeamInnings,
    this.isHostInnings=false,
  });
  late final int id;
  late final int overs;
  late final int hostTeamId;
  late final int visitorTeamId;
  late final String hostTeamName;
  late final String visitorTeamName;
  late final HostTeamInnings? hostTeamInnings;
  late final HostTeamInnings? visitorTeamInnings;
  late final bool isHostInnings;

  ScoreCard.fromJson(Map<String, dynamic> json){
    id = json['id'];
    overs = json['overs'];
    hostTeamId = json['hostTeamId'];
    visitorTeamId = json['visitorTeamId'];
    hostTeamName = json['hostTeamName'];
    visitorTeamName = json['visitorTeamName'];
    hostTeamInnings = HostTeamInnings.fromJson(json['hostTeamInnings']);
    visitorTeamInnings = HostTeamInnings.fromJson(json['visitorTeamInnings']);
    isHostInnings = json['isHostInnings'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['overs'] = overs;
    _data['hostTeamId'] = hostTeamId;
    _data['visitorTeamId'] = visitorTeamId;
    _data['hostTeamName'] = hostTeamName;
    _data['visitorTeamName'] = visitorTeamName;
    _data['hostTeamInnings'] = hostTeamInnings!.toJson();
    _data['visitorTeamInnings'] = visitorTeamInnings;
    _data['isHostInnings'] = isHostInnings;
    return _data;
  }
}

class HostTeamInnings {
  HostTeamInnings({
    this.id =0,
    this.wickets=0,
    this.balls=0,
    this.score=0,
    this.totalOver=0,
    this.totalWickets=0,
    this.isInningsCompleted=false,
    this.battingStats,
    this.blowingStats ,
  });
  late final int id;
  late final int wickets;
  late final int balls;
  late final int score;
  late final int totalOver;
  late final int totalWickets;
  late final bool isInningsCompleted;
  late final List<BattingStats>? battingStats;
  late final List<BlowingStats>? blowingStats;

  HostTeamInnings.fromJson(Map<String, dynamic> json){
    id = json['id'];
    wickets = json['wickets'];
    balls = json['balls'];
    score = json['score'];
    totalOver = json['totalOver'];
    totalWickets = json['totalWickets'];
    isInningsCompleted = json['isInningsCompleted'];
    battingStats = List.from(json['battingStats']).map((e)=>BattingStats.fromJson(e)).toList();
    blowingStats = List.from(json['blowingStats']).map((e)=>BlowingStats.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['wickets'] = wickets;
    _data['balls'] = balls;
    _data['score'] = score;
    _data['totalOver'] = totalOver;
    _data['totalWickets'] = totalWickets;
    _data['isInningsCompleted'] = isInningsCompleted;
    _data['battingStats'] = battingStats!.map((e)=>e.toJson()).toList();
    _data['blowingStats'] = blowingStats!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class BattingStats {
  BattingStats({
    this.id=0,
    this.displayName="",
    this.userId=0,
    this.runs=0,
    this.balls=0,
    this.sixer=0,
    this.four=0,
    this.blowedBy="",
    this.caughtBy="",
  });
  late final int id;
  late final String displayName;
  late final int userId;
  late final int runs;
  late final int balls;
  late final int sixer;
  late final int four;
  late final String blowedBy;
  late final String caughtBy;
  late final int isCurrent;

  BattingStats.fromJson(Map<String, dynamic> json){
    id = json['id'];
    displayName = json['displayName'];
    userId = json['userId'];
    runs = json['runs'];
    balls = json['balls'];
    sixer = json['sixer'];
    four = json['four'];
    blowedBy = json['blowedBy'];
    caughtBy = json['caughtBy'];
    isCurrent = json['isCurrent']??0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['displayName'] = displayName;
    _data['userId'] = userId;
    _data['runs'] = runs;
    _data['balls'] = balls;
    _data['sixer'] = sixer;
    _data['four'] = four;
    _data['blowedBy'] = blowedBy;
    _data['caughtBy'] = caughtBy;
    _data['isCurrent'] = isCurrent;

    return _data;
  }

    @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BattingStats &&
        other.id == id &&
        other.displayName == displayName &&
        other.userId == userId;
    // Add additional fields for comparison if needed
  }

  @override
  int get hashCode {
    return id.hashCode ^ displayName.hashCode ^ userId.hashCode;
    // Combine additional fields for hashing if needed
  }
}

class BlowingStats {
  BlowingStats({
    this.id =0,
    this.displayNames="",
    this.userId=0,
    this.runs=0,
    this.wickets=0,
    this.ballsBlowed=0,
    this.isCurrent=0
  });
  late final int id;
  late final String displayNames;
  late final int userId;
  late final int runs;
  late final int wickets;
  late final int ballsBlowed;
  late final int isCurrent;

  BlowingStats.fromJson(Map<String, dynamic> json){
    id = json['id'];
    displayNames = json['displayNames'];
    userId = json['userId'];
    runs = json['runs'];
    wickets = json['wickets'];
    ballsBlowed = json['ballsBlowed'];
    isCurrent = json['isCurrent']??0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['displayNames'] = displayNames;
    _data['userId'] = userId;
    _data['runs'] = runs;
    _data['wickets'] = wickets;
    _data['ballsBlowed'] = ballsBlowed;
    _data['isCurrent'] = isCurrent;
    return _data;
  }
}