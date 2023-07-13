import 'package:flutter/material.dart';
import 'package:frontend/widgets/NamewithPhoto.dart';

class ResultDialog extends StatelessWidget {
  final String content;

  ResultDialog({required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Match Result'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           NameWithPhoto(name: "${(content.split(' ')?[0] ?? '')}",size: 40),
           SizedBox(width: 10,),
           Text('$content'),
        ],
      ),

    );
  }
}
