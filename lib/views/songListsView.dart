// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, invalid_use_of_protected_member, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/listContentView.dart';

class songListsView extends StatefulWidget {
  const songListsView({super.key});

  @override
  State<songListsView> createState() => _songListsViewState();
}

class _songListsViewState extends State<songListsView> {
  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => listContentView())
          );
        }, 
        child: Text("测试按钮"),
      ),
    );
  }
}