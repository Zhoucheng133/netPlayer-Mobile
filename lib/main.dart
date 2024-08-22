// ignore_for_file: prefer_const_constructors

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/main_view.dart';
import 'package:netplayer_mobile/service/handler.dart';
import 'package:netplayer_mobile/variables/player_var.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PlayerVar p = Get.put(PlayerVar());
  p.handler=await AudioService.init(
    builder: () => Handler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'zhouc.netPlayer.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansScTextTheme(),
        highlightColor: Colors.transparent,
        // splashColor: Colors.transparent,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: MainView()
    );
  }
}