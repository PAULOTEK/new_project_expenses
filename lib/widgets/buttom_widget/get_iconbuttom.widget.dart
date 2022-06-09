import 'dart:io';

import 'package:flutter/material.dart';

class GetIconButtom extends StatelessWidget {
  const GetIconButtom({Key? key, required this.icon, required this.functionn}) : super(key: key);
  final IconData icon;
  final Function functionn;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: () => functionn,
            child: Icon(icon),
          )
        : IconButton(
            onPressed: () => functionn,
            icon: Icon(icon),
          );
  }
}
