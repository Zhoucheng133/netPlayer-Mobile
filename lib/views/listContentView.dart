// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class listContentView extends StatefulWidget {
  const listContentView({super.key});

  @override
  State<listContentView> createState() => _listContentViewState();
}

class _listContentViewState extends State<listContentView> {
  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("内容页，测试按钮"))),
    );
  }
}