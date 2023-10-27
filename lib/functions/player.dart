// ignore_for_file: unused_local_variable, invalid_use_of_protected_member, prefer_const_constructors, prefer_typing_uninitialized_variables, unrelated_type_equality_checks

import 'dart:math';

import 'package:audio_service/audio_service.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final Controller c = Get.put(Controller());
  final player = AudioPlayer();

  var playInfo={};
  var playingURL="";

  MediaItem item=MediaItem(id: "", title: "");

  bool fromPause=false;

  MyAudioHandler(){
    player.positionStream.listen((position) {
      c.updateNowDuration(position.inSeconds);
      // print(c.nowDuration);
    });

    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
      processingState: AudioProcessingState.loading,
    ));
    // player.onPlayerComplete.listen((event) {
    //   skipToNext();
    // });
    player.playerStateStream.listen((state) {
      if(state.processingState == ProcessingState.completed) {
        // print("complete");
        skipToNext();
      }
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
    // await player.play(UrlSource(url));
    if(playingURL!=url){
      await player.setUrl(url);
    }
    player.play();
    playingURL=url;
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      updatePosition: Duration(seconds: c.nowDuration.value)
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
    player.pause();
    c.updateIsPlay(false);
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      updatePosition: Duration(seconds: c.nowDuration.value)
    ));
    fromPause=true;
  }

  @override
  Future<void> seek(Duration position) async {
    await player.seek(position);
    await play();
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      updatePosition: Duration(seconds: c.nowDuration.value)
    ));
  }

  @override
  Future<void> skipToNext()async {
    await player.stop();
    swtichNext();
    play();
    setInfo();
  }

  @override
  Future<void> skipToPrevious()async{
    await player.stop();
    switchbackward();
    play();
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
    c.updatePlayInfo(tmp);
  }

  void swtichNext(){
    var index;
    if(c.randomPlay==true){
      Random random = Random();
      index=random.nextInt(playInfo["list"].length);
    }else{
      index=(playInfo["list"].length+playInfo["index"]+1)%(playInfo["list"].length);
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
    c.updatePlayInfo(tmp);
  }
}