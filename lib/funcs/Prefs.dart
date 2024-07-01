import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/funcs/operations.dart';
import 'package:netplayer_mobile/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{

  final Variables c = Get.put(Variables());
  
  Future<void> initPrefs(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final autoLogin=prefs.getBool('autoLogin');
    final userInfo=prefs.getString('userInfo');
    if(autoLogin==false){
      return;
    }else if(userInfo!=null){
      try {
        final infoMap=jsonDecode(userInfo);
        final username=infoMap['username'];
        final salt=infoMap['salt'];
        final token=infoMap['token'];
        final url=infoMap['url'];
        if(username!=null && salt!=null && token!=null && url!=null){
          Map rlt=await Operations().login(url, username, salt: salt, token: token);
          if(rlt['ok']==false){
            await showOkAlertDialog(
              context: context,
              title: '自动登录失败',
              message: rlt['data'],
            );
          }
          return;
        }
      } catch (_) {
        
      }
    }
    // TODO 其他内容
    return;
  }
}