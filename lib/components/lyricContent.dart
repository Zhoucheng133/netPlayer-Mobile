// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class lyricContent extends StatefulWidget {
  const lyricContent({super.key, required this.height});

  final double height;

  @override
  State<lyricContent> createState() => _lyricContentState();
}

class _lyricContentState extends State<lyricContent> {
  final Controller c = Get.put(Controller());
  final ScrollController lyricScroll=ScrollController();

  bool playedLyric(index){
    bool flag=false;
    try {
      flag=c.nowDurationInMc>c.lyric[index]['time'] && c.nowDurationInMc<c.lyric[index+1]['time'];
    } catch (e) {
      flag=false;
    }
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
      ListView.builder(
        itemCount: c.lyric.length,
        controller: lyricScroll,
        itemBuilder: (BuildContext context, int index){
          return Column(
            children: [
              index==0 ? SizedBox(height: widget.height/2,) : Container(),
              Obx(() => 
                Text(
                  c.lyric[index]['content'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 2.3,
                    color: playedLyric(index) ? c.mainColor:Colors.grey,
                    fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                  ),
                ),
              ),
              index==c.lyric.length-1 ? SizedBox(height: widget.height/2,) : Container(),
            ],
          );
        }
      )
    );
  }
}