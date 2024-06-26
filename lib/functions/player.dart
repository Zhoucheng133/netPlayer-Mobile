// ignore_for_file: unused_local_variable, invalid_use_of_protected_member, prefer_const_constructors, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, empty_catches, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final Controller c = Get.put(Controller());
  final player = AudioPlayer();

  // var playInfo={};
  var playingURL="";

  MediaItem item=MediaItem(id: "", title: "");

  bool fromPause=false;

  Future<void> initSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    // print("configured: ${session.isConfigured}");
    session.interruptionEventStream.listen((event) {
      // print("event begin: ${event.begin}");
      // print("event type: ${event.type}");
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            player.setVolume(0.5);
            // print("Duck!");
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            // print("pause Request");
            pause();
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // The interruption ended and we should unduck.
            player.setVolume(1);
            break;
          case AudioInterruptionType.pause:
            play();
          case AudioInterruptionType.unknown:
            break;
        }
      }
    });
  }

  MyAudioHandler(){
    initSession();

    player.positionStream.listen((position) {
      c.updateNowDuration(position.inSeconds);
      c.updateNowDurationInMc(position.inMilliseconds);
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

  Future<void> setInfo() async {
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
    // playInfo=c.playInfo;
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
    if(c.savePlay==true){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String info=json.encode(c.playInfo);
      await prefs.setString("playInfo", info);
    }
  }

  @override
  Future<void> pause() async {
    player.pause();
    c.updateIsPlay(false);
    // print("pause!");
    // print("isPlay: ${c.isPlay.value}");
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
    await swtichNext();
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
    if(c.fullRandom==true){
      swtichNext();
      return;
    }
    var index=c.playInfo["index"];
    if(index!=0){
      index=(c.playInfo["list"].length+c.playInfo["index"]-1)%(c.playInfo["list"].length);
    }else{
      index=c.playInfo["list"].length-1;
    }
    
    var tmp={
      "name": c.playInfo["name"],
      "id": c.playInfo["list"][index]["id"],
      "title": c.playInfo["list"][index]["title"],
      "artist": c.playInfo["list"][index]["artist"],
      "duration": c.playInfo["list"][index]["duration"],
      "ListId": c.playInfo["ListId"] ?? "",
      "index": index,
      "list": c.playInfo["list"],
      "album": c.playInfo["list"][index]["album"],
    };
    c.updatePlayInfo(tmp);
  }

  Future<void> swtichNext() async {
    var index;
    if(c.fullRandom==true){
      var tmp=await randomSongRequest();
      tmp=tmp["randomSongs"]["song"][0];
      var tempInfo={
        "name": "randomPlay",
        "id": tmp["id"],
        "title": tmp["title"],
        "artist": tmp["artist"],
        "duration": tmp["duration"],
        "ListId": "",
        "index": 0,
        "list": [],
        "album": tmp["album"],
      };
      c.updatePlayInfo(tempInfo);
      return;
    }else if(c.playMode.value=="随机播放"){
      // print("Next1");
      Random random = Random();
      index=random.nextInt(c.playInfo["list"].length);
    }else if(c.playMode.value=="单曲循环"){
      playingURL="";
      play();
      return;
    }else{
      // print("Next1");
      // print(c.playInfo);
      index=(c.playInfo["list"].length+c.playInfo["index"]+1)%(c.playInfo["list"].length);
    }
    var tmp={
      "name": c.playInfo["name"],
      "id": c.playInfo["list"][index]["id"],
      "title": c.playInfo["list"][index]["title"],
      "artist": c.playInfo["list"][index]["artist"],
      "duration": c.playInfo["list"][index]["duration"],
      "ListId": c.playInfo["ListId"] ?? "",
      "index": index,
      "list": c.playInfo["list"],
      "album": c.playInfo["list"][index]["album"],
    };
    c.updatePlayInfo(tmp);
  }
}