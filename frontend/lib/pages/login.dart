import 'package:flutter/material.dart';
import 'package:frontend/controllers/LoginController.dart';
import 'package:frontend/widgets/inputwidgets.dart';
import 'package:frontend/widgets/Buttons.dart';
import 'package:get/get.dart';
import "signup.dart";
import '../utils/constant.dart';


class loginPage extends StatelessWidget{
    @override
    Widget build(BuildContext context ){
        final LoginController loginController = Get.put(LoginController());
        
        return Scaffold(
        resizeToAvoidBottomInset: true,
        body:Center(
            child: Container(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                    child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Column(
                            children: <Widget>[
                                const Text(
                                    "Login" ,
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
                                    Controller : loginController.username
                                    ),
                                const SizedBox(height: 20,),

                                PasswordTextBox(
                                    hintText: "password",
                                    Controller: loginController.password,
                                    ),
                                const SizedBox(height: 20,),

                                ExpandedButton(
                                    label: "Login",
                                    onpressed: loginController.Login ,

                                ),
                                const Divider(
                                    thickness: 2,
                                    color:Color.fromARGB(97, 158, 158, 158),),

                                const SizedBox(height: 10,),
                                ExpandedButtonWithOutline(
                                    label:"Google SignIn",
                                    onpressed:(){ loginController.Login(google: true);} ,
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                    onTap: (){Get.to(singUP());} ,
                                    child: const Text(
                                    "Have Not Account Yet?,Register here",
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