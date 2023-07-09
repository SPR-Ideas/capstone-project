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
  late final int id;
  late final String userName;
  late final String name;
  late final int age;
  late final String role;
  late final String battingStyles;
  late final String blowingStyles;
  late final String password;
  late final bool isExternal;
  late final int runs;
  late final int wickets;
  late final int matches;
  late final String displayImage;

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
    required this.id,
    required this.overs,
    required this.hostTeamId,
    required this.visitorTeamId,
    required this.hostTeamName,
    required this.visitorTeamName,
    required this.hostTeamInnings,
    required this.visitorTeamInnings,
    required this.isHostInnings,
  });
  late final int id;
  late final int overs;
  late final int hostTeamId;
  late final int visitorTeamId;
  late final String hostTeamName;
  late final String visitorTeamName;
  late final HostTeamInnings hostTeamInnings;
  late final HostTeamInnings visitorTeamInnings;
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
    _data['hostTeamInnings'] = hostTeamInnings.toJson();
    _data['visitorTeamInnings'] = visitorTeamInnings;
    _data['isHostInnings'] = isHostInnings;
    return _data;
  }
}

class HostTeamInnings {
  HostTeamInnings({
    required this.id,
    required this.wickets,
    required this.balls,
    required this.score,
    required this.totalOver,
    required this.totalWickets,
    required this.isInningsCompleted,
    required this.battingStats,
    required this.blowingStats,
  });
  late final int id;
  late final int wickets;
  late final int balls;
  late final int score;
  late final int totalOver;
  late final int totalWickets;
  late final bool isInningsCompleted;
  late final List<BattingStats> battingStats;
  late final List<BlowingStats> blowingStats;

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
    _data['battingStats'] = battingStats.map((e)=>e.toJson()).toList();
    _data['blowingStats'] = blowingStats.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class BattingStats {
  BattingStats({
    required this.id,
    required this.displayName,
    required this.userId,
    required this.runs,
    required this.balls,
    required this.sixer,
    required this.four,
    required this.blowedBy,
    required this.caughtBy,
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
    return _data;
  }
}

class BlowingStats {
  BlowingStats({
    required this.id,
    required this.displayNames,
    required this.userId,
    required this.runs,
    required this.wickets,
    required this.ballsBlowed,
  });
  late final int id;
  late final String displayNames;
  late final int userId;
  late final int runs;
  late final int wickets;
  late final int ballsBlowed;

  BlowingStats.fromJson(Map<String, dynamic> json){
    id = json['id'];
    displayNames = json['displayNames'];
    userId = json['userId'];
    runs = json['runs'];
    wickets = json['wickets'];
    ballsBlowed = json['ballsBlowed'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['displayNames'] = displayNames;
    _data['userId'] = userId;
    _data['runs'] = runs;
    _data['wickets'] = wickets;
    _data['ballsBlowed'] = ballsBlowed;
    return _data;
  }
}