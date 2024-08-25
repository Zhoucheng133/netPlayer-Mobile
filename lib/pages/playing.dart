import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class Playing extends StatefulWidget {
  const Playing({super.key});

  @override
  State<Playing> createState() => _PlayingState();
}

class _PlayingState extends State<Playing> {

  PlayerVar p=Get.put(PlayerVar());
  final UserVar u = Get.put(UserVar());
  LsVar l=Get.put(LsVar());

  bool isLoved(){
    for (var val in l.loved) {
      if(val["id"]==p.nowPlay['id']){
        return true;
      }
    }
    return false;
  }

  void seekSong(val){
    if(p.nowPlay['id'].isEmpty){
      return;
    }
    p.handler.pause();
    int progress=(p.nowPlay['duration']*1000*val).toInt();
    p.playProgress.value=progress;
    EasyDebounce.debounce(
      'slider',
      const Duration(milliseconds: 50),
      () {
        p.handler.seek(Duration(milliseconds: p.playProgress.value));
        p.handler.play();
      }
    );
  }

  String convertDuration(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }

  bool showlyric=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Row(
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
      body: GestureDetector(
        onVerticalDragUpdate: (details) async {
          if(details.delta.dy>10){
            Get.back();
          }
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Obx(()=>TitleAria(title: "${p.nowPlay['title']}", subtitle: "${p.nowPlay['artist']}"),),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      showlyric=!showlyric;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: showlyric ? Container(
                        key: const Key("0"),
                        color: Colors.white,
                        // TODO 歌词显示在这里
                      ) : Obx(()=>
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width-150,
                              width: MediaQuery.of(context).size.width-150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: p.nowPlay['id'].isNotEmpty ? NetworkImage("${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}"):
                                  const AssetImage("assets/blank.jpg")
                                )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
                              child: Stack(
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      overlayColor: Colors.transparent,
                                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0), // 取消波纹效果
                                      activeTrackColor: Colors.black, // 设置已激活轨道的颜色
                                      inactiveTrackColor: Colors.grey[200], 
                                      trackHeight: 2,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 8,
                                        pressedElevation: 0,
                                        elevation: 1,
                                        
                                      ),
                                      thumbColor: Colors.black
                                    ),
                                    child: Slider(
                                      value: p.nowPlay['duration']==0 ? 0.0 : p.playProgress.value/1000/p.nowPlay["duration"]>1 ? 1.0 : p.playProgress.value/1000/p.nowPlay["duration"]<0 ? 0 : p.playProgress.value/1000/p.nowPlay["duration"], 
                                      onChanged: (value){
                                        seekSong(value);
                                      }
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 60,
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
                                                color: Colors.black
                                              ),
                                            )
                                          ),
                                          Expanded(child: Container()),
                                          Obx(()=>
                                            Text(
                                              p.nowPlay['duration']==0 ? "" : convertDuration(p.nowPlay['duration']),
                                              style: GoogleFonts.notoSansSc(
                                                fontSize: 12,
                                                color: Colors.black
                                              ),
                                            )
                                          )
                                        ]
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                )
              ),
              Obx(()=>
                Container(
                  height: 120+MediaQuery.of(context).padding.bottom,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(isLoved()){
                            Operations().delove(p.nowPlay['id'], context);
                          }else{
                            Operations().love(p.nowPlay['id'], context);
                          }
                        },
                        child: Icon(
                          isLoved() ? Icons.favorite_rounded : Icons.favorite_border_outlined,
                          color: isLoved() ? Colors.red :Colors.black,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 35,),
                      GestureDetector(
                        onTap: (){
                          p.handler.skipToPrevious();
                        },
                        child: const Icon(
                          Icons.skip_previous_rounded,
                          size:30,
                        ),
                      ),
                      const SizedBox(width: 20,),
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
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 3
                            )
                          ),
                          child: Icon(
                            p.isPlay.value ? Icons.pause_rounded : Icons.play_arrow_rounded
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      GestureDetector(
                        onTap: (){
                          p.handler.skipToNext();
                        },
                        child: const Icon(
                          Icons.skip_next_rounded,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 35,),
                      GestureDetector(
                        onTap: () async {
                          if(p.nowPlay['playFrom']=='fullRandom'){
                            return;
                          }
                          var rlt=await showModalActionSheet(
                            context: context,
                            title: '播放顺序',
                            actions: [
                              const SheetAction(label: '列表播放', key: "list", icon: Icons.repeat_rounded),
                              const SheetAction(label: '随机播放', key: "random", icon: Icons.shuffle_rounded),
                              const SheetAction(label: '单曲循环', key: 'loop', icon: Icons.repeat_one_rounded)
                            ]
                          );
                          if(rlt!=null){
                            p.playMode.value=rlt;
                          }
                        },
                        child: Obx(()=>
                          Icon(
                            p.nowPlay['playFrom']=='fullRandom' ? Icons.shuffle_rounded : p.playMode.value=='list' ? Icons.repeat_rounded : p.playMode.value=='random' ? Icons.shuffle_rounded : Icons.repeat_one_rounded,
                            size: 25,
                            color: p.nowPlay['playFrom']=='fullRandom' ? Colors.grey[400] : Colors.black,
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.grey[100],
                height: MediaQuery.of(context).padding.bottom,
                width: double.infinity,
              )
            ],
          ),
        )
      )
    );
  }
}