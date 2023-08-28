// ignore_for_file: unused_local_variable, invalid_use_of_protected_member, prefer_const_constructors

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final Controller c = Get.put(Controller());
  final player = AudioPlayer();

  var playInfo={};

  MediaItem item=MediaItem(id: "", title: "");

  void setInfo(){
    item=MediaItem(
      id: c.playInfo["id"],
      album: c.playInfo["album"],
      title: c.playInfo["title"],
      artist: c.playInfo["artist"],
      artUri: Uri.parse("${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}"),
      duration: Duration(seconds: c.playInfo["duration"]),
    );
    mediaItem.add(item);
  }

  void mediaControl(bool state){
    playbackState.add(playbackState.value.copyWith(
      playing: state,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
      ],
    ));
  }
  
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
    setInfo();
    mediaControl(true);
  }

  @override
  Future<void> pause() async {
    player.pause();
    c.updateIsPlay(false);
    setInfo();
    mediaControl(false);
  }

  @override
  Future<void> skipToNext()async {
    swtichNext();
    play();
    setInfo();
    mediaControl(true);
  }

  @override
  Future<void> skipToPrevious()async{
    switchbackward();
    play();
    setInfo();
    mediaControl(true);
  }

  void switchbackward(){
    var index=playInfo["index"];
    if(index!=0){
      index=(playInfo["list"].length+playInfo["index"]-1)%(playInfo["list"].length);
    }else{
      index=playInfo["list"].length-1;
    }
    
    var tmp={
      "name": playInfo["name"],
      "id": playInfo["list"][index]["id"],
      "title": playInfo["list"][index]["title"],
      "artist": playInfo["list"][index]["artist"],
      "duration": playInfo["list"][index]["duration"],
      "ListId": playInfo["ListId"] ?? "",
      "index": index,
      "list": playInfo["list"],
      "album": playInfo["list"][index]["album"],
    };
    // print(tmp);
    c.updatePlayInfo(tmp);
  }

  void swtichNext(){
    var index=(playInfo["list"].length+playInfo["index"]+1)%(playInfo["list"].length);
    var tmp={
      "name": playInfo["name"],
      "id": playInfo["list"][index]["id"],
      "title": playInfo["list"][index]["title"],
      "artist": playInfo["list"][index]["artist"],
      "duration": playInfo["list"][index]["duration"],
      "ListId": playInfo["ListId"] ?? "",
      "index": index,
      "list": playInfo["list"],
      "album": playInfo["list"][index]["album"],
    };
    c.updatePlayInfo(tmp);
  }
}