
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/listofuserModels.dart';
import 'package:frontend/pages/teameditpage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/inventoryModels.dart';


class SearchController_user extends GetxController {
  RxString searchQuery = ''.obs;
  Rx<bool>mode = true.obs;
  TextEditingController serchEditor = new TextEditingController();
  Rx<ListOfUsers> users = ListOfUsers().obs;

  void updateSearchQuery() async{
    print(serchEditor.text);

    var response = await makeGetRequest("/Inventory/GetLeaderboard?mode=$mode${(serchEditor.text.trim()=="")?"":"&searchString="+serchEditor.text}",);
    if(response != null){
        ListOfUsers _users = ListOfUsers.fromJson(response!.data);
    print(_users.users!.length);
    users.value = _users;

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



class searchUserPage extends StatelessWidget {
  final SearchController_user searchController = Get.put<SearchController_user>(SearchController_user());
  TeamMembersController memberController ;
    searchUserPage({required this.memberController});
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
                    itemCount: (searchController.users.value.users==null)?0:
                        searchController.users.value.users!.length,
                    itemBuilder: (context, index) {
                        final user = searchController.users.value.users![index];
                        return ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.DisplayImage),
                        ),
                        title: Text(user.Name),
                        subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text('Role: ${user.Role}'),
                                SizedBox(width: 5,),
                                Text('Runs: ${user.Runs}'),
                                SizedBox(width: 5,),
                                Text('Wickets: ${user.Wickets}'),
                                SizedBox(width: 5,),
                                SizedBox(height: 10)
                                ],
                            ),
                            onTap: () {
                                memberController.addUser(User.fromJson(user.toJson()));
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