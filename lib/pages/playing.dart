import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Playing extends StatefulWidget {
  const Playing({super.key});

  @override
  State<Playing> createState() => _PlayingState();
}

class _PlayingState extends State<Playing> {
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
        child: Column(
          children: [
            TitleAria(title: "怪物", subtitle: "Yoasobi"),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/blank.jpg")
                        )
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        )
      )
    );
  }
}