
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/inventoryModels.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../pages/login.dart';

class HomeController extends GetxController{
    Inventorymodel? inventorymodel ;

    Future<void> InventoryCall()async{
       print("Called inventory");
       try{
            var response  = await makeGetRequest("/Inventory/GetInventory");
            inventorymodel = Inventorymodel.fromJson(response!.data);
            print(inventorymodel);
       }catch(e){
        Get.to(Material(child:loginPage()));
       }

    }
}