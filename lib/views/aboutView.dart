// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class aboutView extends StatefulWidget {
  const aboutView({super.key});

  @override
  State<aboutView> createState() => _aboutViewState();
}

class _aboutViewState extends State<aboutView> {

  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icon.png",
            height: 100,
            width: 100,
          ),
          SizedBox(height: 10,),
          Text(
            "netPlayer Mobile",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}