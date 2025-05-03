import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/main_view.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/page_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  if(Platform.isAndroid){
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final darkMode=prefs.getBool("darkMode");
  final autoDark=prefs.getBool("autoDark");
  Get.put(PlayerVar());
  final SettingsVar s=Get.put(SettingsVar());
  Get.put(DialogVar());
  Get.put(LsVar());
  Get.put(PageVar());
  Get.put(UserVar());
  s.initDark(autoDark, darkMode);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    s.autoDarkMode(brightness == Brightness.dark);

    return Obx(()=>
      GetMaterialApp(
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
        builder: (context, child)=>FTheme(
          data: s.darkMode.value ? FThemes.zinc.dark : FThemes.zinc.light, 
          child: child!
        ),
        theme: s.darkMode.value ? ThemeData.dark().copyWith(
          textTheme: GoogleFonts.notoSansScTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white, 
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ) : ThemeData(
          textTheme: GoogleFonts.notoSansScTextTheme(),
          highlightColor: Colors.transparent,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          dialogTheme: DialogThemeData(
            backgroundColor: Colors.grey[50]
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.grey[50],
          )
        ),
        home: const MainView()
      )
    );
  }
}