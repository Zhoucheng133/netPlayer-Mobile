import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/pages/components/dev_tool.dart';
import 'package:netplayer_mobile/pages/components/progress_dialog.dart';
import 'package:netplayer_mobile/pages/components/quality_dialog.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  SettingsVar s=Get.find();
  int cacheSize=0;
  bool loading=false;
  UserVar u = Get.find();
  PlayerVar p=Get.find();
  DialogVar d=Get.find();

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

  String qualityText(){
    String text='';
    if(s.quality.value.cellularOnly){
      text+='仅移动网络: ';
    }
    text+=s.quality.value.quality==0 ? '原始' : '${s.quality.value.quality.toString()} Kbps';
    return text;
  }

  Future<void> showQualityWarning(BuildContext context) async {
    final rlt=await d.showOkCancelDialog(
      context: context,
      title: '注意!',
      content: '如果指定非原始音质，第一次播放可能会导致无法使用时间轴定位歌曲\n对于FLAC格式的高码率歌曲第一次播可能没有声音(取决于音乐服务器的转码速度)',
      okText: '继续',
      cancelText: '取消'
    );
    if(rlt){
      if(context.mounted){
        showQualityDialog(context);
      }
    }
  }

  String progresStyle(){
    if(s.progressStyle.value==ProgressStyle.off){
      return '关闭';
    }else if(s.progressStyle.value==ProgressStyle.ring){
      return '环状';
    }
    return '背景色';
  }


  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: s.darkMode.value ? s.bgColor2 : Colors.white,
        appBar: AppBar(
          backgroundColor: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
          scrolledUnderElevation:0.0,
          toolbarHeight: 70,
        ),
        body: Column(
          children: [
            const TitleArea(title: '设置', subtitle: ' '),
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
                      style: GoogleFonts.notoSansSc(),
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
                    onTap: ()=>s.showDarkModeDialog(context),
                    title: Text(
                      '深色模式',
                      style: GoogleFonts.notoSans(),
                    ),
                    trailing: Obx(()=>
                      Text(
                        s.autoDark.value ? '自动' : s.darkMode.value ? '开启' : '关闭',
                        style: GoogleFonts.notoSansSc(
                          fontSize: 12,
                          color: Colors.grey[400]
                        ),
                      )
                    ),
                  ),
                  ListTile(
                    onTap: ()=>showQualityWarning(context),
                    title: Text(
                      '播放音质',
                      style: GoogleFonts.notoSansSc(),
                    ),
                    trailing: Obx(()=>
                      Text(
                        qualityText(),
                        style: GoogleFonts.notoSansSc(
                          fontSize: 12,
                          color: Colors.grey[400]
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: ()=>showProgressDialog(context),
                    title: Text(
                      '播放栏显示进度',
                      style: GoogleFonts.notoSansSc(),
                    ),
                    trailing: Obx(()=>
                      Text(
                        progresStyle(),
                        style: GoogleFonts.notoSansSc(
                          fontSize: 12,
                          color: Colors.grey[400]
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      final rlt=await d.showOkCancelDialog(
                        context: context, 
                        title: '清理缓存', 
                        content: '这不会影响你的使用', 
                        okText: '继续'
                      );
                      if(rlt){
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
                    title: Text('重新扫描音乐库', style: GoogleFonts.notoSansSc(),),
                    trailing: loading ? Transform.scale(
                      scale: 0.6,
                      child: const CircularProgressIndicator()
                    ) : null,
                  ),
                  ListTile(
                    title: Text('开发者工具', style: GoogleFonts.notoSansSc(),),
                    onTap: () async {
                      if(p.nowPlay['id']==''){
                        return;
                      }
                      final data=await httpRequest("${u.url.value}/rest/getSong?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay['id']}");
                      // print(data);
                      if(context.mounted){
                        showDialog(
                          context: context, 
                          builder: (context)=>AlertDialog(
                            title: const Text('开发者工具'),
                            content: DevTool(data: data,),
                            actions: [
                              TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                }, 
                                child: const Text('完成')
                              )
                            ],
                          )
                        );
                      }
                    },
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}