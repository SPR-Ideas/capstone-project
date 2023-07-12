import 'package:flutter/material.dart';
import 'package:frontend/models/inventoryModels.dart';
import 'package:frontend/pages/teameditpage.dart';
import 'package:frontend/utils/constant.dart';
import 'package:frontend/widgets/NamewithPhoto.dart';
import 'package:get/get.dart';

Widget teamsPage(Inventorymodel? inventory){
    if(inventory!=null){
        if(inventory.teams!.length!=0){

            return TeamsPage(inventorymodel: inventory);
        }
        else{
            return TeamsPage(inventorymodel: inventory);
        }
    }
    else{return Center(child: Text("Issue on Server"),);}
}

class teampageController extends GetxController{
    Rx<Inventorymodel> inventorymodel = Inventorymodel(
                        matches: <Matches>[],teams: <Teams>[],).obs;


}

class TeamsPage extends StatelessWidget {
  final Inventorymodel? inventorymodel;

  TeamsPage({Key? key, required this.inventorymodel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            children: [
                SizedBox(height: 10,),
                Expanded(child:
                ListView.builder(
                    itemCount: inventorymodel!.teams?.length ?? 0,
                    itemBuilder: (context, index) {
                    final team = inventorymodel!.teams?[index];
                    return ListTile(
                        leading: NameWithPhoto(name:team?.name??"" ),
                        title: Text(team?.name??"",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                        subtitle: Text('Members : ${team?.count ?? 0}'),
                        onTap: () {
                            Get.to(teamEditPage(team: team,teamId: team!.id,));
                        // Handle team selection here
                        },
                    );
                    },
                ),),
            SizedBox(height: 40,),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    ElevatedButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(primaryColor)),
                        onPressed:(){
                        Get.to(
                            teamEditPage(team: Teams(
                                captainId: 0,
                                count: 0,
                                id: 0,
                                members: <Members>[],
                                name: ""
                            ),teamId:0,));} ,
                        child: Text("Create Team")),
                        SizedBox(width: 25,)
                        ],
            ),

            SizedBox(height: 20,),
            ],
        ),
      )
    );
  }
}
