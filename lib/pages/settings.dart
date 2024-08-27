import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  SettingsVar s=Get.put(SettingsVar());
  int cacheSize=0;
  bool loading=false;

  @override
  void initState(){
    super.initState();
    getCacheSize();
  }

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
      try {
        cacheDir.deleteSync(recursive: true);
      } catch (_) {}
    }
    getCacheSize();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          const TitleAria(title: '设置', subtitle: ' '),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    '自动登录',
                    style: GoogleFonts.notoSansSc(
                      // fontSize: 18
                    ),
                  ),
                  trailing: Obx(()=>
                    Switch(
                      activeTrackColor: Colors.blue,
                      value: s.autoLogin.value, 
                      onChanged: (val) async {
                        // setState(() {
                        //   enableAutoLogin=val;
                        // });
                        s.autoLogin.value=val;
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('autoLogin', val);
                      }
                    )
                  ),
                ),
                ListTile(
                  title: Text(
                    '保存上次播放位置',
                    style: GoogleFonts.notoSansSc(
                      // fontSize: 18
                    ),
                  ),
                  trailing: Obx(()=>
                    Switch(
                      activeTrackColor: Colors.blue,
                      value: s.savePlay.value, 
                      onChanged: (val) async {
                        s.savePlay.value=val;
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('savePlay', val);
                      }
                    )
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final rlt=await showOkCancelAlertDialog(
                      context: context,
                      okLabel: "继续",
                      title: "清理缓存",
                      message: "这不会影响你的使用",
                      cancelLabel: "取消"
                    );
                    if(rlt==OkCancelResult.ok){
                      clearController();
                    }
                  },
                  title: Text(
                    '清理缓存',
                    style: GoogleFonts.notoSansSc(
                      // fontSize: 18
                    ),
                  ),
                  trailing: Text(
                    sizeConvert(cacheSize),
                    style: GoogleFonts.notoSansSc(
                      fontSize: 12,
                      color: Colors.grey[400]
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    setState(() {
                      loading=true;
                    });
                    await Operations().refreshLibrary(context);
                    setState(() {
                      loading=false;
                    });
                  },
                  title: Text('更新音乐库', style: GoogleFonts.notoSansSc(),),
                  trailing: loading ? Transform.scale(
                    scale: 0.6,
                    child: const CircularProgressIndicator()
                  ) : null,
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}