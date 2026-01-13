import 'dart:convert';

import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:http/http.dart' as http;

class LyricGet{

  final PlayerVar p=Get.find();


  // 时间戳转换成毫秒
  int timeToMilliseconds(timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = int.parse(secondsParts[1]);

    // 将分钟、秒和毫秒转换为总毫秒数
    return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;
  }

  Future<void> getLyric() async {

    if(!(await netease())){
      if(!(await lrclib())){
        p.lyricSource.value=null;
        p.lyric.value=[
          LyricItem('noLyric'.tr, "", 0)
        ];
      }
    }
  }

  Future<bool> lrclib() async {
    final title=p.nowPlay['title'];
    final album=p.nowPlay['album'];
    final artist=p.nowPlay['artist'];
    final duration=p.nowPlay['duration'];
    final rlt= await httpRequest('https://lrclib.net/api/get?artist_name=$artist&track_name=$title&album_name=$album&duration=$duration');
    var response=rlt['syncedLyrics']??"";
    if(response==''){
      return false;
    }
    List<LyricItem> lyricCovert=[];
    List<String> lines = LineSplitter.split(response).toList();
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      if(pos1==-1 || pos2==-1){
        return false;
      }
      lyricCovert.add(LyricItem(line.substring(pos2 + 1).trim(), "", timeToMilliseconds(line.substring(pos1+1, pos2))));
    }
    p.lyric.value=lyricCovert;
    p.lyricSource.value=LyricSource.lrclib;
    return true;
  }

  Future<Map?> neteaseRequest(String title, String artist) async {
    String id="";
    try {
      final keyword="$title $artist";
      final searchAPI="https://music.163.com/api/search/get/web?csrf_token=hlpretag=&hlposttag=&s=$keyword&type=1&offset=0&total=true&limit=1";
      final response=await http.get(Uri.parse(searchAPI));
      
      final firstRlt=json.decode(utf8.decode(response.bodyBytes))['result']['songs'][0];
      if(!(firstRlt['name'].contains(title) || title.contains(firstRlt['name']))){
        return null;
      }
      id=json.decode(utf8.decode(response.bodyBytes))['result']['songs'][0]['id'].toString();
    } catch (_) {
      return null;
    }
    if(id.isEmpty){
      return null;
    }
    Map lyric={};
    try {
      final lyricAPI="https://music.163.com/api/song/lyric?id=$id&tv=-1&os=pc&lv=-1";
      final response=await http.get(Uri.parse(lyricAPI));
      lyric=json.decode(utf8.decode(response.bodyBytes));
      if(lyric.isNotEmpty && lyric["lrc"]!=null){
        return {
          "lyric": lyric["lrc"]["lyric"],
          "translate": lyric["tlyric"]==null ? [] : lyric["tlyric"]["lyric"]
        };
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<bool> netease() async {
    final Map? lyricResponse=await neteaseRequest(p.nowPlay['title'], p.nowPlay['artist']);
    if(lyricResponse==null){
      return false;
    }
    List<LyricItem> lyricCovert=[];
    List<String> lines = LineSplitter.split(lyricResponse["lyric"]).toList();
    bool hasTranslate=lyricResponse["translate"].length!=0;
    List<String> tlines=[];
    if(hasTranslate){
      tlines=LineSplitter.split(lyricResponse["translate"]).toList();
    }
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      if(pos1==-1 || pos2==-1){
        continue;
      }
      late int time;
      late String lyricItem;
      String lyricTranslate="";
      try {
        final timeInString=line.substring(pos1+1, pos2);
        time=timeToMilliseconds(timeInString);
        lyricItem = (pos2 + 1 < line.length) ? line.substring(pos2 + 1).trim() : "";
        if(lyricItem=='' && lyricCovert.last.lyric==''){
          continue;
        }
        if(hasTranslate){
          for(final t in tlines){
            if(t.startsWith("[$timeInString]")){
              lyricTranslate = (pos2 + 1 < t.length) ? t.substring(pos2 + 1).trim() : "";
            }
          }
        }
      } catch (_) {
        continue;
      }
      lyricCovert.add(LyricItem(
        lyricItem,
        lyricTranslate,
        time,
      ));
    }
    if(lyricCovert.isEmpty){
      return false;
    }
    lyricCovert.sort((a, b)=>a.time.compareTo(b.time));
    p.lyric.value=lyricCovert;
    p.lyricSource.value=LyricSource.netease;
    return true;
  }
}