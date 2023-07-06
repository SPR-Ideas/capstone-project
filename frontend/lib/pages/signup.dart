
import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/SingUpController.dart';
import '../utils/constant.dart';
import '../widgets/Buttons.dart';
import '../widgets/inputwidgets.dart';

class singUP extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    var singupContoller =  SingUpController();


        return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:  AppBar(
            title: const Text(""),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white10,
            iconTheme: IconThemeData(color: Colors.grey.shade600),
            // automaticallyImplyLeading: false
            ),
        body:Center(
            child: Container(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                    child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Column(
                            children: <Widget>[

                                ExpandedButtonWithOutline(
                                    label:"Google SingUp",
                                    onpressed: singupContoller.googleSingUp ,
                                ),
                                const SizedBox(height: 20,),
                                const Divider(
                                    thickness: 2,
                                    color:Color.fromARGB(97, 158, 158, 158),
                                ),
                                const SizedBox(height: 10,),
                                const Text(
                                    "Register" ,
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        fontSize: 35,
                                        fontWeight: FontWeight.w600
                                        ),
                                    ),
                                const  SizedBox(height: 30,),

                                CustomTextBox(
                                    hintText: "username",
                                    icon: Icons.person_2_rounded,
                                    Controller : singupContoller.username
                                    ),
                                const SizedBox(height: 20,),

                                PasswordTextBox(
                                    hintText: "password",
                                    Controller: singupContoller.password,
                                    ),
                                const SizedBox(height: 20,),

                                CustomTextBox(
                                    hintText: "full name",
                                    icon: Icons.person_2_rounded,
                                    Controller : singupContoller.fullname
                                    ),
                                const SizedBox(height: 20,),


                                CustomTextBox(
                                    hintText: "Age",
                                    icon: Icons.timelapse,
                                    Controller : singupContoller.age
                                    ),
                                const SizedBox(height: 20,),


                                CustomTextBox(
                                    hintText: "Roles (Batsmen / Blower / AllRounder)",
                                    icon: Icons.sports_cricket,
                                    Controller : singupContoller.role
                                    ),
                                const SizedBox(height: 20,),

                                CustomTextBox(
                                    hintText: "Batting Style",
                                    icon: Icons.sports_cricket_rounded,
                                    Controller : singupContoller.battingStyle
                                    ),
                                const SizedBox(height: 20,),


                                CustomTextBox(
                                    hintText: "Blowing Style",
                                    icon: Icons.sports_baseball_rounded,
                                    Controller : singupContoller.blowingStyle
                                    ),
                                const SizedBox(height: 20,),


                                ExpandedButton(
                                    label: "Register",
                                    onpressed: singupContoller.singUp ,
                                ),
                                const SizedBox(height: 10,),

                                const SizedBox(height: 20),
                                GestureDetector(
                                    onTap: (){Get.to(loginPage());},
                                    child: const Text(
                                        "Already Have Account SingIn",
                                        style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                        ),
                                    ),
                                ),
                            const SizedBox(height: 50),

                            ],
                        )
                    ],
                ) ,
            )
        )
        )

        );

    }
}