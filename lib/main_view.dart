import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/operations/play_check.dart';
import 'package:netplayer_mobile/pages/index.dart';
import 'package:netplayer_mobile/pages/login.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'variables/user_var.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  bool loading=true;
  late SharedPreferences prefs;
  Account account=Account();
  final UserVar u = Get.put(UserVar());
  SettingsVar s=Get.put(SettingsVar());
  bool isLogin=false;
  late Worker accountListener;
  PlayerVar p=Get.put(PlayerVar());
  late Worker nowPlayListener;

  Future<void> savePlay(dynamic val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if(s.savePlay.value){
        await prefs.setString('nowPlay', jsonEncode(val));
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    accountListener=ever(u.url, (val){
      if(val.isEmpty){
        setState(() {
          isLogin=false;
        });
      }else{
        setState(() {
          isLogin=true;
        });
      }
    });
    nowPlayListener=ever(p.nowPlay, (val){
      savePlay(val);
      p.lyric.value=[
        {
          'time': 0,
          'content': '查找歌词中...',
        }
      ];
      Operations().getLyric();
    });
  }

  @override
  void dispose() {
    accountListener.dispose();
    nowPlayListener.dispose();
    super.dispose();
  }

  Future<bool> loginCheck() async {
    var autoLogin=prefs.getBool('autoLogin');
    if(autoLogin==false){
      s.autoLogin.value=false;
      return false;
    }
    var url=prefs.getString('url');
    var username=prefs.getString('username');
    var token=prefs.getString('token');
    var salt=prefs.getString('salt');
    if(url!=null && username!=null && token!=null && salt!=null){
      var resp=await account.login(url, username, token, salt);
      if(resp['ok']){
        u.username.value=username;
        u.salt.value=salt;
        u.url.value=url;
        u.token.value=token;
        return true;
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showOkAlertDialog(
            context: context,
            title: '自动登录失败',
            message: resp['data']
          );
        });
        return false;
      }
    }
    return false;
  }

  void nowPlaySet(){
    var savePlay=prefs.getBool('savePlay');
    if(savePlay==false){
      s.savePlay.value=false;
      return;
    }
    var nowPlay=prefs.getString('nowPlay');
    if(nowPlay!=null){
      Map<String, dynamic> decodedMap = jsonDecode(nowPlay);
      Map<String, Object> tmpList=Map<String, Object>.from(decodedMap);
      p.nowPlay.value=tmpList;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        PlayCheck().check(context);
      });
    }
  }

  void qualitySet(){
    var quality=prefs.getString('quality');
    // print(quality);
    if(quality!=null){
      final qualityJson=jsonDecode(quality);
      s.quality.value.cellularOnly=qualityJson['cellularOnly'];
      s.quality.value.quality=qualityJson['quality'];
    }
  }


  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if(await loginCheck()){
      nowPlaySet();
      qualitySet();
    }
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: u.url.value.isEmpty,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: loading ? Container(
          key: const ValueKey<int>(0),
          color: Colors.white,
        ) :
        isLogin ? const Index(key: ValueKey<int>(1),) : const Login(key: ValueKey<int>(2),),
      ),
    );
  }
}