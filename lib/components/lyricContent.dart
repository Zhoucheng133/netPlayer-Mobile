// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, unrelated_type_equality_checks, prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:decimal/decimal.dart';

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

  final d = (String s) => Decimal.parse(s);

  void scrollLyric(){
    var moveLength=0.0;
    Decimal dLength=Decimal.zero;
    for(var i=0;i<c.lyricLine.value;i++){
      var lineNum=d(getTextWidth(c.lyric[i]['content'], 18).toString())~/d((widget.height).toString());
      dLength+=(d((lineNum+BigInt.one).toString())*d('41.4'));
    }
    moveLength=dLength.toDouble();
    if(lyricScroll.hasClients){
      lyricScroll.animateTo(
        moveLength, 
        duration: Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
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
    
    ever(c.showLyric, (callback){
      if(c.showLyric==true){
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
              index==0 ? SizedBox(height: widget.height/2-18*2.3,) : Container(),
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