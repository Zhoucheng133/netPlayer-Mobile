import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class DataGet{

  final UserVar u = Get.put(UserVar());
  final LsVar ls=Get.put(LsVar());

  Future<void> getPlayLists() async {
    final rlt=await httpRequest("${u.url.value}/rest/getPlaylists?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      // TODO 请求失败提示
      return;
    }else{
      try {
        ls.playList.value=rlt['subsonic-response']['playlists']['playlist'];
      } catch (_) {
        // TODO 请求失败提示
      }
    }
  }

  Future<List> getAllSongs() async {
    final rlt=await httpRequest("${u.url.value}/rest/getRandomSongs?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&size=500");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      // TODO 请求失败提示
      return [];
    }else{
      try {
        var tmpList=rlt['subsonic-response']['randomSongs']['song'];
        tmpList.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a['created']);
          DateTime dateTimeB = DateTime.parse(b['created']);
          return dateTimeB.compareTo(dateTimeA);
        });
        return tmpList;
      } catch (_) {
        // TODO 请求失败提示
        return [];
      }
    }
  }
}