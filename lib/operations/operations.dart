import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class Operations{

  DataGet dataGet=DataGet();
  final UserVar u = Get.put(UserVar());

  bool renamePlayList(String id, String newname){
    // TODO 重命名歌单
    return true;
  }

  Future<void> delPlayList(String id, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/deletePlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.errDialog('删除歌单失败', context);
      }
      return;
    }else{
      if(context.mounted){
        dataGet.getPlayLists(context);
      }
    }
  }
}