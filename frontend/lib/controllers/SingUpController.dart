
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/utils/constant.dart';
import 'package:frontend/widgets/Snackbar.dart';
import 'package:get/get.dart';

import '../Services/auth/google_auth.dart';
import '../models/signUp.dart';
import '../pages/googlesingup.dart';

class SingUpController extends GetxController{

    TextEditingController username = TextEditingController();
    TextEditingController fullname = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController age = TextEditingController();
    TextEditingController role = TextEditingController();
    TextEditingController battingStyle = TextEditingController();
    TextEditingController blowingStyle = TextEditingController();

    bool isfilled(){
        if(  username.text.isEmpty || fullname.text.isEmpty ||
            password.text.isEmpty || fullname.text.isEmpty ||
            age.text.isEmpty || role.text.isEmpty ||
            battingStyle.text.isEmpty|| blowingStyle.text.isEmpty
            )return true;
        return false;
    }

    void singUp({String? Username = null,String?Password=null,String displayImage=""})async {
        if(isfilled()) return;
        var response= await makePostRequest(
            "/Auth/SingUpUser",
            SignUpmodel(
            id: 0, userName: (Username!=null)?Username:username.text, name: fullname.text,
            password:(Password!=null)?Password:password.text, role: role.text, age: int.parse(age.text) ,
            battingStyles: battingStyle.text, blowingStyles: blowingStyle.text,
            isExternal:(Username!=null)? true: false, matches: 0,runs: 0,wickets: 0, displayImage: displayImage
        ).toJson()
        );
        // print("response : "+ response!.data);
        if(response!.data["status"]){
            print("Executed");
            await Snackbar("Sucess","User Created",Colors.green.shade400);
            Get.to(loginPage());
        }
        else{
            print("not Executed");
            Snackbar("Not Sucessfull","Username is already exists",Colors.black38);
        }
    }

    void googleSingUp()async{
    var account = await getAccount();
    Get.to((gooogleSingUpPage(
        fullname: account!.displayName,
        email: account!.email,
        displayImage: account!.photoUrl
    )));

    }
}