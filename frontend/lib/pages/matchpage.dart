
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/teamsearcResponse.dart';
import 'package:frontend/pages/searchteampage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/constant.dart';
import '../widgets/Snackbar.dart';
import '../widgets/inputwidgets.dart';
import 'enginepage.dart';

Widget matchPage()
{
    return Center(
      child: MatchPage()
    );
}

class MatchControlller extends GetxController{
    TextEditingController visitorTeam = new TextEditingController();
    TextEditingController hostTeam = new TextEditingController();
    TextEditingController overs = new TextEditingController();

    RxBool ishost = false.obs;
    RxBool isbat = false.obs;
    RxBool lastmanStanding = false.obs;

    Rx<String> clickedfor = "".obs;
    late Rx<TeamInstance?> hostTeamInstance =  Rx<TeamInstance?>(null) ;
    late Rx<TeamInstance?> visitorTeamInstance =  Rx<TeamInstance?>(null);

    void addTeam(TeamInstance _team){
        if(clickedfor=="host"){
            hostTeamInstance.value = _team;
            hostTeam.text = _team.name;
        }
        else{
            visitorTeamInstance.value= _team;
            visitorTeam.text = _team.name;
        }
    }
    bool validations(){
        if(hostTeam.text.isEmpty || visitorTeam.text.isEmpty){
            Snackbar("Team is not selected Yet","kindly select the team",Colors.red.shade300);
            return false;
        }
        if(overs.text.trim().isEmpty || num.tryParse(overs.text.trim())==null){
            Snackbar("Invalid Overs feild","pleas enter a vaild number to ",Colors.red.shade300);
            return false;
        }
        if(hostTeamInstance.value!.count != visitorTeamInstance.value!.count){
            Snackbar("Number of team players missmatch " ,"Please check both visitor and host team have same number of players",Colors.red.shade300);
            return false;
        }
        if(hostTeamInstance.value!.id==visitorTeamInstance.value!.id ){
            Snackbar("Both Team Are Same","you need two different teams to create a match",Colors.red.shade300);
            return false;
        }
        return true;
    }

    void createMatch() async{
        var ishostInning = false;
        if((ishost.value&&isbat.value) ||(!ishost.value && !isbat.value)){
            ishostInning = true;
        }
        if(validations()){
            final _data = <String, dynamic>{};

               _data["hostTeam_id"]= hostTeamInstance.value!.id;
                _data["visitorTeam_id"]= visitorTeamInstance.value!.id;
                _data["overs"] = overs.text;
                _data["wickets"] = (lastmanStanding.value)?hostTeamInstance.value!.count:hostTeamInstance.value!.count-1;
                _data["isHostInnings"]= ishostInning;


            var response =await makePostRequest("/Inventory/CreateMatch",_data );

            if(response!=null){
                if(response.data!=null){
                    if(response.data["status"]){
                        Snackbar("Match Created Successfully","",Colors.green.shade300);
                        Get.to( CricketCounterPage(ScoreCardId: response.data["scoreCardId"],));
                    }
                    else{
                        Snackbar("Error Occur while creating a Match","",Colors.red.shade300);
                    }
                }
            }
            else{
                print("Errro whlie getting the response");
                return ;
            }

        }
    }

}


class MatchPage extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    MatchControlller Mcontroller = Get.put(MatchControlller());
    // TODO: implement build
    return Scaffold(
        body:SingleChildScrollView(
            child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
            children:[
               CustomTextBox(
                        hintText: "Host Team",
                        icon: Icons.group,
                        Controller:  Mcontroller.hostTeam ,
                        enable_: true,
                        suffixIcon_: Icons.playlist_add_circle_sharp,
                        suffixFun: (){
                            Mcontroller.clickedfor.value="host";

                            Get.to(searchteamPage(memberController: Mcontroller));

                            },
                    ),
                SizedBox(height: 20,),
                CustomTextBox(
                        hintText: "vistor Team",
                        icon: Icons.group,
                        Controller: Mcontroller.visitorTeam,
                        enable_: true,
                        suffixIcon_: Icons.playlist_add_circle_sharp,
                        suffixFun: (){
                            Mcontroller.clickedfor.value="vistor";
                            Get.to(searchteamPage(memberController: Mcontroller));
                        ;}
                    ),
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Text("Toss won by ? ",style: TextStyle(color: primaryColor,fontSize: 18,fontWeight: FontWeight.w400),),
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    const Text("Vistor"),
                    Obx(() => Switch(
                    activeColor: primaryColor,
                    value: Mcontroller.ishost.value,
                    onChanged: (value) {
                        Mcontroller.ishost.value = value;
                    },
                ),),
                const Text("Host"),
                const SizedBox(width: 30,)
                ],
            )
            ],),

            SizedBox(height: 20),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Text("Opted to ? ",style: TextStyle(color: primaryColor,fontSize: 18,fontWeight: FontWeight.w400),),
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    const Icon(Icons.sports_baseball_sharp),
                    Obx(() => Switch(
                    activeColor: primaryColor,
                    value: Mcontroller.isbat.value,
                    onChanged: (value) {
                        Mcontroller.isbat.value = value;
                    },
                ),),
                const Icon(Icons.sports_cricket),
                const SizedBox(width: 30,)
                ],
            )
            ],),

            SizedBox(height: 20),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Text("Last Man Standing ? ",style: TextStyle(color: primaryColor,fontSize: 18,fontWeight: FontWeight.w400),),
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    const Text("No"),
                    Obx(() => Switch(
                    activeColor: primaryColor,
                    value: Mcontroller.lastmanStanding.value,
                    onChanged: (value) {
                        Mcontroller.lastmanStanding.value = value;
                    },
                ),),
                const Text("Yes"),
                const SizedBox(width: 30,)
                ],
            )
            ],),
            SizedBox(height: 20,),
            CustomTextBox(hintText: "Overs", icon: Icons.sports_baseball_rounded,Controller: Mcontroller.overs,),
            SizedBox(height: 20,),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(primaryColor) ),onPressed: (){Mcontroller.createMatch();}, child: Text("Start Match"))
                ],
            )

            ,]),


        ),
        )
        );
  }
}