import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/signUp.dart';
import "package:frontend/models/inventoryModels.dart";
import 'package:get/get.dart';

import '../widgets/Snackbar.dart';

class updateUserController extends GetxController{
    final User user;
    TextEditingController fullname = TextEditingController();
    TextEditingController age = TextEditingController();
    TextEditingController role = TextEditingController();
    TextEditingController battingStyle = TextEditingController();
    TextEditingController blowingStyle = TextEditingController();

    updateUserController({ required this.user}){
        fullname.text = user.name;
        age.text = user.age.toString();
        role.text = user.role;
        battingStyle.text = user.battingStyles;
        blowingStyle.text = user.blowingStyles;
    }

    bool isfilled(){
        if( fullname.text.isEmpty ||
            age.text.isEmpty || role.text.isEmpty ||
            battingStyle.text.isEmpty|| blowingStyle.text.isEmpty
            )return true;
        return false;
    }

    void updateTheContent(){
        user.name = fullname.text ;
        user.age = int.parse(age.text) ;
        user.role = role.text ;
        user.battingStyles = battingStyle.text ;
        user.blowingStyles = blowingStyle.text ;
    }

    void updateUser()async {
        if(isfilled()){Snackbar("Please fill all the feilds","",Colors.red.shade300);return;}
        updateTheContent();
        var response = await makePutRequest("/Inventory/UpdateUser", user.toJson());
        if(response!.data["status"]){
            Snackbar("User Profile Saved","",Colors.green.shade300);
        }
        else{
            Snackbar("Could'nt save changes","",Colors.red.shade300);

        }
    }

}