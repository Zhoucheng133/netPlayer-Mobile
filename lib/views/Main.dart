import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/funcs/Prefs.dart';
import 'package:netplayer_mobile/variables/Variables.dart';
import 'package:netplayer_mobile/views/Home.dart';
import 'package:netplayer_mobile/views/Login.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  final Variables c = Get.put(Variables());
  bool loading=true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Prefs().initPrefs(context);
      setState(() {
        loading=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      )
    );
    return loading ? Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingAnimationWidget.beat(
              color: c.color5,
              size: 30
            ),
            const SizedBox(height: 10,),
            Text('加载中...',)
          ],
        ),
      ),
    ) : Obx(()=>
      c.isLogin.value ? Home() : Login()
    );
  }
}