import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/listofuserModels.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/searchforUser.dart';
import 'package:frontend/widgets/Snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/createorupdateTeamModel.dart';
import '../models/inventoryModels.dart';
import '../models/inventoryModels.dart';

import '../utils/constant.dart';



class TeamMembersController extends GetxController {
  final RxList<Members> membersList = <Members>[].obs;
  final Teams? team;

    TextEditingController teamName = new TextEditingController();
  TeamMembersController(this.team){
    for (Members member in team!.members){
        membersList.add(member);
        teamName.text=team!.name;
    }
  }
  void removeUser(int Id){
    membersList.removeWhere((x)=>x.user.id == Id);
    team!.members.removeWhere((x)=>x.user.id ==Id);

  }
  void addUser(User _user){
    Members member = Members(id:0,isCaptain: false,isPlaying: true,user: _user);
    membersList.add(member);
    print(membersList.length);
  }

  List<Member> MemberstoMemberClass(List<Members>_Members){
    List<Member> members = <Member>[];
    for(Members member in _Members){
        Member m = Member(
            Id : member.id,
            userId:member.user.id,
            IsCaptain: true,
            IsPlaying: true
            );
        members.add(m);
    }
    return members;
  }

 void save()async {
    final CRPTeam _team =CRPTeam(
        Id: team!.id,
        Name: teamName.text,
        Count: team!.members.length,
        members: MemberstoMemberClass(team!.members));
        List<int> ids = _team.members.map((e) => e.userId).toList();

        membersList.value.removeWhere((element) =>ids.contains(element.user.id));
        _team.members.addAll(
            MemberstoMemberClass(membersList.value)
        );
    if(teamName.text.isEmpty){Snackbar("Enter the Team Name","",Colors.red.shade300);return;}
    var response = await makePutRequest("/Inventory/UpdateTeam", _team.toJson());
    if (response!=null){
        if(response.data["status"]){
            Snackbar("Updated Sucessfully", "", Colors.green.shade300);
            Get.to(homePage());
        }
    }
  }

}




class teamEditPage extends StatelessWidget{
    late final teamId;
    final Teams? team;
  teamEditPage({this.teamId=0,this.team});


    @override
  Widget build(BuildContext context) {

    TeamMembersController membersController = Get.put(TeamMembersController(team));

    return Scaffold(
        appBar: AppBar(
        title:  Text(team!.name),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt_1),
            onPressed: () {
              // Handle button press here
              Get.to(searchUserPage(memberController: membersController));
            },
          ),
          SizedBox(width: 20,),
          GestureDetector(onTap: membersController.save,
          child : Icon(Icons.save)
          ),
          SizedBox(width: 20,)
        ],

        ),
        body:Column(
            children: [
            Padding(padding: EdgeInsets.fromLTRB(16,0,16,0),
            child:  TextField(
              controller: membersController.teamName,
              decoration: InputDecoration(
                labelText: 'TeamName',

              ),
            ),
            ),

            Expanded(child:
                Obx(() {
        return membersController.membersList.isEmpty
            ? const Center(
                child: Text('No members found'),
              )
            : ListView.builder(
                itemCount: membersController.membersList.length,
                itemBuilder: (context, index) {
                  final member = membersController.membersList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member.user.displayImage),
                    ),
                    title: Text(member.user.name),
                    subtitle: Text('Role: ${member.user.role}'),
                    trailing: GestureDetector(
                        onTap: (){membersController.removeUser(member.user.id);},
                        child : Icon(Icons.delete,color:Colors.black)
                    ) ,
                  );
                },
              );
      }),
            )
            ],
        )
        );

  }
}


