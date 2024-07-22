import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/pages/home.dart';
import 'package:netplayer_mobile/pages/login.dart';
import 'package:netplayer_mobile/variables/static_color.dart';
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
  final UserVar a = Get.put(UserVar());
  bool loginOk=false;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> loginCheck() async {
    var url=prefs.getString('url');
    var username=prefs.getString('username');
    var token=prefs.getString('token');
    var salt=prefs.getString('salt');
    if(url!=null && username!=null && token!=null && salt!=null){
      var resp=await account.login(url, username, token, salt);
      if(resp['ok']){
        a.username.value=username;
        a.salt.value=salt;
        a.url.value=url;
        a.token.value=token;
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showOkAlertDialog(
            context: context,
            title: '自动登录失败',
            message: resp['data']
          );
        });
      }
    }
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loginCheck();
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: loading ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.beat(
              color: StaticColor().color6, 
              size: 30
            ),
            const SizedBox(height: 10,),
            const Text('加载中')
          ],
        ),
      ) : loginOk ? const Home() : const Login(),
    );
  }
}