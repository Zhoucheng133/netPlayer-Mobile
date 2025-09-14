import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
          child: Text('开发者工具', style: GoogleFonts.notoSansSc(),)
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
                  label: Text('本地', style: GoogleFonts.notoSansSc()),
                  children: [
                    FTile(
                      title: Text("本地存储", style: GoogleFonts.notoSansSc(),),
                      subtitle: Text("SharedPreference 存储", style: GoogleFonts.notoSansSc(),),
                      onPress: () async {
                        final prefs=await SharedPreferences.getInstance();
                        if(context.mounted){
                          d.showOkDialog(
                          context: context, 
                          title: "本地存储", 
                          content: """# 用户信息
用户: ${prefs.getString("username")}
密码: ${prefs.getString("password")}
salt: ${prefs.getString("salt")}
token: ${prefs.getString("token")}
————————————
# 设置
自动登录: ${prefs.getBool("autoLogin")}
保存播放: ${prefs.getBool("savePlay")}
使用NavidromeAPI: ${prefs.getBool("useNavidrome")}
自动暗色模式: ${prefs.getBool("autoDark")}
启用暗色模式: ${prefs.getBool("darkMode")}
显示翻译: ${prefs.getBool("showTranslation")}
进度条模式: ${prefs.getInt("progressStyle")}
播放音质: ${prefs.getString("quality")}
忽略失效文件: ${prefs.getBool("removeMissing")}
————————————
# 播放
播放模式: ${prefs.getString("playMode")}
歌词大小: ${prefs.getInt("fontSize")}
"""
                        );
                        }
                      },
                    ),
                    FTile(
                      title: Text("播放状态", style: GoogleFonts.notoSansSc(),),
                      onPress: () async {
                        if(p.nowPlay['id']==''){
                          d.showOkDialog(
                            context: context, 
                            title: "播放状态", 
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
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}