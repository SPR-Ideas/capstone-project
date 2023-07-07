
import 'package:flutter/material.dart';

import '../utils/constant.dart';


class CustomTextBox extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? Controller;
  final bool enable_;
  final IconData? suffixIcon_;
  final Function? suffixFun;

  const CustomTextBox({
    Key? key,
    required this.hintText,
    required this.icon,
    this.Controller,
    this.enable_ = true,
    this.suffixIcon_,
    this.suffixFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(icon, color: primaryColor),
          ),
          Expanded(
            child: TextField(
              controller: Controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                enabled: enable_,
                suffixIcon: IconButton(icon: Icon(suffixIcon_,color: primaryColor,),
                onPressed: (){suffixFun!.call();},
                )
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PasswordTextBox extends StatefulWidget {
  final String hintText;
  final Controller ;


  const PasswordTextBox({
    Key? key,
    required this.hintText,
    this.Controller

  }) : super(key: key);

  @override
   createState() => _PasswordTexBox();
}

class _PasswordTexBox extends State<PasswordTextBox> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          const Padding(
            padding:  EdgeInsets.all(8.0),
            child: Icon(Icons.lock,color:primaryColor,),
          ),
          Expanded(
            child: TextField(
              controller: widget.Controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ],
      ),
    );
  }
}