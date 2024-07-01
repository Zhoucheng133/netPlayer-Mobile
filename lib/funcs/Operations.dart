import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/funcs/Requests.dart';
import 'package:netplayer_mobile/variables/Variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Operations{

  final Variables c = Get.put(Variables());

  String generateSalt() {
    const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random random = Random();
    String result = "";

    for (int i = 0; i < 6; i++) {
      int randomIndex = random.nextInt(charset.length);
      result += charset[randomIndex];
    }

    return result;
  }

  void logout(){
    c.isLogin.value=false;
    c.username.value='';
    c.token.value='';
    c.url.value='';
    c.salt.value='';
  }

  Future<Map> login(String url, String username, {String? salt, String? token, String? password}) async {
    final requests=Requests();

    if(salt==null && token==null && password!=null){
      salt=generateSalt();
      var bytes = utf8.encode(password+salt);
      token = md5.convert(bytes).toString();
    }else if(salt!=null && token!=null && password==null){
    }else{
      return {
        'ok': false,
        'data': '参数不正确'
      };
    }
    var rlt=await requests.loginRequest(url, username, salt, token);
    if(rlt.isEmpty || rlt['subsonic-response']==null){
      return {
        'ok': false,
        'data': '网络请求失败'
      };
    }else if(rlt['subsonic-response']['status']=='failed'){
      return {
        'ok': false,
        'data': '用户名或者密码有误',
      };
    }else{
      c.isLogin.value=true;
      c.salt.value=salt;
      c.username.value=username;
      c.token.value=token;
      c.url.value=url;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userInfo', jsonEncode({
        'username': username,
        'url': url,
        'salt': salt,
        'token': token
      }));
      return {
        'ok': true,
        'data': '',
      };
    }
  }
}