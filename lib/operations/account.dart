import 'package:netplayer_mobile/operations/requests.dart';

class Account{
  Future<Map> login(String url, String username, String token, String salt) async {
    var response=await httpRequest("$url/rest/ping.view?v=1.12.0&c=myapp&f=json&u=$username&t=$token&s=$salt");
    try {
      response=response["subsonic-response"];
    } catch (_) {
      return {
        'ok': false,
        'data': '网络请求出错'
      };
    }
    if(response['status']=='failed'){
      return {
        'ok': false,
        'data': '用户名或者密码有误'
      };
    }
    return {
      'ok': true,
      'data': ""
    };
  }

  void logout(){

  }
}