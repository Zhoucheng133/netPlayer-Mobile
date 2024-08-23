import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/account.dart';
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
  }

  @override
  void dispose() {
    accountListener.dispose();
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
        // TODO 检查顺序
      });
    }
  }


  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if(await loginCheck()){
      nowPlaySet();
    }
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: u.url.value.isEmpty,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: loading ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.beat(
                color: Colors.blue, 
                size: 30
              ),
              const SizedBox(height: 10,),
              const Text('加载中')
            ],
          ),
        ) : isLogin ? const Index() : const Login(),
      ),
    );
  }
}