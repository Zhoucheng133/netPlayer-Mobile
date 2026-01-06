import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/operations/play_check.dart';
import 'package:netplayer_mobile/pages/download.dart';
import 'package:netplayer_mobile/pages/index.dart';
import 'package:netplayer_mobile/pages/login.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
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
  final UserVar u = Get.find();
  final DialogVar dialog=Get.find();
  SettingsVar s=Get.find();
  bool isLogin=false;
  late Worker accountListener;
  PlayerVar p=Get.find();
  late Worker nowPlayListener;
  Operations operations=Operations();
  String? preId;
  final d=DataGet();

  Future<void> savePlay(Map val) async {
    val.remove('list');
    prefs = await SharedPreferences.getInstance();
    try {
      if(s.savePlay.value){
        await prefs.setString('nowPlay', jsonEncode(val));
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPrefs(context);
    });
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
      if(preId!=null && p.nowPlay['id']==preId){
        return;
      }
      if(p.nowPlay['id']!=null && p.nowPlay['id'].isNotEmpty){
        preId=p.nowPlay['id'];
      }

      savePlay(val);
      p.lyric.value=[
        LyricItem('searchingForLyrics'.tr, "", 0)
      ];
      operations.getLyric();
    });
  }

  @override
  void dispose() {
    accountListener.dispose();
    nowPlayListener.dispose();
    subscription.cancel();
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
    var password=prefs.getString("password");
    if(url!=null && username!=null && token!=null && salt!=null){
      var resp=await account.login(url, username, token, salt);
      if(resp['ok']){
        u.username.value=username;
        u.salt.value=salt;
        u.url.value=url;
        u.token.value=token;
        u.password.value=password??"";
        return true;
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final req=await dialog.showOkCancelDialog(
            context: context, 
            title: 'autoLoginFailed'.tr, 
            content: resp['data'],
            okText: 'ok'.tr,
            cancelText: "downloaded".tr
          );
          if(!req){
            Get.off(()=>Download());
          }
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
      p.nowPlay.value={...tmpList, 'list': []} as Map<String, dynamic>;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        PlayCheck().check(context);
      });
      try {
        if(tmpList['playFrom']=='fullRandom'){
          p.playMode.value='random';
        }else{
          final mode=prefs.getString('playMode');
          if(mode!=null){
            p.playMode.value=mode;
          }
        }
      } catch (_) {}
    }
  }

  void qualitySet(){
    var quality=prefs.getString('quality');
    if(quality!=null){
      final qualityJson=jsonDecode(quality);
      s.quality.value.cellularOnly=qualityJson['cellularOnly'];
      s.quality.value.quality=qualityJson['quality'];
    }
  }

  final Connectivity connectivity = Connectivity();

  Future<void> networkSet() async {
    var connectivityResult = await connectivity.checkConnectivity();
    if(connectivityResult.contains(ConnectivityResult.mobile)){
      s.wifi.value=false;
      s.wifi.refresh();
    }
  }

  late StreamSubscription<List<ConnectivityResult>> subscription;

  void lyricSet(){
    final fontSize=prefs.getInt('fontSize');
    if(fontSize!=null){
      p.fontSize.value=fontSize;
    }
  }

  void progressSet(){
    final style=prefs.getInt('progressStyle');
    if(style!=null){
      s.progressStyle.value=ProgressStyle.values[style];
    }
  }

  void translateSet(){
    final showTranslation=prefs.getBool('showTranslation');
    if(showTranslation!=null){
      s.showTranslation.value=showTranslation;
    }
  }

  Future<bool> navidromeSet(BuildContext context) async {

    bool? removeMissing=prefs.getBool("removeMissing");
    if(removeMissing==false){
      p.removeMissing.value=false;
    }

    bool? useNavidrome=prefs.getBool("useNavidrome");
    String? password=prefs.getString("password");
    String? username=prefs.getString("username");
    if(useNavidrome==null && password==null && username!=null){
      final useNavidrome=await dialog.showOkCancelDialog(
        context: context, 
        title: "enableNavidromeAPI".tr, 
        content: "enableNavidromeAPIContent".tr,
        okText: "enableAndRestart".tr,
        cancelText: "disabled".tr
      );
      if(useNavidrome){
        p.useNavidrome.value=true;
        prefs.setBool("useNavidrome", true);
        account.logout();
        return true;
      }else{
        p.useNavidrome.value=false;
        prefs.setBool("useNavidrome", false);
        return false;
      }
    }
    if(useNavidrome==null && password!=null){
      prefs.setBool("useNavidrome", true);
    }
    p.useNavidrome.value=useNavidrome??true;
    return false;
  }

  Future<void> initPrefs(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    if(context.mounted){
      bool toLogin = await navidromeSet(context);
      if(toLogin){
        setState(() {
          loading=false;
        });
        return;
      }
    }
    if(await loginCheck()){
      nowPlaySet();
      qualitySet();
      progressSet();
      lyricSet();
      translateSet();
    }
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if(result.contains(ConnectivityResult.mobile)){
        s.wifi.value=false;
        s.wifi.refresh();
      }else{
        s.wifi.value=true;
        s.wifi.refresh();
      }
    });
    await networkSet();
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: s.darkMode.value ? s.bgColor2 : Colors.grey[50],
        resizeToAvoidBottomInset: u.url.value.isEmpty,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: loading ? Center(
            key: const ValueKey<int>(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.beat(
                  color: Colors.blue, 
                  size: 30
                ),
                const SizedBox(height: 10,),
                Text('loading'.tr)
              ],
            ),
          ) :
          isLogin ? const Index(key: ValueKey<int>(1),) : const Login(key: ValueKey<int>(2),),
        ),
      ),
    );
  }
}