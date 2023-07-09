
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/listofuserModels.dart';
import 'package:frontend/widgets/NamewithPhoto.dart';
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
  void changeMode(value){
    mode.value  = value;
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
            Padding(padding: EdgeInsets.fromLTRB(16,0,16,20),
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
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
            const Padding(padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Text("LeaderBoard",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),),


            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    const Icon(Icons.sports_basketball_sharp),
                    Obx(() => Switch(
                    value: searchController.mode.value,
                    onChanged: (value) {
                        searchController.changeMode(value);
                        searchController.updateSearchQuery();
                    },
                ),),
                const Icon(Icons.sports_cricket),
                const SizedBox(width: 30,)
                ],
            ),]),
            const SizedBox(height: 30,),

            Expanded(child:Container(
                child: Obx(()=> ListView.builder(
                    itemCount: (searchController.users.value.users==null)?0:
                        searchController.users.value.users!.length,
                    itemBuilder: (context, index) {
                        final user = searchController.users.value.users![index];
                        Rx<bool> imgResult = true.obs;

                        return ListTile(
                        leading:Obx(() {
                                if (imgResult.value) {
                                return CircleAvatar(
                                    backgroundImage: NetworkImage(user.DisplayImage),
                                    onBackgroundImageError: (exception, stackTrace) {
                                    imgResult.value = false;
                                    },
                                );
                                } else {
                                return NameWithPhoto(name: user.Name,size: 40,);
                                }
                            }),
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