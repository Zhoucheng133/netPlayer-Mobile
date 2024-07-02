// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, prefer_typing_uninitialized_variables, unused_element, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      androidNotificationChannelId: 'zhouc.netplayer.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  final Controller c = Get.put(Controller());

  var isLoaded=false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 应用进入前台
      c.updateFronted(true);
    } else {
      // 应用进入后台
      c.updateFronted(false);
    }
    if (state == AppLifecycleState.detached) {
      _audioHandler.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
      if(decodePlayInfo.isNotEmpty){
        c.updatePlayInfo(decodePlayInfo);
      }
    }

    // print(c.playInfo);

    if(savePlay==false){
      c.savePlay.value=false;
    }
    
    setState(() {
      isLoaded=true;
    });
  }

  Future<void> setPlayMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isFullRandom = prefs.getBool('isFullRandom');
    if(isFullRandom==true){
      c.updateFullRandom(true);
      c.updatePlayMode("随机播放");
    }
    // 获取上一次播放模式
    final String? playMode=prefs.getString("playMode");
    if(playMode!=null){
      c.updatePlayMode(playMode);
    }
  }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 检查登录
    checkLogin();
    setPlayMode();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      )
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', 'US'), // 美国英语
        Locale('zh', 'CN'), // 中文简体
      ],
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansScTextTheme(),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
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
