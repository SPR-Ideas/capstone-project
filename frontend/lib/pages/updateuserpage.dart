
import 'package:flutter/material.dart';
import 'package:frontend/controllers/updateuserController.dart';
import 'package:frontend/models/inventoryModels.dart';

import '../widgets/Buttons.dart';
import '../widgets/inputwidgets.dart';

class updateUserpage extends StatelessWidget{
    final User? userModel;
    final updateController;
    updateUserpage({Key?key, this.userModel}) : updateController =  updateUserController(user: userModel );


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar:  AppBar(
            title: const Text(""),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white10,
            iconTheme: IconThemeData(color: Colors.grey.shade600),
            // automaticallyImplyLeading: false
            ),
            body: Center(
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
                                        backgroundImage: NetworkImage(userModel!.displayImage), // or AssetImage for local assets
                                    ),
                                const SizedBox(height: 10,),

                                Text(
                                    userModel!.name ,
                                    style: const TextStyle(
                                        fontFamily: "Helvetica",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700
                                        ),
                                    ),
                                const SizedBox(height:10),

                                Text(
                                    userModel!.userName,
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
                                    Controller : updateController.fullname
                                    ),
                                const SizedBox(height: 20,),


                                CustomTextBox(
                                    hintText: "Age",
                                    icon: Icons.timelapse,
                                    Controller : updateController.age
                                    ),
                                const SizedBox(height: 20,),


                                CustomTextBox(
                                    hintText: "Roles (Batsmen / Blower / AllRounder)",
                                    icon: Icons.sports_cricket,
                                    Controller : updateController.role
                                    ),
                                const SizedBox(height: 20,),

                                CustomTextBox(
                                    hintText: "Batting Style",
                                    icon: Icons.sports_cricket_rounded,
                                    Controller : updateController.battingStyle
                                    ),
                                const SizedBox(height: 20,),


                                CustomTextBox(
                                    hintText: "Blowing Style",
                                    icon: Icons.sports_baseball_rounded,
                                    Controller : updateController.blowingStyle
                                    ),
                                const SizedBox(height: 20,),


                                ExpandedButton(
                                    label: "Save",
                                    onpressed: (){updateController.updateUser();} ,
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
,
        );
    }
}