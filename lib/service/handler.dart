// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:netplayer_mobile/operations/player_control.dart';
import 'package:netplayer_mobile/operations/seek_check.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class Handler extends BaseAudioHandler with QueueHandler, SeekHandler {

  final player = AudioPlayer();
  final seekCheck=SeekCheck();
  final s=Get.put(SettingsVar());
  var playURL="";
  bool skipHandler=false;
  late MediaItem item;

  PlayerVar p=Get.put(PlayerVar());
  final UserVar u = Get.put(UserVar());

  Future<void> initSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    session.interruptionEventStream.listen((event) {
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

  Handler(){

    initSession();

    player.positionStream.listen((position) {
      var data=position.inMilliseconds;
      p.playProgress.value=data;
      if(p.lyric.isNotEmpty && p.lyric.length!=1){
        for (var i = 0; i < p.lyric.length; i++) {
          if(i==p.lyric.length-1){
            p.lyricLine.value=p.lyric.length;
            break;
          }else if(i==0 && data<p.lyric[i]['time']){
            // updateLyricLine(0);
            p.lyricLine.value=0;
            break;
          }else if(data>=p.lyric[i]['time'] && data<p.lyric[i+1]['time']){
            // updateLyricLine(i+1);
            p.lyricLine.value=i+1;
            break;
          }
        }
      }else if(p.lyric.length==1){
        // updateLyricLine(0);
        p.lyricLine.value=0;
      }
    });

    // playbackState.add(playbackState.value.copyWith(
    //   controls: [
    //     MediaControl.skipToPrevious,
    //     MediaControl.pause,
    //     MediaControl.skipToNext,
    //   ],
    //   processingState: AudioProcessingState.loading,
    // ));
    player.playerStateStream.listen((state) {
      if(state.processingState == ProcessingState.completed) {
        // print("complete");
        skipToNext();
      }
    });
  }

  void setMedia(bool isPlay){
    playbackState.add(PlaybackState(
      playing: isPlay,
      controls: [
        MediaControl.skipToPrevious,
        isPlay ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      updatePosition: Duration(milliseconds: p.playProgress.value),
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
    ));
    item=MediaItem(
      id: p.nowPlay["id"],
      title: p.nowPlay["title"],
      artist: p.nowPlay["artist"],
      artUri: Uri.parse("${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}"),
      album: p.nowPlay["album"],
      duration: Duration(seconds: p.nowPlay['duration']),
    );
    mediaItem.add(item);
  }

  // 播放
  @override
  Future<void> play() async {
    if(p.nowPlay["id"].isEmpty){
      return;
    }
    // var url="${u.url.value}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}";
    var url=seekCheck.enableSeek() ? "${u.url.value}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}"
    : "${u.url.value}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}&maxBitRate=${s.quality.value.quality}";
    if(url!=playURL || skipHandler){
      await player.setUrl(url);
    }
    player.play();
    if(skipHandler){
      skipHandler=false;
    }
    playURL=url;
    setMedia(true);
    p.isPlay.value=true;
  }

  // 暂停
  @override
  Future<void> pause() async {
    if(p.nowPlay["id"].isEmpty){
      return;
    }
    player.pause();
    setMedia(false);
    p.isPlay.value=false;
  }

  // 停止播放
  @override
  Future<void> stop() async {
    if(p.nowPlay["id"].isEmpty){
      return;
    }
    player.stop();
    p.isPlay.value=false;
    Map<String, Object> tmp={
          'id': '',
          'title': '',
          'artist': '',
          'playFrom': '',
          'duration': 0,
          'fromId': '',
          'index': 0,
          'album': '',
          'list': [],
        };
    p.nowPlay.value=tmp;
  }

  // 跳转
  @override
  Future<void> seek(Duration position) async {
    if(p.nowPlay["id"].isEmpty){
      return;
    }
    await player.seek(position);
    await play();
    setMedia(true);
  }

  int preHandler(int index, int length){
    if(index==0){
      return length-1;
    }
    return index-1;
  }

  // 上一首
  @override
  Future<void> skipToPrevious() async {
    if(p.nowPlay["id"].isEmpty){
      return;
    }
    if(p.nowPlay['playFrom']=='fullRandom'){
      PlayerControl().shufflePlay();
      return;
    }
    var tmpList=p.nowPlay.value;
    tmpList['index']=preHandler(p.nowPlay.value['index'], p.nowPlay.value['list'].length);
    tmpList['id']=tmpList['list'][tmpList['index']]['id'];
    tmpList['title']=tmpList['list'][tmpList['index']]['title'];
    tmpList['artist']=tmpList['list'][tmpList['index']]['artist'];
    tmpList['duration']=tmpList['list'][tmpList['index']]['duration'];
    tmpList['album']=tmpList['list'][tmpList['index']]['album'];
    p.nowPlay.value=tmpList;
    p.nowPlay.refresh();
    skipHandler=true;
    play();
    setMedia(true);
  }

  int nextHandler(int index, int length){
    if(p.playMode.value=='list'){
      if(index==length-1){
        return 0;
      }
      return index+1;
    }else if(p.playMode.value=='random'){
      if(length==1){
        return 0;
      }
      Random random =Random();
      return random.nextInt(length-1);
    }else{
      return index;
    }
  }

  // 下一首
  @override
  Future<void> skipToNext() async {
    if(p.nowPlay["id"].isEmpty){
      return;
    }
    if(p.nowPlay['playFrom']=='fullRandom'){
      PlayerControl().shufflePlay();
      return;
    }
    Map<String, dynamic> tmpList=p.nowPlay.value;
    tmpList['index']=nextHandler(p.nowPlay.value['index'], p.nowPlay.value['list'].length);
    tmpList['id']=tmpList['list'][tmpList['index']]['id'];
    tmpList['title']=tmpList['list'][tmpList['index']]['title'];
    tmpList['artist']=tmpList['list'][tmpList['index']]['artist'];
    tmpList['duration']=tmpList['list'][tmpList['index']]['duration'];
    tmpList['album']=tmpList['list'][tmpList['index']]['album'];
    // p.updateNowPlay(tmpList);
    p.nowPlay.value=tmpList;
    p.nowPlay.refresh();
    skipHandler=true;
    play();
    setMedia(true);
  }

  Future<void> volumeSet(val) async {
    await player.setVolume(val.toDouble());
  }
}