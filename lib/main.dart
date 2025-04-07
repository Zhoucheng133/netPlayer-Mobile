import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/main_view.dart';
import 'package:netplayer_mobile/service/handler.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final SettingsVar s=Get.put(SettingsVar());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
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
        theme: s.darkMode.value ? ThemeData.dark().copyWith(
          textTheme: GoogleFonts.notoSansScTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white, 
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          dialogBackgroundColor: Colors.grey[50],
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.grey[50],
          )
        ) : ThemeData(
          textTheme: GoogleFonts.notoSansScTextTheme(),
          highlightColor: Colors.transparent,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          dialogBackgroundColor: Colors.grey[50],
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.grey[50],
          )
        ),
        home: const MainView()
      )
    );
  }
}