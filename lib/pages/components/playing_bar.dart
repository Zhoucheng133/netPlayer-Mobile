// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/playing.dart';
import 'package:netplayer_mobile/variables/page_var.dart';

class PlayingBar extends StatefulWidget {
  const PlayingBar({super.key});

  @override
  State<PlayingBar> createState() => _PlayingBarState();
}

class _PlayingBarState extends State<PlayingBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
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
            child: Container()
          ),
        ),
        Container(
          height: MediaQuery.of(context).padding.bottom,
          color: Colors.grey[100],
        )
      ],
    );
  }
}