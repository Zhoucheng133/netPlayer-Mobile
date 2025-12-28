import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/pages/components/dev_tool.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dev extends StatefulWidget {
  const Dev({super.key});

  @override
  State<Dev> createState() => _DevState();
}

class _DevState extends State<Dev> {

  SettingsVar s=Get.find();
  PlayerVar p=Get.find();
  UserVar u = Get.find();
  DialogVar d=Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness==Brightness.dark ? s.bgColor2 : Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness==Brightness.dark ? s.bgColor1 : Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('devTool'.tr, style: TextStyle(),)
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FTileGroup(
                  label: Text('status'.tr, style: TextStyle()),
                  children: [
                    FTile(
                      title: Text("playStatus".tr, style: TextStyle(),),
                      onPress: () async {
                        if(p.nowPlay['id']==''){
                          d.showOkDialog(
                            context: context, 
                            title: "playStatus".tr, 
                            content: "noplaying".tr,
                            okText: "ok".tr,
                          );
                          return;
                        }
                        final data=await httpRequest("${u.url.value}/rest/getSong?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay['id']}");
                          if(context.mounted){
                            d.showOkDialogRaw(
                              context: context, 
                              title: 'playStatus'.tr,
                              child: DevTool(data: data,),
                            );
                          }
                      },
                    ),
                  ],
                ),
                FTileGroup(
                  label: Text("storage".tr, style: TextStyle(),),
                  children: [
                    FTile(
                      title: Text("localStorage".tr, style: TextStyle(),),
                      subtitle: Text("SharedPreference", style: TextStyle(),),
                      onPress: () async {
                        final prefs=await SharedPreferences.getInstance();
                        if(context.mounted){
                          d.showOkDialog(
                          context: context, 
                          title: "localStorage".tr, 
                          content: """# ${"userData".tr}
${"username".tr}: ${prefs.getString("username")}
${"password".tr}: ${prefs.getString("password")}
salt: ${prefs.getString("salt")}
token: ${prefs.getString("token")}
————————————
# 设置
${"autoLogin".tr}: ${prefs.getBool("autoLogin")}
${"savePlay".tr}: ${prefs.getBool("savePlay")}
${"enableNavidromeAPI".tr}: ${prefs.getBool("useNavidrome")}
${"autoDark".tr}: ${prefs.getBool("autoDark")}
${"darkMode".tr}: ${prefs.getBool("darkMode")}
${"showTranslations".tr}: ${prefs.getBool("showTranslation")}
${"progressbarStyle".tr}: ${prefs.getInt("progressStyle")}
${"playQuality".tr}: ${prefs.getString("quality")}
${"ignoreMissing".tr}: ${prefs.getBool("removeMissing")}
————————————
# ${"playlist".tr}
${"playMode".tr}: ${prefs.getString("playMode")}
${"lyricFontSize".tr}: ${prefs.getInt("fontSize")}
"""
                          );
                        }
                      },
                    ),
                    FTile(
                      title: Text("usePreviousStorage".tr, style: TextStyle(),),
                      subtitle: Text("clearPasswordAndUseNavidrome".tr),
                      onPress: () async {
                        final prefs=await SharedPreferences.getInstance();
                        prefs.remove("useNavidrome");
                        prefs.remove("password");
                        if(context.mounted){
                          d.showOkDialog(
                            context: context, 
                            title: "clearFinished".tr, 
                            content: "clearFinished".tr
                          );
                        }
                      },
                    ),
                    FTile(
                      title: Text("clearAllStorage".tr, style: TextStyle(),),
                      subtitle: Text("clearConfig".tr),
                      onPress: () async {
                        final prefs=await SharedPreferences.getInstance();
                        prefs.clear();
                        if(context.mounted){
                          d.showOkDialog(
                            context: context, 
                            title: "clearFinished".tr, 
                            content: "clearFinished".tr
                          );
                        }
                      },
                    )
                  ]
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}