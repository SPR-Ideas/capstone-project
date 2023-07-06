import 'dart:math';

import 'package:flutter/material.dart';

class NameWithPhoto extends StatelessWidget {
  final String name;
  final double size;

  const NameWithPhoto({
    Key? key,
    required this.name,
    this.size = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final random = Random();
    final color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      final firstNameInitial = names[0][0];
      final lastNameInitial = names[1][0];
      return '$firstNameInitial$lastNameInitial';
    } else {
      return names[0][0];
    }
  }
}
