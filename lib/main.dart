// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/views/_mainView.dart';

import 'para/para.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Controller c = Get.put(Controller());
  
  @override
  void initState() {
    super.initState();
    // 检查登录
  }
  @override
  Widget build(BuildContext context) {
    return mainView();
  }
}
