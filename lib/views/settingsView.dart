// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/aboutView.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class settingsView extends StatefulWidget {
  const settingsView({super.key});

  @override
  State<settingsView> createState() => _settingsViewState();
}

class _settingsViewState extends State<settingsView> {

  final Controller c = Get.put(Controller());

  Future<void> noAutoLogin() async {
    c.autoLogin.value=false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autologin', false);
  }

  Future<void> autoLoginHandler(bool value) async {
    if(value==false){
      if(Platform.isIOS){
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("关闭自动登录?"),
              content: Text("这需要每次打开应用手动登录"),
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
                    noAutoLogin();
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
              title: Text("关闭自动登录需要每次手动登录，是否继续?"),
              content: Text("这需要每次打开应用手动登录"),
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
                    noAutoLogin();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    }else{
      c.autoLogin.value=value;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('autologin', true);
    }
  }

  void savePlayHandler(bool value){
    c.savePlay.value=value;
    // TODO 保存上次播放记录
  }
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
  final myScrollController=ScrollController();
  
  @override
  void initState() {
    getVersion();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: myScrollController,
      child: ListView(
        controller: myScrollController,
        children: [
          ListTile(
            title: Text("保存上次播放的歌曲"),
            trailing: Obx(() => 
              Platform.isIOS ?
              CupertinoSwitch(
                value: c.savePlay.value, 
                onChanged: (value){
                  savePlayHandler(value);
                }
              ):
              Switch(
                value: c.savePlay.value, 
                onChanged: (value){
                  savePlayHandler(value);
                }
              )
            )
          ),
          ListTile(
            title: Text("自动登录"),
            trailing: Obx(() => 
              Platform.isIOS ?
              CupertinoSwitch(
                value: c.autoLogin.value, 
                onChanged: (value){
                  autoLoginHandler(value);
                }
              ):
              Switch(
                value: c.autoLogin.value, 
                onChanged: (value){
                  autoLoginHandler(value);
                }
              )
            )
          ),
          ListTile(
            title: Text("退出登录"),
            onTap: (){
              logoutController(context);
            },
          ),
          ListTile(
            title: Text("关于"),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => aboutView()),
              );
            },
          )
        ],
      )
    );
  }
}