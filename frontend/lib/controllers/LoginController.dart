

import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/models/credentialModels.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/utils/constant.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Services/auth/google_auth.dart';
import '../pages/login.dart';
// import 'package:frontend/utils/constant.dart';

class LoginController extends GetxController{
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();


    void Print_(){
        print(username.text);
        print(password.text);
    }

    void Login({google=false})async{
        var account ;
        if(google)
            account = await getAccount();

        CredentialModel cred = CredentialModel(
            username:(google)? account.email:username.text,
            password :(google)?"":password.text,
            isExternal :google);

        var response = await makePostRequest("/Auth/auth", cred.toJson());
        if(response!.data["token"]==""){
            print("Invalid Credentials");
            Get.snackbar(
                "Invalid Credentials",
                "Username and password Incorrect",
                snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
                backgroundColor: Colors.black38, // Background color of the snackbar
                colorText: Colors.white, // Text color of the snackbar
                duration: const  Duration(seconds: 3)
                );

        }else{
            Storage.WriteMappedValue("token", response.data);
            print(response!.data);
            await Get.to(homePage());
        }
    }
}