
import 'package:flutter/material.dart';
import 'package:frontend/controllers/SingUpController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/constant.dart';
import '../widgets/Buttons.dart';
import '../widgets/inputwidgets.dart';

class gooogleSingUpPage extends StatelessWidget{
    final fullname ;
    final email;
    final displayImage;

    const gooogleSingUpPage({
        Key?key,
        required this.fullname,
        required this.email,
        required this.displayImage,
    });
    @override
  Widget build(BuildContext context) {
    var singupContoller = new SingUpController();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
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

                                CircleAvatar(
                                        radius: 50, // adjust the radius as needed
                                        backgroundImage: NetworkImage(displayImage), // or AssetImage for local assets
                                    ),
                                const SizedBox(height: 10,),

                                Text(
                                    fullname ,
                                    style: const TextStyle(
                                        fontFamily: "Helvetica",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700
                                        ),
                                    ),
                                const SizedBox(height:10),

                                Text(
                                    email,
                                    style: TextStyle(color: Colors.grey.shade500),
                                ),
                                const SizedBox(height: 10,),

                                const Text(
                                    "Details" ,
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600
                                        ),
                                    ),
                                const  SizedBox(height: 30,),

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
                                    label: "Create Account",
                                    onpressed: (){singupContoller.singUp(Username:email,Password:"",displayImage:displayImage );} ,
                                ),
                                const SizedBox(height: 10,),

                                const SizedBox(height: 20),

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