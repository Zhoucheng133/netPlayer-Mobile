import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/playing.dart';
import 'package:netplayer_mobile/variables/page_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class PlaybarContent extends StatefulWidget {
  const PlaybarContent({super.key});

  @override
  State<PlaybarContent> createState() => _PlaybarContentState();
}

class _PlaybarContentState extends State<PlaybarContent> {

  PlayerVar p=Get.put(PlayerVar());
  final UserVar u = Get.put(UserVar());

  void toPlaying(){
    p.switchHero.value=true;
    Get.to(
      ()=>const Playing(),
      transition: Transition.downToUp,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      child: Stack(
        children: [
          Positioned(
            child: Obx(()=>
              Container(
                height: PageStatic().playbarHeight.toDouble()+MediaQuery.of(context).padding.bottom,
                width: MediaQuery.of(context).size.width*(p.nowPlay['duration']==0 ? 0.0 : p.playProgress.value/1000/p.nowPlay["duration"]>1 ? 1.0 : p.playProgress.value/1000/p.nowPlay["duration"]<0 ? 0 : p.playProgress.value/1000/p.nowPlay["duration"]),
                color: Colors.blue[50]!.withAlpha(170),
              )
            )
          ),
          Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) async {
                  if(details.delta.dy<-10){
                    toPlaying();
                  }
                },
                onTap: (){
                  toPlaying();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  height: PageStatic().playbarHeight.toDouble(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Obx(()=>
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          p.switchHero.value ? Hero(
                            tag: 'cover',
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: p.nowPlay['id'].isNotEmpty ? NetworkImage("${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}"):
                                  const AssetImage("assets/blank.jpg")
                                )
                              ),
                            ),
                          ) : Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: p.nowPlay['id'].isNotEmpty ? NetworkImage("${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}"):
                                const AssetImage("assets/blank.jpg")
                              )
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.nowPlay['title'],
                                  style: GoogleFonts.notoSansSc(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  p.nowPlay['artist'],
                                  style: GoogleFonts.notoSansSc(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                    decoration: TextDecoration.none,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
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
                              height: 40,
                              width: 40,
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2
                                )
                              ),
                              child: Icon(
                                p.isPlay.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          IconButton(
                            onPressed: (){
                              p.handler.skipToNext();
                            },
                            icon: const Icon(Icons.skip_next_rounded),
                          )
                        ],
                      )
                    ),
                  )
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          )
        ],
      ),
    );
  }
}