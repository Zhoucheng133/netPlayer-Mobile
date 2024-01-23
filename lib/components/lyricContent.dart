// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class lyricContent extends StatefulWidget {
  const lyricContent({super.key});

  @override
  State<lyricContent> createState() => _lyricContentState();
}

class _lyricContentState extends State<lyricContent> {
  final Controller c = Get.put(Controller());
  final ScrollController lyricScroll=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
      ListView.builder(
        itemCount: c.lyric.length,
        controller: lyricScroll,
        itemBuilder: (BuildContext context, int index){
          return Text(c.lyric[index]['content']);
        }
      )
    );
  }
}