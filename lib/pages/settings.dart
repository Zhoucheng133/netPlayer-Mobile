import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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

  Future<void> showDarkModeDialog(BuildContext context) async {

    bool tmpDarkMode=s.darkMode.value;
    bool tmpAutoDark=s.autoDark.value;

    await d.showOkCancelDialogRaw(
      context: context, 
      title: '深色模式', 
      child: Obx(()=>
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  '跟随系统',
                  style: GoogleFonts.notoSansSc(
                    fontSize: 16,
                  ),
                ),
                Expanded(child: Container()),
                FSwitch(
                  value: s.autoDark.value, 
                  onChange: (val){
                    s.autoDark.value=val;
                    final Brightness brightness = MediaQuery.of(context).platformBrightness;
                    s.autoDarkMode(brightness==Brightness.dark);
                  }
                )
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Text(
                  '启用深色模式',
                  style: GoogleFonts.notoSansSc(
                    fontSize: 16,
                  ),
                ),
                Expanded(child: Container()),
                FSwitch(
                  value: s.darkMode.value, 
                  onChange: s.autoDark.value ? null : (val){
                    s.darkMode.value=val;
                  }
                )
              ],
            )
          ],
        )
      ), 
      okHandler: () async {
        final prefs=await SharedPreferences.getInstance();
        prefs.setBool('autoDark', s.autoDark.value);
        prefs.setBool('darkMode', s.darkMode.value);
      },
      cancelHandler: (){
        s.darkMode.value=tmpDarkMode;
        s.autoDark.value=tmpAutoDark;
      },
      okText: '完成',
    );
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FTileGroup(
                          label: Text('App 设置', style: GoogleFonts.notoSansSc(),),
                          children: [
                            FTile(
                              title: Text('自动登录', style: GoogleFonts.notoSansSc()),
                              details: Obx(()=>
                                FSwitch(
                                  value: s.autoLogin.value,
                                  onChange: (val) async {
                                    s.autoLogin.value=val;
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setBool('autoLogin', val);
                                  }
                                ),
                              ),
                            ),
                            FTile(
                              title: Text('保存上次播放位置', style: GoogleFonts.notoSansSc()),
                              details: Obx(()=>
                                FSwitch(
                                  value: s.savePlay.value, 
                                  onChange: (val) async {
                                    s.savePlay.value=val;
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setBool('savePlay', val);
                                  }
                                )
                              ),
                            ),
                            FTile(
                              title: Text('显示歌词翻译', style: GoogleFonts.notoSansSc()),
                              details: Obx(()=>
                                FSwitch(
                                  value: s.showTranslation.value, 
                                  onChange: (val) async {
                                    s.showTranslation.value=val;
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setBool('showTranslation', val);
                                  }
                                )
                              ),
                              subtitle: Text('如果存在歌词翻译则显示', style: GoogleFonts.notoSansSc(
                                fontSize: 12,
                                color: Colors.grey[400]
                              )),
                            ),
                            FTile(
                              onPress: ()=>showQualityWarning(context),
                              title: Text(
                                '播放音质',
                                style: GoogleFonts.notoSansSc(),
                              ),
                              subtitle: Obx(()=>
                                Text(
                                  qualityText(),
                                  style: GoogleFonts.notoSansSc(
                                    fontSize: 12,
                                    color: Colors.grey[400]
                                  ),
                                ),
                              ),
                            ),
                            FTile(
                              onPress: () async {
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
                              subtitle: Text(
                                sizeConvert(cacheSize),
                                style: GoogleFonts.notoSansSc(
                                  fontSize: 12,
                                  color: Colors.grey[400]
                                ),
                              ),
                            ),
                          ]
                        ),
                        FTileGroup(
                          label: Text('外观设置', style: GoogleFonts.notoSansSc(),),
                          children: [
                            FTile(
                              onPress: ()=>showDarkModeDialog(context),
                              title: Text(
                                '深色模式',
                                style: GoogleFonts.notoSans(),
                              ),
                              subtitle: Obx(()=>
                                Text(
                                  s.autoDark.value ? '自动' : s.darkMode.value ? '开启' : '关闭',
                                  style: GoogleFonts.notoSansSc(
                                    fontSize: 12,
                                    color: Colors.grey[400]
                                  ),
                                )
                              ),
                            ),
                            FTile(
                              onPress: ()=>showProgressDialog(context),
                              title: Text(
                                '播放栏显示进度',
                                style: GoogleFonts.notoSansSc(),
                              ),
                              subtitle: Obx(()=>
                                Text(
                                  progresStyle(),
                                  style: GoogleFonts.notoSansSc(
                                    fontSize: 12,
                                    color: Colors.grey[400]
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ),
                        FTileGroup(
                          label: Text('其它', style: GoogleFonts.notoSansSc(),),
                          children: [
                            FTile(
                              onPress: () async {
                                setState(() {
                                  loading=true;
                                });
                                await Operations().refreshLibrary(context);
                                setState(() {
                                  loading=false;
                                });
                              },
                              title: Text('重新扫描音乐库', style: GoogleFonts.notoSansSc(),),
                              subtitle: Text(
                                "手动扫描音乐库中的所有文件", 
                                style: GoogleFonts.notoSansSc(
                                  fontSize: 12,
                                  color: Colors.grey[400]
                                ),
                              ),
                              details: loading ? Transform.scale(
                                scale: 0.6,
                                child: const CircularProgressIndicator()
                              ) : null,
                            ),
                            FTile(
                              title: Text('开发者工具', style: GoogleFonts.notoSansSc(),),
                              onPress: () async {
                                if(p.nowPlay['id']==''){
                                  d.showOkDialog(
                                    context: context, 
                                    title: "开发者工具", 
                                    content: "当前没有在播放",
                                    okText: "好的",
                                  );
                                  return;
                                }
                                final data=await httpRequest("${u.url.value}/rest/getSong?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay['id']}");
                                if(context.mounted){
                                  d.showOkDialogRaw(
                                    context: context, 
                                    title: '开发者工具',
                                    child: DevTool(data: data,),
                                  );
                                }
                              },
                            )
                          ]
                        )
                      ],
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}