import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/operations/play_check.dart';
import 'package:netplayer_mobile/pages/components/progress_dialog.dart';
import 'package:netplayer_mobile/pages/components/quality_dialog.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/pages/dev.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/download_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final DownloadVar downloadVar=Get.find();

  SettingsVar s=Get.find();
  int cacheSize=0;
  int downloadSize=0;
  bool loading=false;
  UserVar u = Get.find();
  PlayerVar p=Get.find();
  DialogVar d=Get.find();
  Account account=Account();

  @override
  void initState(){
    super.initState();
    getCacheSize();
    getDownloadSize();
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

  Future<void> getDownloadSize() async {
    try {
      final Directory downloadDir = await getApplicationDocumentsDirectory();
      var size = await getDirectorySize(Directory(path.join(downloadDir.path, 'downloads')));
      setState(() {
        downloadSize=size;
      });
    } catch (_) {
      setState(() {
        downloadSize=0;
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

  void clearDownload() async {
    Directory downloadDir = await getApplicationDocumentsDirectory();
    downloadDir=Directory(path.join(downloadDir.path, 'downloads'));
    if (downloadDir.existsSync()) {
      try {
        downloadDir.deleteSync(recursive: true);
      } catch (_) {}
    }
    await getDownloadSize();
    await downloadVar.getDownloadList();
  }

  String qualityText(){
    String text='';
    if(s.quality.value.cellularOnly){
      text+='${"cellularOnly".tr}: ';
    }
    text+=s.quality.value.quality==0 ? 'original'.tr : '${s.quality.value.quality.toString()} Kbps';
    return text;
  }

  Future<void> showQualityWarning(BuildContext context) async {
    final rlt=await d.showOkCancelDialog(
      context: context,
      title: 'noRecommendSetting'.tr,
      content: 'noRecommendSettingContent'.tr,
      okText: 'continue'.tr,
    );
    if(rlt){
      if(context.mounted){
        showQualityDialog(context);
      }
    }
  }

  String progresStyle(){
    if(s.progressStyle.value==ProgressStyle.off){
      return 'close'.tr;
    }else if(s.progressStyle.value==ProgressStyle.ring){
      return 'ring'.tr;
    }
    return 'background'.tr;
  }

  Future<void> showDarkModeDialog(BuildContext context) async {

    bool tmpDarkMode=s.darkMode.value;
    bool tmpAutoDark=s.autoDark.value;

    await d.showOkCancelDialogRaw(
      context: context, 
      title: 'darkMode'.tr, 
      child: Obx(()=>
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'followSystem'.tr,
                  style: TextStyle(
                    fontFamily: 'PuHui',
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
                  'darkMode'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PuHui',
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
            TitleArea(title: 'settings'.tr, subtitle: ' '),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FTileGroup(
                          label: Text(
                            'appSettings'.tr, 
                            style: TextStyle(
                              fontFamily: 'PuHui',
                            ),
                          ),
                          children: [
                            FTile(
                              title: Text(
                                'autoLogin'.tr, 
                                style: TextStyle(
                                  fontFamily: 'PuHui',
                                )
                              ),
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
                              title: Text(
                                'savePlay'.tr, 
                                style: TextStyle(
                                  fontFamily: 'PuHui',
                                )
                              ),
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
                            if(enableLyric) FTile(
                              title: Text(
                                'showTranslations'.tr, 
                                style: TextStyle(
                                  fontFamily: 'PuHui',
                                )
                              ),
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
                              subtitle: Text('showTranslationsIfExist'.tr, style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                fontFamily: 'PuHui'
                              )),
                            ),
                            FTile(
                              title: Text(
                                'enableNavidromeAPI'.tr, 
                                style: TextStyle(
                                  fontFamily: 'PuHui'
                                )
                              ),
                              details: Obx(()=>
                                FSwitch(
                                  value: p.useNavidrome.value, 
                                  onChange: (val) async {
                                    if(val){
                                      final ok=await d.showOkCancelDialog(
                                        context: context, 
                                        title: "enableNavidromeAPI".tr, 
                                        content: "useNavidromeApiFirst".tr,
                                        okText: u.password.value.isEmpty ? "enableAndRestart".tr : "continue".tr,
                                        cancelText: "cancel".tr
                                      );
                                      if(ok && u.password.value.isEmpty){
                                        account.logout();
                                        if(context.mounted) Navigator.pop(context);
                                      }else if(!ok){
                                        return;
                                      }
                                    }
                                    p.useNavidrome.value=val;
                                    final prefs=await SharedPreferences.getInstance();
                                    prefs.setBool("useNavidrome", val);
                                  }
                                )
                              ),
                              subtitle: Text('showAllSongsAndAlbums'.tr, style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                fontFamily: 'PuHui'
                              )),
                            ),
                            FTile(
                              title: Text('ignoreMissing'.tr, style: TextStyle(
                                fontFamily: 'PuHui'
                              )),
                              details: Obx(()=>
                                FSwitch(
                                  value: p.removeMissing.value, 
                                  onChange: p.useNavidrome.value ? (val) async {
                                    p.removeMissing.value=val;
                                    final prefs=await SharedPreferences.getInstance();
                                    prefs.setBool("removeMissing", val);
                                    if(p.nowPlay['playFrom']=="all" && context.mounted){
                                      PlayCheck().check(context);
                                    }
                                  } : null,
                                )
                              ),
                              subtitle: Text('avaliableForNavidromeApi'.tr, style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                fontFamily: 'PuHui'
                              )),
                            ),
                            FTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('language'.tr, style: TextStyle(
                                    fontFamily: 'PuHui'
                                  )),
                                  const SizedBox(width: 5,),
                                  const FaIcon(
                                    FontAwesomeIcons.globe,
                                    size: 14,
                                  )
                                ],
                              ),
                              subtitle: Text(
                                s.lang.value.name, 
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                  fontFamily: 'PuHui'
                                ),
                              ),
                              onPress: () => s.showLanguageDialog(context),
                            ),
                            if(enableLyric) FTile(
                              onPress: ()=>showQualityWarning(context),
                              title: Text(
                                'playQuality'.tr,
                                style: TextStyle(
                                  fontFamily: 'PuHui'
                                ),
                              ),
                              subtitle: Obx(()=>
                                Text(
                                  qualityText(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'PuHui',
                                    color: Colors.grey[400]
                                  ),
                                ),
                              ),
                            ),
                            FTile(
                              onPress: () async {
                                final rlt=await d.showOkCancelDialog(
                                  context: context, 
                                  title: 'clearCache'.tr, 
                                  content: 'noAffectForUse'.tr, 
                                  okText: 'continue'.tr,
                                );
                                if(rlt){
                                  clearController();
                                }
                              },
                              title: Text(
                                'clearCache'.tr,
                                style: TextStyle(
                                  fontFamily: 'PuHui'
                                ),
                              ),
                              subtitle: Text(
                                sizeConvert(cacheSize),
                                style: TextStyle(
                                  fontFamily: 'PuHui',
                                  fontSize: 12,
                                  color: Colors.grey[400]
                                ),
                              ),
                            ),
                          ]
                        ),
                        FTileGroup(
                          label: Text('apperanceSettings'.tr, style: TextStyle(),),
                          children: [
                            FTile(
                              onPress: ()=>showDarkModeDialog(context),
                              title: Text('darkMode'.tr,style: TextStyle(
                                fontFamily: 'PuHui'
                              ),),
                              subtitle: Obx(()=>
                                Text(
                                  s.autoDark.value ? 'auto'.tr : s.darkMode.value ? 'enable'.tr : 'disable'.tr,
                                  style: TextStyle(
                                    fontFamily: 'PuHui',
                                    fontSize: 12,
                                    color: Colors.grey[400]
                                  ),
                                )
                              ),
                            ),
                            FTile(
                              onPress: ()=>showProgressDialog(context),
                              title: Text(
                                'progressbarStyle'.tr,
                                style: TextStyle(
                                  fontFamily: 'PuHui'
                                ),
                              ),
                              subtitle: Obx(()=>
                                Text(
                                  progresStyle(),
                                  style: TextStyle(
                                    fontFamily: 'PuHui',
                                    fontSize: 12,
                                    color: Colors.grey[400]
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ),
                        FTileGroup(
                          label: Text('others'.tr, style: TextStyle(
                            fontFamily: 'PuHui'
                          ),),
                          children: [
                            FTile(
                              onPress: () async {
                                final rlt=await d.showOkCancelDialog(
                                  context: context, 
                                  title: 'deleteAllDownloadedSongs'.tr, 
                                  content: 'deleteAllDownloadedSongsContent'.tr, 
                                  okText: 'delete'.tr,
                                );
                                if(rlt){
                                  clearDownload();
                                }
                              },
                              title: Text("deleteAllDownloadedSongs".tr, style: TextStyle(
                                fontFamily: 'PuHui'
                              ),),
                              subtitle: Text(
                                sizeConvert(downloadSize),
                                style: TextStyle(
                                  fontFamily: 'PuHui',
                                  fontSize: 12,
                                  color: Colors.grey[400]
                                ),
                              ),
                            ),
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
                              title: Text('rescanLibrary'.tr, style: TextStyle(
                                fontFamily: 'PuHui'
                              ),),
                              subtitle: Text(
                                "rescanLibraryContent".tr, 
                                style: TextStyle(
                                  fontFamily: 'PuHui',
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
                              title: Text('devTool'.tr, style: TextStyle(
                                fontFamily: 'PuHui'
                              ),),
                              onPress: ()=>Get.to(()=>const Dev()),
                            ),
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