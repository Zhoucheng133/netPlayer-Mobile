import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/account.dart';
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
          
        });
      }
    }
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loginCheck();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}