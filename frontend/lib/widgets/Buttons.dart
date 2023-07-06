

import 'package:frontend/utils/constant.dart';
import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
   final String label;
   final IconData? icon;
   final Function? onpressed;
   const  ExpandedButton( {
        Key ? key,
        this.icon,
        required this.label,
        required this.onpressed ,

    }):super(key:key);
    @override
    Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
                padding: MaterialStateProperty.all( const EdgeInsets.fromLTRB(0, 15, 0, 15))
            ),
            onPressed: onpressed as void Function()?,
            child: Text(
                label,
                style: const TextStyle(
                    color: Colors.white
                )
            ),
        ),
    );
  }
}

class ExpandedButtonWithOutline extends StatelessWidget {
   final String label;
   final IconData? icon;
   final Function? onpressed;
   const  ExpandedButtonWithOutline( {
        Key ? key,
        this.icon,
        required this.label,
        required this.onpressed
        // required this.onpressed

    }):super(key:key);
    @override
    Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const  EdgeInsets.all(10),
        child: ElevatedButton(

            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 255, 255)),
                side: MaterialStateProperty.all(const BorderSide(color:primaryColor, width: 2)),
                padding: MaterialStateProperty.all( const EdgeInsets.all(15))

            ),
            onPressed: onpressed as void Function()?,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Image.asset(
                        "assets/img/google-logo.png",
                        height: 20,
                        width: 20,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                        label,
                        style: const TextStyle(
                            color: primaryColor
                        ),
                    ),
                ],
            )
        ),
    );
  }
}