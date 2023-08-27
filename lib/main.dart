// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/_mainView.dart';
import 'package:netplayer_mobile/views/loginView.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  Future<void> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('userInfo');
    if(userData!=null){
      c.updateLogin(true);
      Map<String,dynamic> decodeUserData = json.decode(userData);
      c.updatePlayInfo(decodeUserData);
    }
  }
  
  @override
  void initState() {
    super.initState();
    // 检查登录
    checkLogin();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      home: Scaffold(
        body: Obx(() => 
          c.isLogin==true ? mainView() : loginView()
        ),
      ),
    );
  }
}
