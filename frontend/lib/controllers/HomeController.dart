
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/inventoryModels.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';

import '../pages/histrorypage.dart';
import '../pages/leaderboardPage.dart';
import '../pages/login.dart';
import '../pages/matchpage.dart';
import '../pages/teampage.dart';

class HomeController extends GetxController{

    RxBool teamchange = false.obs;

    late Rx<Inventorymodel>? inventorymodel = Rx<Inventorymodel>(Inventorymodel(teams: <Teams>[], matches: <Matches>[]));
    late RxString displayImage = RxString("");
    @override
    void onInit(){
        super.onInit();
        InventoryCall().then((value) =>
            displayImage.value = inventorymodel!.value.user!.displayImage
        );

    }


    Future<void> InventoryCall()async{
       print("Called inventory");
       try{
            var response  = await makeGetRequest("/Inventory/GetInventory");
            inventorymodel!.value =  Inventorymodel(teams: <Teams>[], matches: <Matches>[]);
            inventorymodel!.value = Inventorymodel.fromJson(response!.data);
            print(inventorymodel);
       }catch(e){
        Get.to(Material(child:loginPage()));
       }

    }

   RxInt selectedIndex = 0.obs;
   late Rx<StatelessWidget>  currentTab = Rx<StatelessWidget>(MatchPage());





  void changeTabIndex(int index) async {

    selectedIndex.value = index;

    switch (index) {
      case 0:
        currentTab.value =MatchPage() ;
        break;
      case 1:
        await InventoryCall();
        currentTab.value = TeamsPage(inventorymodel: inventorymodel!.value);
        break;
      case 2:
        await InventoryCall();
        currentTab.value = HistoryPage(inventorymodel: inventorymodel!.value);
        break;
      case 3:
        currentTab.value = LeaderBoardPage();
      default:
        currentTab.value = MatchPage() ;
    }
  }
}