// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/page_var.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {

  PageVar p=Get.put(PageVar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          }, 
          icon: Icon(Icons.arrow_left)
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: (){
            p.showPlayingBar.value=!p.showPlayingBar.value;
          }, 
          child: Text("xxxx")
        )
      ),
    );
  }
}