import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:netplayer_mobile/funcs/Requests.dart';

class Operations{
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
    final rlt=await requests.loginRequest(url, username, salt, token);
    if(rlt.isEmpty){
      return {
        'ok': false,
        'data': '网络请求失败'
      };
    }else if(rlt['status']=='failed'){
      return {
        'ok': false,
        'data': '用户名或者密码有误',
      };
    }else{
      return {
        'ok': true,
        'data': '',
      };
    }
  }
}