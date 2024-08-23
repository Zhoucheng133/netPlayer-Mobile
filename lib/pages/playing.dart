import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
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
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(()=>
                        Container(
                          height: MediaQuery.of(context).size.width-150,
                          width: MediaQuery.of(context).size.width-150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: p.nowPlay['id'].isNotEmpty ? NetworkImage("${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}"):
                              const AssetImage("assets/blank.jpg")
                            )
                          ),
                        )
                      )
                    ],
                  ),
                )
              ),
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
                  children: [
                    
                  ],
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