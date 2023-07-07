class TeamserachResponse {
  TeamserachResponse({
    required this.teamInstance,
  });
  late final List<TeamInstance> teamInstance;

  TeamserachResponse.fromJson(Map<String, dynamic> json){
    teamInstance = List.from(json['teamInstance']).map((e)=>TeamInstance.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['teamInstance'] = teamInstance.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class TeamInstance {
  TeamInstance({
    required this.id,
    required this.name,
    required this.members,
    required this.count,
  });
  late final int id;
  late final String name;
  late final List<Members> members;
  late final int count;

  TeamInstance.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    members = List.from(json['members']).map((e)=>Members.fromJson(e)).toList();
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['members'] = members.map((e)=>e.toJson()).toList();
    _data['count'] = count;
    return _data;
  }
}

class Members {
  Members({
    required this.id,
    required this.userId,
    required this.isCaptain,
    required this.isPlaying,
  });
  late final int id;
  late final int userId;
  late final bool isCaptain;
  late final bool isPlaying;

  Members.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['userId'];
    isCaptain = json['isCaptain'];
    isPlaying = json['isPlaying'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['isCaptain'] = isCaptain;
    _data['isPlaying'] = isPlaying;
    return _data;
  }
}