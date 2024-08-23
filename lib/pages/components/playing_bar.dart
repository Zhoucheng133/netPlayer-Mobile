// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/playing.dart';
import 'package:netplayer_mobile/variables/page_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class PlayingBar extends StatefulWidget {
  const PlayingBar({super.key});

  @override
  State<PlayingBar> createState() => _PlayingBarState();
}

class _PlayingBarState extends State<PlayingBar> {

  PlayerVar p=Get.put(PlayerVar());
  final UserVar u = Get.put(UserVar());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) async {
            if(details.delta.dy<-10){
              Get.to(
                ()=>Playing(),
                transition: Transition.downToUp,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 400),
              );
            }
          },
            onTap: (){
              Get.to(
                ()=>Playing(),
                transition: Transition.downToUp,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 400),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)
                )
              ),
              height: PageStatic().playbarHeight.toDouble(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: Obx(()=>
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
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
                      SizedBox(width: 10,),
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
                            ),
                            Text(
                              p.nowPlay['artist'],
                              style: GoogleFonts.notoSansSc(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.grey[400],
                                decoration: TextDecoration.none,
                              ),
                            )
                          ],
                        ),
                      ),
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
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 2
                            )
                          ),
                          child: Icon(
                            p.isPlay.value ? Icons.pause_rounded : Icons.play_arrow_rounded
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: (){
                          p.handler.skipToNext();
                        },
                        child: Icon(Icons.skip_next_rounded),
                      )
                    ],
                  )
                ),
              )
            ),
          ),
          Container(
            height: MediaQuery.of(context).padding.bottom,
            color: Colors.grey[100],
          )
        ],
      ),
    );
  }
}