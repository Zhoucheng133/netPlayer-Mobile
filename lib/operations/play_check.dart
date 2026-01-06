import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/variables/player_var.dart';

class PlayCheck{

  PlayerVar p=Get.find();
  DataGet d=DataGet();

  void check(BuildContext context){
    if(p.nowPlay['playFrom']=='all'){
      checkAllSongPlay(context);
    }else if(p.nowPlay['playFrom']=='loved'){
      checkLovedSongPlay(context);
    }else if(p.nowPlay['playFrom']=='playlist'){
      checkPlayListPlay(context);
    }else{
      p.handler.stop();
    }
  }

  Future<void> checkAllSongPlay(BuildContext context) async {
    List ls=await d.getAll(context);
    int index=ls.indexWhere((item) => item['id']==p.nowPlay['id']);
    if(index!=-1){
      Map<String, Object> tmp={
        'id': p.nowPlay['id'],
        'title': p.nowPlay['title'],
        'artist': p.nowPlay['artist'],
        'playFrom': p.nowPlay['playFrom'],
        'duration': p.nowPlay['duration'],
        'fromId': p.nowPlay['fromId'],
        'album': p.nowPlay['album'],
        'index': index,
        'list': ls,
      };
      p.nowPlay.value=tmp;
    }else{
      p.handler.stop();
    }
  }

  Future<void> checkPlayListPlay(BuildContext context) async{
    List ls=await d.getPlayList(context, p.nowPlay['fromId']);
    int index=ls.indexWhere((item) => item['id']==p.nowPlay['id']);
    if(index!=-1){
      Map<String, Object> tmp={
        'id': p.nowPlay['id'],
        'title': p.nowPlay['title'],
        'artist': p.nowPlay['artist'],
        'playFrom': p.nowPlay['playFrom'],
        'duration': p.nowPlay['duration'],
        'fromId': p.nowPlay['fromId'],
        'album': p.nowPlay['album'],
        'index': index,
        'list': ls,
      };
      p.nowPlay.value=tmp;
    }else{
      p.handler.stop();
    }
  }

  Future<void> checkLovedSongPlay(BuildContext context) async {
    List ls=await d.getLoved(context);
    int index=ls.indexWhere((item) => item['id']==p.nowPlay['id']);
    if(index!=-1){
      Map<String, Object> tmp={
        'id': p.nowPlay['id'],
        'title': p.nowPlay['title'],
        'artist': p.nowPlay['artist'],
        'playFrom': p.nowPlay['playFrom'],
        'duration': p.nowPlay['duration'],
        'fromId': p.nowPlay['fromId'],
        'album': p.nowPlay['album'],
        'index': index,
        'list': ls,
      };
      p.nowPlay.value=tmp;
    }else{
      p.handler.stop();
    }
  }
}