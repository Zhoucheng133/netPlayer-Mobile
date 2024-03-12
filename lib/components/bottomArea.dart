// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class BottomArea extends StatefulWidget {

  final ValueChanged changeSize;

  const BottomArea({super.key, required this.changeSize});

  @override
  State<BottomArea> createState() => _BottomAreaState();
}

class _BottomAreaState extends State<BottomArea> {

  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.lyrics),
              Obx(() => 
                c.fullRandom.value ? Icon(
                  Icons.shuffle_rounded,
                  color: Colors.grey,
                ) : 
                c.playMode.value=="随机播放" ? Icon(Icons.shuffle_rounded) : 
                c.playMode.value=="顺序播放" ? Icon(Icons.repeat_rounded) :
                Icon(Icons.repeat_one_rounded),
              ),
              Icon(Icons.more_horiz_rounded)
            ],
          ),
        )
      ],
    );
  }
}