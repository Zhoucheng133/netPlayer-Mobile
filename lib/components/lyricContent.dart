// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, unrelated_type_equality_checks, prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class lyricContent extends StatefulWidget {
  const lyricContent({super.key, required this.height});

  final double height;

  @override
  State<lyricContent> createState() => _lyricContentState();
}

class _lyricContentState extends State<lyricContent> {
  final Controller c = Get.put(Controller());
  final AutoScrollController lyricScroll=AutoScrollController();

  bool playedLyric(index){
    if(c.lyric.length==1){
      return true;
    }
    bool flag=false;
    try {
      flag=c.nowDurationInMc>=c.lyric[index]['time'] && c.nowDurationInMc<c.lyric[index+1]['time'];
    } catch (e) {
      flag=false;
    }
    return flag;
  }

  // 获取文本如果平铺宽度
  double getTextWidth(String text, double fontSize) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }

  void scrollLyric(){
    if(c.fronted.value && c.menuType.value=="lyric" && c.lyricLine.value!=0){
      lyricScroll.scrollToIndex(c.lyricLine.value-1, preferPosition: AutoScrollPosition.middle);
    }
  }

  @override
  void initState() {
    super.initState();
    ever(c.lyricLine, (callback) {
      if(c.lyricLine==0 && lyricScroll.hasClients){
        lyricScroll.animateTo(
          0,
          duration: Duration(milliseconds: 300), 
          curve: Curves.easeInOut
        );
      }else{
        scrollLyric();
      }
      
    });
    
    ever(c.menuType, (callback){
      // print("changed: ${c.menuType.value}");
      if(c.menuType.value=="lyric"){
        if(c.lyricLine==0 && lyricScroll.hasClients){
          lyricScroll.animateTo(
            0,
            duration: Duration(milliseconds: 300), 
            curve: Curves.easeInOut
          );
        }else{
          scrollLyric();
        }
      }
    });

    ever(c.fronted, (callback){
      scrollLyric();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
      AnimatedOpacity(
        opacity: c.menuType.value=="lyric" ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: ListView.builder(
            itemCount: c.lyric.length,
            controller: lyricScroll,
            itemBuilder: (BuildContext context, int index){
              return Column(
                children: [
                  index==0 ? SizedBox(height: 100,) : Container(),
                  Obx(() => 
                    AutoScrollTag(
                      key: ValueKey(index), 
                      controller: lyricScroll, 
                      index: index,
                      child: Text(
                        c.lyric[index]['content'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          height: 2.3,
                          color: playedLyric(index) ? c.mainColor:Colors.grey,
                          fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )
                  ),
                  index==c.lyric.length-1 ? SizedBox(height: 100,) : Container(),
                ],
              );
            }
          ),
        ),
      )
    );
  }
}