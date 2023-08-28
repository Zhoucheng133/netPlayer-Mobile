// ignore_for_file: unused_local_variable, invalid_use_of_protected_member

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final Controller c = Get.put(Controller());
  final player = AudioPlayer();

  var playInfo={};
  
  @override
  Future<void> play() async {
    if(c.playInfo["id"]==null){
      return;
    }
    var url="${c.userInfo["url"]}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}";
    playInfo=c.playInfo;
    player.play(UrlSource(url));
    player.onPlayerComplete.listen((event) {
      skipToNext();
    });
    c.updateIsPlay(true);
  }

  @override
  Future<void> pause() async {
    player.pause();
    c.updateIsPlay(false);
  }

  void swtich(){
    var index=(playInfo["list"].length+playInfo["index"]+1)%(playInfo["index"]+1);
    var tmp={
      "name": playInfo["name"],
      "id": playInfo["list"][index]["id"],
      "title": playInfo["list"][index]["title"],
      "artist": playInfo["list"][index]["artist"],
      "duration": playInfo["list"][index]["duration"],
      "ListId": playInfo["ListId"] ?? "",
      "index": index,
      "list": playInfo["list"],
    };
    c.updatePlayInfo(tmp);
  }

  @override
  Future<void> skipToNext()async {
    swtich();
    play();
  }

  @override
  Future<void> skipToPrevious()async{

  }
}