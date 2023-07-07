
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/listofuserModels.dart';
import 'package:frontend/pages/teameditpage.dart';
import 'package:frontend/widgets/NamewithPhoto.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../models/createorupdateTeamModel.dart';
import '../models/inventoryModels.dart';
import '../models/teamsearcResponse.dart';
import '../utils/constant.dart';
import 'matchpage.dart';


class SearchController extends GetxController {
  RxString searchQuery = ''.obs;
  Rx<bool>mode = true.obs;
  TextEditingController serchEditor = new TextEditingController();
  late Rx<TeamserachResponse> teams =TeamserachResponse(teamInstance: <TeamInstance>[]).obs;

  void updateSearchQuery() async{
    print(serchEditor.text);

    var response = await makeGetRequest("/Inventory/getTeams${(serchEditor.text.trim()=="")?"":"?searchString="+serchEditor.text}",);
    if(response != null){
        TeamserachResponse _users = TeamserachResponse.fromJson(response!.data);
    print(_users.teamInstance.length);
    teams.value = _users;

    }
    }
  void changeMode(value){
    mode.value  = value;
  }

  void clearSearchQuery() {
    searchQuery.value = '';
    serchEditor.text = "";
  }
}



class searchteamPage extends StatelessWidget {
  final SearchController searchController = Get.put<SearchController>(SearchController());
  MatchControlller memberController ;
    searchteamPage({required this.memberController});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white10,elevation: 0,iconTheme: IconThemeData(color: Colors.grey.shade400),),
      body: Column(
        children: [
            Padding(padding: EdgeInsets.fromLTRB(16,0,16,0),
            child:  TextField(
              controller: searchController.serchEditor,
              decoration: InputDecoration(
                labelText: 'Search users',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed : searchController.updateSearchQuery,
                ),
              ),
            ),
            ),

            Expanded(child:Container(
                child: Obx(()=> ListView.builder(
                    itemCount: (searchController.teams.value.teamInstance==null)?0:
                        searchController.teams.value.
                        teamInstance!.length,
                    itemBuilder: (context, index) {
                        final team = searchController.teams.value.teamInstance![index];
                        return ListTile(
                        leading: NameWithPhoto(name:team.name ),
                        title: Text(team.name),
                        subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(' Members : ${team.count}'),
                                SizedBox(width: 5,),
                                SizedBox(height: 10)
                                ],
                            ),
                            onTap: () {
                                memberController.addTeam(TeamInstance.fromJson(team.toJson()));
                                Get.back();
                            },
                        // Add more user information as needed
                        );
                    },

                    ))
                ,)
            ),

        ],
      ),
    );
  }
}