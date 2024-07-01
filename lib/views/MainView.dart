import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/funcs/Prefs.dart';
import 'package:netplayer_mobile/variables/variables.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {

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
      print(c.isLogin.value);
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

    return Scaffold(
      body: loading ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingAnimationWidget.beat(
              color: Color.fromARGB(255, 0, 188, 212),
              size: 30
            ),
            const SizedBox(height: 10,),
            Text('加载中...',)
          ],
        )
      ) : Obx(()=>
        c.isLogin.value ? Center(
          child: Text('主页'),
        ):Center(
          child: Text('登录'),
        )
      )
    );
  }
}