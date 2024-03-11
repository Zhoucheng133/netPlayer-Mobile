// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/aboutView.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<void> savePlayHandler(bool value) async {
    c.savePlay.value=value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('savePlay', value);
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
  int cacheSize=0;

  String sizeConvert(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    }
  }

  Future<int> getDirectorySize(Directory path) async {
    int size = 0;
    for (var entity in path.listSync(recursive: true)) {
      if (entity is File) {
        size += entity.lengthSync();
      }
    }
    return size;
  }

  Future<void> getCacheSize() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      var size = await getDirectorySize(tempDir);
      setState(() {
        cacheSize=size;
      });
    } catch (_) {
      setState(() {
        cacheSize=0;
      });
    }
  }

  Future<void> clearController() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
      cacheSize=0;
    }
  }

  Future<void> clearCache(BuildContext context) async {
    if(Platform.isIOS){
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('清理歌曲封面缓存?'),
            content: Text('这不会对程序运行产生影响'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('确定'),
                onPressed: () {
                  clearController();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('清理歌曲封面缓存?'),
            content: Text('这不会对程序运行产生影响'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: Text("取消")
              ),
              FilledButton(
                onPressed: () async {
                  clearController();
                  Navigator.pop(context);
                }, 
                child: Text("确定")
              ),
            ],
          );
        },
      );
    }
  }

  
  @override
  void initState() {
    getVersion();

    getCacheSize();

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
            title: Text(
              "退出登录",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: (){
              logoutController(context);
            },
          ),
          ListTile(
            onTap: () => clearCache(context),
            title: Text(
              "清理歌曲封面缓存"
            ),
            trailing: Text(sizeConvert(cacheSize)),
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