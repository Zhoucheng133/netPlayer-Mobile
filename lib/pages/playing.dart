import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/album_content.dart';
import 'package:netplayer_mobile/pages/artist_content.dart';
import 'package:netplayer_mobile/pages/components/play_queue.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Playing extends StatefulWidget {
  const Playing({super.key});

  @override
  State<Playing> createState() => _PlayingState();
}

class _PlayingState extends State<Playing> {
  PlayerVar p=Get.find();
  final UserVar u = Get.find();
  LsVar l=Get.find();
  final DialogVar d=Get.find();
  final Operations operations=Operations();

  bool isLoved(){
    for (var val in l.loved) {
      if(val["id"]==p.nowPlay['id']){
        return true;
      }
    }
    return false;
  }

  void seekChange(val){
    if(p.nowPlay['id'].isEmpty){
      return;
    }
    p.handler.pause();
    int progress=(p.nowPlay['duration']*1000*val).toInt();
    p.playProgress.value=progress;
  }

  Future<void> seekSong(val) async {
    if(p.nowPlay['id'].isEmpty){
      return;
    }
    int progress=(p.nowPlay['duration']*1000*val).toInt();
    p.playProgress.value=progress;
    await p.handler.seek(Duration(milliseconds: p.playProgress.value));
  }

  String convertDuration(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }

  bool showlyric=false;
  late Worker lyricLineListener;

  bool playedLyric(index){
    if(p.lyric.length==1){
      return true;
    }
    bool flag=false;
    try {
      flag=p.playProgress.value>=p.lyric[index].time && p.playProgress<p.lyric[index+1].time;
    } catch (_) {
      if(p.lyric.length==index+1 && p.playProgress.value>=p.lyric[index].time){
        flag=true;
      }else{
        flag=false;
      }
    }
    return flag;
  }

  late Size lyricSize;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollLyric();
      lyricLineListener=ever(p.lyricLine, (val){
        scrollLyric();
      });
    });
    
  }

  @override
  void dispose(){
    Future.microtask(() {
      p.switchHero.value = false;
    });
    controller.dispose();
    super.dispose();
  }

  void scrollLyric(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients || !showlyric || p.lyric.length==1) {
        return;
      }
      if(p.lyricLine.value==0){
        controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        return;
      }
      controller.scrollToIndex(p.lyricLine.value-1, preferPosition: AutoScrollPosition.middle);
    });
  }

  AutoScrollController controller=AutoScrollController();

  Future<void> titleTapHandler(BuildContext context) async {
    final rlt=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: '复制标题名称', key: 'copy', icon: Icons.copy_rounded),
        ActionItem(name: '查看歌曲专辑', key: 'album', icon: Icons.album_rounded)
      ]
    );
    if(rlt!=null && context.mounted){
      if(rlt=='album'){
        final data=await DataGet().getSong(p.nowPlay['id'], context);
        if(data['album']!=null && data['albumId']!=null){
          Get.off(()=>AlbumContent(album: data['album'], id: data['albumId']));
        }
      }else if(rlt=='copy'){
        FlutterClipboard.copy(p.nowPlay['title']);
      }
    }
  }

  Future<void> subtitleTapHandler(BuildContext context) async {
    final rlt=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: '复制艺人名称', key: 'copy', icon: Icons.copy_rounded),
        ActionItem(name: '查看艺人', key: 'artist', icon: Icons.mic_rounded)
      ]
    );
    if(rlt!=null){
      if(rlt=='artist' && context.mounted){
        final data=await DataGet().getSong(p.nowPlay['id'], context);
        if(data['artistId']!=null && data['artist']!=null){
          Get.off(()=>ArtistContent(id: data['artistId'], artist: data['artist']));
        }
      }else if(rlt=='copy'){
        FlutterClipboard.copy(p.nowPlay['artist']);
      }
    }
  }

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: s.darkMode.value ? s.bgColor2 : Colors.white,
        body: GestureDetector(
          onVerticalDragUpdate: (details) async {
            if(details.delta.dy>10){
              Get.back();
            }
          },
          child: Container(
            color: s.darkMode.value ? s.bgColor2 : Colors.white,
            child: Column(
              children: [
                Container(
                  color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
                  height: MediaQuery.of(context).padding.top,
                ),
                Container(
                  color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe_down_alt,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                        Text(
                          '下滑返回',
                          style: GoogleFonts.notoSansSc(
                            color: Colors.grey[400],
                            fontSize: 14
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Obx(()=>TitleArea(title: "${p.nowPlay['title']}", subtitle: "${p.nowPlay['artist']}", titleOnTap: ()=>titleTapHandler(context), subtitleOnTap: ()=>subtitleTapHandler(context),),),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        showlyric=!showlyric;
                        if(showlyric){
                          scrollLyric();
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: showlyric ? Container(
                          key: const Key("0"),
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double topBottomHeight = constraints.maxHeight / 2;
                                    return Obx(()=>
                                      p.lyric.length==1 ? Center(
                                        child: Text(
                                          p.lyric[0].lyric,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.notoSansSc(
                                            fontSize: p.fontSize.value.toDouble(),
                                            height: 2.5,
                                            color: playedLyric(0) ? Colors.blue:Colors.grey[400],
                                            fontWeight: playedLyric(0) ? FontWeight.bold: FontWeight.normal,
                                          ),
                                        ),
                                      ) : ListView.builder(
                                        controller: controller,
                                        itemCount: p.lyric.length,
                                        itemBuilder: (BuildContext context, int index)=>Column(
                                          children: [
                                            index==0 ?  SizedBox(height: topBottomHeight-10,) :Container(),
                                            Obx(() => 
                                              AutoScrollTag(
                                                key: ValueKey(index), 
                                                controller: controller, 
                                                index: index,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        p.lyric[index].lyric,
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.notoSansSc(
                                                          fontSize: p.fontSize.value.toDouble(),
                                                          color: playedLyric(index) ? Colors.blue:Colors.grey[400],
                                                          fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                                                        ),
                                                      ),
                                                      if(p.lyric[index].translate.isNotEmpty && s.showTranslation.value) Text(
                                                        p.lyric[index].translate,
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.notoSansSc(
                                                          fontSize: p.fontSize.value.toDouble() * 0.85,
                                                          color: playedLyric(index) ? Colors.blue:Colors.grey[400],
                                                          fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ),
                                            index==p.lyric.length-1 ? SizedBox(height: topBottomHeight-10,) : Container(),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ),
                              Obx(()=>
                                p.lyricSource.value==null ? Container() : Positioned(
                                  right: 20,
                                  bottom: 10,
                                  child: Tooltip(
                                    preferBelow: false,
                                    message: "歌词来自${p.lyricSource.value==LyricSource.netease ? '网易云' : 'lrclib.net'}，歌词仅供参考",
                                    triggerMode: TooltipTriggerMode.tap,
                                    child: Icon(
                                      Icons.info_rounded,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                )
                              )
                            ],
                          ),
                        ) : Obx(()=>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'cover',
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width-150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    clipBehavior: Clip.antiAlias,
                                    child: p.nowPlay['id'].isEmpty ? Image.asset(
                                      "assets/blank.jpg",
                                      fit: BoxFit.contain,
                                    ) : Image.network(
                                      "${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                  )
                ),
                Obx(()=>
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                      )
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40, right: 40),
                              child: SliderTheme(
                                data: SliderThemeData(
                                  overlayColor: Colors.transparent,
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0), // 取消波纹效果
                                  activeTrackColor: s.darkMode.value ? Colors.grey[300] : Colors.black,
                                  inactiveTrackColor: s.darkMode.value ? Colors.grey[600] : Colors.grey[300],
                                  trackHeight: 2,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                    pressedElevation: 0,
                                    elevation: 1,
                                  ),
                                  thumbColor: s.darkMode.value ? Colors.white : Colors.black
                                ),
                                child: Slider(
                                  value: p.nowPlay['duration']==0 ? 0.0 : p.playProgress.value/1000/p.nowPlay["duration"]>1 ? 1.0 : p.playProgress.value/1000/p.nowPlay["duration"]<0 ? 0 : p.playProgress.value/1000/p.nowPlay["duration"], 
                                  onChanged: (value){
                                    seekChange(value);
                                  },
                                  onChangeEnd: (value){
                                    seekSong(value);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40, right: 40),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 80,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Obx(()=>
                                        Text(
                                          p.nowPlay['duration']==0 ? "" : convertDuration(p.playProgress.value~/1000),
                                          style: GoogleFonts.notoSansSc(
                                            fontSize: 12,
                                          ),
                                        )
                                      ),
                                      Expanded(child: Container()),
                                      Obx(()=>
                                        Text(
                                          p.nowPlay['duration']==0 ? "" : convertDuration(p.nowPlay['duration']),
                                          style: GoogleFonts.notoSansSc(
                                            fontSize: 12,
                                          ),
                                        )
                                      )
                                    ]
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if(p.nowPlay['playFrom']=='fullRandom'){
                                    d.showOkDialog(
                                      context: context,
                                      title: "播放模式不可用",
                                      content: "当前处于完全随机播放模式",
                                      okText: '好的'
                                    );
                                    return;
                                  }
                                  var rlt=await d.showActionSheet(
                                    context: context,
                                    list: [
                                      ActionItem(name: "列表播放", key: "list", icon: Icons.repeat_rounded),
                                      ActionItem(name: '随机播放', key: "random", icon: Icons.shuffle_rounded),
                                      ActionItem(name: '单曲循环', key: 'loop', icon: Icons.repeat_one_rounded)
                                    ]
                                  );
                                  if(rlt!=null){
                                    p.playMode.value=rlt;
                                    var prefs = await SharedPreferences.getInstance();
                                    prefs.setString('playMode', rlt);
                                  }
                                },
                                icon: Obx(()=>
                                  Icon(
                                    p.nowPlay['playFrom']=='fullRandom' ? Icons.shuffle_rounded : p.playMode.value=='list' ? Icons.repeat_rounded : p.playMode.value=='random' ? Icons.shuffle_rounded : Icons.repeat_one_rounded,
                                    size: 25,
                                    color: p.nowPlay['playFrom']=='fullRandom' ? Colors.grey[400] : s.darkMode.value ? const Color.fromARGB(255, 200, 200, 200) : Colors.black,
                                  ),
                                )
                              ),
                              const SizedBox(width: 10,),
                              IconButton(
                                onPressed: (){
                                  p.handler.skipToPrevious();
                                },
                                icon: const Icon(
                                  Icons.skip_previous_rounded,
                                  size:30,
                                ),
                              ),
                              const SizedBox(width: 15,),
                              GestureDetector(
                                onTap: (){
                                  if(p.nowPlay["id"].isNotEmpty){
                                    if(p.isPlay.value){
                                      p.handler.pause();
                                    }else{
                                      p.handler.play();
                                    }
                                  }
                                },
                                child: AnimatedContainer(
                                  height: 60,
                                  width: 60,
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: s.darkMode.value ? s.bgColor3 : Colors.white,
                                    border: Border.all(
                                      color: s.darkMode.value ? Colors.white : Colors.black,
                                      width: 3
                                    )
                                  ),
                                  child: Icon(
                                    p.isPlay.value ? Icons.pause_rounded : Icons.play_arrow_rounded
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15,),
                              IconButton(
                                onPressed: (){
                                  p.handler.skipToNext();
                                },
                                icon: const Icon(
                                  Icons.skip_next_rounded,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              IconButton(
                                onPressed: () async {
                                  var rlt=await d.showActionSheet(
                                    context: context,
                                    list: [
                                      ActionItem(name: '查看所在专辑', key: 'album', icon: Icons.album_rounded),
                                      ActionItem(name: '查看艺人: ${p.nowPlay["artist"]}', key: 'artist', icon: Icons.mic_rounded),
                                      isLoved() ? ActionItem(name: '从喜欢中移除', key: 'delove', icon: Icons.heart_broken_rounded) : 
                                      ActionItem(name: '添加到喜欢', key: 'love', icon: Icons.favorite_rounded),
                                      ActionItem(name: '播放队列', key: 'queue', icon: Icons.playlist_play_rounded),
                                      ActionItem(name: '添加到...', key: 'add', icon: Icons.playlist_add_rounded),
                                      ActionItem(name: showlyric ? '隐藏歌词' : '查看歌词', key: 'lyric', icon: Icons.lyrics_rounded),
                                      ActionItem(name: '歌词大小', key: 'font', icon: Icons.text_fields_rounded),
                                      ActionItem(name: '歌曲信息', key: 'info', icon: Icons.info_rounded),
                                    ]
                                  );
                                  if(rlt!=null && context.mounted){
                                    if(rlt=='delove'){
                                      if(p.nowPlay["id"].isEmpty){
                                        return;
                                      }
                                      operations.delove(p.nowPlay['id'], context);
                                    }else if(rlt=='love'){
                                      if(p.nowPlay["id"].isEmpty){
                                        return;
                                      }
                                      operations.love(p.nowPlay['id'], context);
                                    }else if(rlt=='lyric'){
                                      if(p.nowPlay["id"].isEmpty){
                                        return;
                                      }
                                      setState(() {
                                        showlyric=!showlyric;
                                        scrollLyric();
                                      });
                                    }else if(rlt=='add'){
                                      if(l.playList.isEmpty && context.mounted){
                                        d.showOkDialog(context: context, title: "无法添加到歌单", content: "没有创建任何歌单");
                                        return;
                                      }
                                      if(p.nowPlay["id"].isEmpty){
                                        return;
                                      }
                                      var listId = await d.showActionSheet(
                                        context: context, 
                                        list: List.generate(l.playList.length, (index){
                                          return ActionItem(
                                            key: l.playList[index]['id'],
                                            name: l.playList[index]['name'],
                                            icon: null,
                                          );
                                        })
                                      );
                                      if(listId!=null){
                                        if(context.mounted){
                                          operations.addToList(p.nowPlay['id'], listId, context);
                                        }
                                      }
                                    }else if(rlt=='album'){
                                      if(p.nowPlay["id"].isEmpty){
                                        return;
                                      }
                                      final data=await DataGet().getSong(p.nowPlay['id'], context);
                                      if(data['album']!=null && data['albumId']!=null){
                                        Get.off(()=>AlbumContent(album: data['album'], id: data['albumId']));
                                      }
                                    }else if(rlt=='artist'){
                                      if(p.nowPlay["id"].isEmpty){
                                        return;
                                      }
                                      final data=await DataGet().getSong(p.nowPlay['id'], context);
                                      if(data['artistId']!=null && data['artist']!=null){
                                        Get.off(()=>ArtistContent(id: data['artistId'], artist: data['artist']));
                                      }
                                    }else if(rlt=='font'){
                                      if(!showlyric){
                                        setState(() {
                                          showlyric=true;
                                          scrollLyric();
                                        });
                                      }
                                      operations.resizeFont(context);
                                    }else if(rlt=='info'){
                                      if(p.nowPlay["id"].isEmpty){
                                        return;
                                      }
                                      d.showOkDialogRaw(
                                        context: context, 
                                        title: '歌曲信息', 
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                "${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay['id']}",
                                                width: 100,
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "歌曲标题",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    p.nowPlay['title'],
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "歌曲长度",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    operations.convertDuration(p.nowPlay['duration']),
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "艺人",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    p.nowPlay['artist'],
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "专辑",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    p.nowPlay['album'],
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "歌曲id",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    p.nowPlay['id'],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "歌单id",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    p.nowPlay['fromId'].isEmpty ? "N/A" : p.nowPlay['fromId'],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      );
                                    }else if(rlt=='queue'){
                                      if(p.nowPlay['playFrom']=='fullRandom'){
                                        await d.showOkDialog(context: context, title: "播放队列不可用", content: "现在是完全随机播放模式");
                                        return;
                                      }
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context)=>const PlayQueue()
                                      );
                                    }
                                  }
                                }, 
                                icon: const Icon(
                                  Icons.more_horiz_rounded,
                                )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
                  height: MediaQuery.of(context).padding.bottom,
                  width: double.infinity,
                )
              ],
            ),
          )
        )
      ),
    );
  }
}