// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, prefer_typing_uninitialized_variables, unused_element

import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/functions/player.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/_mainView.dart';
import 'package:netplayer_mobile/views/_loginView.dart';
// import 'package:netplayer_mobile/views/_playingView.dart';
import 'package:shared_preferences/shared_preferences.dart';

var _audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Controller c = Get.put(Controller());

  var isLoaded=false;

  Future<void> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('userInfo');
    final String? playInfo = prefs.getString('playInfo');
    final bool? autoLogin = prefs.getBool('autologin');
    final bool? savePlay = prefs.getBool('savePlay');

    if(userData!=null && (autoLogin==true || autoLogin==null)){
      c.updateLogin(true);
      Map<String,dynamic> decodeUserData = json.decode(userData);
      c.updateUserInfo(decodeUserData);
    }

    if(autoLogin==false){
      c.autoLogin.value=false;
    }

    if(savePlay!=false && playInfo!=null){
      Map<String,dynamic> decodePlayInfo = json.decode(playInfo);
      c.updatePlayInfo(decodePlayInfo);
    }

    // print(c.playInfo);

    if(savePlay==false){
      c.savePlay.value=false;
    }
    
    setState(() {
      isLoaded=true;
    });
  }

  Future<void> setFullRandom() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isFullRandom = prefs.getBool('isFullRandom');
    if(isFullRandom==true){
      c.updateFullRandom(true);
      c.updateRandomPlay(true);
    }
  }
  
  @override
  void initState() {
    super.initState();
    // 检查登录
    checkLogin();
    setFullRandom();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body:  isLoaded ? Obx(
          () => AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: c.isLogin==true ? mainView(audioHandler: _audioHandler,) : loginView(),
          )
        ) : Container(),
      ),
    );
  }
}
