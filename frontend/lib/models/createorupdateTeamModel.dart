class CRPTeam {
  CRPTeam({
    this.Id =0,
    required this.Name,
    required this.Count,
    required this.members,
  });
  late final int Id;
  late final  String Name;
  late final int Count;
  late final List<Member> members; // Replace `_Members` with `Members` here

  CRPTeam.fromJson(Map<String, dynamic> json){
    Id = json["Id"];
    Name = json["Name"];
    Count = json['Count'];
    members = List.from(json['Members']).map((e)=>Member.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Count'] = Count;
    _data['Members'] = members.map((e)=>e.toJson()).toList();
    _data["Name"] = Name;
    _data["Id"] = Id;
    return _data;
  }
}

class Member { // Define your Members class here
  Member({
    required this.Id,
    required this.userId,
    required this.IsCaptain,
    required this.IsPlaying,
  });
  late final int Id;
  late final int userId;
  late final bool IsCaptain;
  late final bool IsPlaying;

  Member.fromJson(Map<String, dynamic> json){
    Id = json['Id'];
    userId = json['userId'];
    IsCaptain = json['IsCaptain'];
    IsPlaying = json['IsPlaying'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["Id"] = Id;
    _data['userId'] = userId;
    _data['IsCaptain'] = IsCaptain;
    _data['IsPlaying'] = IsPlaying;
    return _data;
  }
}
