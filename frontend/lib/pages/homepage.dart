
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/controllers/HomeController.dart';
import 'package:frontend/models/inventoryModels.dart';
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

}class homeWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final homecontroller = Get.put(HomeController());
    final displayImage = useState<String?>(null);
    // final HomeTabs tabs = Get.put(HomeTabs());
    late MyTabController myTabController = Get.put(MyTabController( model: homecontroller));
    useEffect(() {
      homecontroller.InventoryCall().then((_) => {
        displayImage.value = homecontroller.inventorymodel!.user!.displayImage,
      });
      return null;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gully Cricket"),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          GestureDetector(
            onTap: () => Get.to(updateUserpage(userModel: homecontroller.inventorymodel!.user)),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: displayImage.value != null
                ? NetworkImage(displayImage.value!)
                : null,
            ),
          ),
          const SizedBox(width: 20,),
        ],
      ),
      body: Obx(() => myTabController.currentTab.value),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: myTabController.selectedIndex.value,
        onTap: myTabController.changeTabIndex,
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

class MyTabController extends GetxController {
  RxInt selectedIndex = 0.obs;
   Rx<Widget>  currentTab = historyPage().obs ;
    final HomeController? model;
    MyTabController({this.model});

  void changeTabIndex(int index) {
    selectedIndex.value = index;


    switch (index) {
      case 0:
        currentTab.value = matchPage();
        break;
      case 1:
        currentTab.value = teamsPage(model!.inventorymodel);
        break;
      case 2:
        currentTab.value = historyPage();
        break;
      case 3:
        currentTab.value = leaderboardPage();
      default:
        currentTab.value = matchPage();
    }
  }
}



