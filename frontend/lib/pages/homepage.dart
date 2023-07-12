
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/controllers/HomeController.dart';
import 'package:frontend/models/inventoryModels.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/teampage.dart';
import 'package:frontend/pages/updateuserpage.dart';
import 'package:frontend/utils/constant.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'histrorypage.dart';
import 'leaderboardPage.dart';
import 'matchpage.dart';

class homePage extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return homeWidget();  }

}
class homeWidget extends HookWidget {

  @override
  Widget build(BuildContext context) {
    final homecontroller = Get.put(HomeController());
    // final displayImage = useState<String?>(null);
    // final HomeTabs tabs = Get.put(HomeTabs());
    // late MyTabController myTabController = Get.put(MyTabController( model: homecontroller,widget: this));

    // useEffect(() {
    //   homecontroller.InventoryCall().then((_) => {
    //     displayImage.value = homecontroller.inventorymodel!.user!.displayImage,
    //   });
    //   return null;
    // },[myTabController.selectedIndex]);


    return  Scaffold(
      appBar: AppBar(
        title: const Text("Gully Cricket"),
        centerTitle: true,
        leading: Obx(() =>   Row( children:[
            SizedBox(width: 20,),
            Expanded(child: GestureDetector(
            onTap: () => Get.to(updateUserpage(userModel: homecontroller.inventorymodel!.value.user)),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: homecontroller.displayImage.value != null
                ? NetworkImage(homecontroller.displayImage.value!)
                : null,
            ),
          )),

          ])),
        backgroundColor: primaryColor,
        actions: [
          GestureDetector(
            onTap: () => {
                Storage.WriteValue("token", ""),
                Get.to(loginPage())
            },
            child: Icon(Icons.logout)
          ),
          const SizedBox(width: 20,),
        ],
      ),
      body: Obx(() =>  homecontroller.currentTab.value),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: homecontroller.selectedIndex.value,
        onTap: homecontroller.changeTabIndex,
        selectedLabelStyle: const TextStyle(color: primaryColor),
        selectedItemColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket, color: primaryColor,),
            label: 'New Match',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups, color: primaryColor,),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: primaryColor,),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard, color: primaryColor,),
            label: 'Leaderboard',
          ),
        ],
      )),
    );
  }
}

// class MyTabController extends GetxController {

//    RxInt selectedIndex = 0.obs;
//    late Rx<StatelessWidget>  currentTab = Rx<StatelessWidget>(MatchPage());
//     final HomeController? model;
//     final homeWidget? widget;
//     MyTabController({this.model,this.widget});

//   void changeTabIndex(int index) async {
//     await model!.InventoryCall();

//     selectedIndex.value = index;

//     switch (index) {
//       case 0:
//         currentTab.value =MatchPage() ;
//         break;
//       case 1:
//         currentTab.value = TeamsPage(inventorymodel: model!.inventorymodel!.value);
//         break;
//       case 2:
//         currentTab.value = HistoryPage(inventorymodel: model!.inventorymodel!.value);
//         break;
//       case 3:
//         currentTab.value = LeaderBoardPage();
//       default:
//         currentTab.value = MatchPage() ;
//     }
//   }
// }



