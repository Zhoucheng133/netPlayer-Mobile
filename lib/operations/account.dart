import 'dart:math';

import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account{
  final UserVar u = Get.find();
  PlayerVar p=Get.find();

  // 登录
  Future<Map> login(String url, String username, String token, String salt) async {
    var response=await httpRequest("$url/rest/ping.view?v=1.12.0&c=netPlayer&f=json&u=$username&t=$token&s=$salt");
    try {
      response=response["subsonic-response"];
    } catch (_) {
      return {
        'ok': false,
        'data': 'networkError'.tr
      };
    }
    if(response['status']=='failed'){
      return {
        'ok': false,
        'data': 'usernameOrPasswordError'.tr
      };
    }
    return {
      'ok': true,
      'data': ""
    };
  }

  // 生成随机salt
  String generateRandomString(int length) {
    const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random random = Random();
    String result = "";

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(charset.length);
      result += charset[randomIndex];
    }

    return result;
  }

  // 注销
  Future<void> logout() async {
    u.salt.value='';
    u.token.value='';
    u.url.value='';
    u.username.value='';
    u.password.value='';
    p.handler.stop();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}