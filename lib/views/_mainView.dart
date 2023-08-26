// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Text("退出登录"),
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          c.updatePlayInfo({});
          c.updateLogin(false);
        },
      ),
    );
  }
}