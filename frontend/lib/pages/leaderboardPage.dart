
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/listofuserModels.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/constant.dart';


class SearchController extends GetxController {
  RxString searchQuery = ''.obs;
  Rx<bool>mode = true.obs;
  TextEditingController serchEditor = new TextEditingController();
  Rx<ListOfUsers> users = ListOfUsers().obs;
  SearchController(){
    updateSearchQuery();
  }
  void updateSearchQuery() async{
    print(serchEditor.text);

    var response = await makeGetRequest("/Inventory/GetLeaderboard?mode=$mode${(serchEditor.text.trim()=="")?"":"&searchString="+serchEditor.text}",);
    if(response != null){
        ListOfUsers _users = ListOfUsers.fromJson(response!.data);
    print(_users.users!.length);
    users.value = _users;

    }
    }

  void clearSearchQuery() {
    searchQuery.value = '';
    serchEditor.text = "";
  }
}



Widget leaderboardPage(){
    return MyHomePage();
}


class MyHomePage extends StatelessWidget {
  final SearchController searchController = Get.put<SearchController>(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
            Padding(padding: EdgeInsets.fromLTRB(16,0,16,0),
            child:  TextField(
              controller: searchController.serchEditor,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed : searchController.updateSearchQuery,
                ),
              ),
            ),
            ),
            SizedBox(height: 20,),

            Text("LeaderBoard",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            SizedBox(height: 10),
            Divider(thickness: 1,color: Colors.grey.shade200,),
            SizedBox(height: 10),

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
                        // Add more user information as needed
                        );

                    },

                    ))
                ,)
            )
        ],
      ),
    );
  }
}