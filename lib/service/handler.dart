// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class Handler extends BaseAudioHandler with QueueHandler, SeekHandler {

  final player = Player();
  var playURL="";
  bool skipHandler=false;
  late MediaItem item;

  PlayerVar p=Get.put(PlayerVar());
  final UserVar u = Get.put(UserVar());

  Handler(){
    player.stream.position.listen((position) {
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
    player.stream.completed.listen((state) {
      if(state){
        skipToNext();
      }
    });
  }

  void setMedia(bool isPlay){
    item=MediaItem(
      id: p.nowPlay["id"],
      title: p.nowPlay["title"],
      artist: p.nowPlay["artist"],
      artUri: Uri.parse("${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}"),
      album: p.nowPlay["album"],
    );
    mediaItem.add(item);

    playbackState.add(playbackState.value.copyWith(
      playing: isPlay,
      controls: [
        MediaControl.skipToPrevious,
        isPlay ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
    ));
  }

  // 播放
  @override
  Future<void> play() async {
    var url="${u.url.value}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}";
    if(url!=playURL || skipHandler){
      final media=Media(url);
      await player.open(media);
    }
    player.play();
    if(skipHandler){
      skipHandler=false;
    }
    playURL=url;
    setMedia(true);
  }

  // 暂停
  @override
  Future<void> pause() async {
    player.pause();
    setMedia(false);
  }

  // 停止播放
  @override
  Future<void> stop() async {
    player.stop();
  }

  // 跳转
  @override
  Future<void> seek(Duration position) async {
    player.seek(position);
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
    if(p.fullRandom.value){
      // Operations().fullRandomPlay();
      // TODO 完全随机播放
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
    if(p.fullRandom.value){
      // Operations().fullRandomPlay();
      // TODO 完全随机播放
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