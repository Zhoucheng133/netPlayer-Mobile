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

  bool fromPause=false;

  MyAudioHandler(){
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
      processingState: AudioProcessingState.loading,
    ));
    player.onPlayerComplete.listen((event) {
      skipToNext();
    });
  }

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

  @override
  Future<void> play() async {
    if(c.playInfo["id"]==null){
      return;
    }
    var url="${c.userInfo["url"]}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}";
    playInfo=c.playInfo;
    await player.play(UrlSource(url));
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
    ));
    c.updateIsPlay(true);
    if(fromPause){
      fromPause=false;
    }else{
      setInfo();
    }
  }

  @override
  Future<void> pause() async {
    await player.pause();
    c.updateIsPlay(false);
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
      ],
    ));
    fromPause=true;
  }

  @override
  Future<void> skipToNext()async {
    await player.stop();
    swtichNext();
    await play();
    setInfo();
  }

  @override
  Future<void> skipToPrevious()async{
    await player.stop();
    switchbackward();
    await play();
    setInfo();
  }

  @override
  Future<void> stop()async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [],
    ));
    await player.stop();
    c.updatePlayInfo({});
    c.updateIsPlay(false);
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