import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/funcs/LocalDialog.dart';
import 'package:netplayer_mobile/funcs/Prefs.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {

  bool loading=true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Prefs().initPrefs(context);
      await Localdialog().showLocalDialog(context, '测试标题', '测试内容');
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

    return Scaffold(
      body: Center(
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
      ),
    );
  }
}