// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:package_info_plus/package_info_plus.dart';


class aboutView extends StatefulWidget {
  const aboutView({super.key});

  @override
  State<aboutView> createState() => _aboutViewState();
}

class _aboutViewState extends State<aboutView> {

  final Controller c = Get.put(Controller());
  void logoutController(BuildContext context){
    if(Platform.isIOS){
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("确定要退出登录吗?"),
            content: Text("退出登录后会回到登录界面"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('确定'),
                onPressed: () {
                  c.updateLogin(false);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("确定要退出登录吗?"),
            content: Text("退出登录后会回到登录界面"),
            actions: <Widget>[
              TextButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('确定'),
                onPressed: () {
                  c.updateLogin(false);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version=packageInfo.version;
    });
  }
  
  String version="";
  
  @override
  void initState() {
    getVersion();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
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
              ),
              SizedBox(height: 8,),
              Text(
                // c.version.value,
                version,
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          child: SizedBox(
            // height: 40,
            width: MediaQuery.of(context).size.width,
            // color: Colors.red,
            child: Center(
              child: GestureDetector(
                onTap: (){
                  logoutController(context);
                },
                child: Text(
                  "注销当前账户",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ),
          ),
        )
      ]
    );
  }
}