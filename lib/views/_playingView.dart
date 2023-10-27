// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class playingView extends StatefulWidget {
  const playingView({super.key, required this.audioHandler});

  final dynamic audioHandler;

  @override
  State<playingView> createState() => _playingViewState();
}

class _playingViewState extends State<playingView> {
  final Controller c = Get.put(Controller());

  Timer? _debounce;

  void _handleSliderChange(double value) {
    c.updateNowDuration((value*c.playInfo["duration"]).round());
    widget.audioHandler.pause();
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      // print('用户完成滑动，执行你的代码，value: $value');
      widget.audioHandler.seek(Duration(seconds: (value*c.playInfo["duration"]).round()));
    });
  }

  void playController(){
    if(c.isPlay.value==true){
      widget.audioHandler.pause();
    }else{
      widget.audioHandler.play();
    }
  }

  String timeConvert(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (details){
            if(details.delta.dy>10){
                Navigator.pop(context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 250, 250, 250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.swipe_down_alt,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "向下滑动返回",
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Hero(
                  tag: "cover",
                  child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width-120,
                    height: MediaQuery.of(context).size.width-120,
                    color: Colors.white,
                    duration: Duration(milliseconds: 200),
                    child: Obx(() => 
                      c.playInfo["id"]==null ?
                      Image.asset(
                        "assets/blank.jpg",
                        fit: BoxFit.contain,
                      ) : 
                      Image.network(
                        "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}",
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/blank.jpg",
                            fit: BoxFit.contain,
                          );
                        },
                      )
                    ),
                  ),
                ),
                Container(
                  height: 130,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Obx(() => 
                        Text(
                          c.playInfo["title"]==null ? "没有播放" : c.playInfo["title"].toString(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: Obx(() => 
                          Text(
                            c.playInfo["title"]==null ? "/" : c.playInfo["artist"].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          overlayColor: Colors.transparent,
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0), // 取消波纹效果
                          activeTrackColor: Colors.black, // 设置已激活轨道的颜色
                          inactiveTrackColor: Colors.grey[200], 
                          trackHeight: 2,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 8, // 设置滑块的半径
                            pressedElevation: 5,
                            elevation: 1,
                          ),
                          thumbColor: Colors.black
                        ),
                        child: Obx(() => 
                          c.nowDuration!=0 ?
                          Slider(
                            value: (c.nowDuration.value/c.playInfo["duration"]),
                            onChanged: (value) {
                              _handleSliderChange(value);
                            },
                          ) : 
                          Slider(
                            value: 0,
                            onChanged: (value) {
                              // 没有在播放的情况下，不需要任何操作
                            },
                          )
                        )
                      ),
                      Row(
                        children: [
                          Obx(() => 
                            Text(
                              timeConvert(c.nowDuration.value),
                            ),
                          ),
                          Expanded(child: Container()),
                          Obx(() => 
                            Text(
                              // TODO 有错误
                              timeConvert(c.playInfo["duration"]),
                            )
                          )
                        ],
                      )
                    ],
                  ),
                ),
                // Text("hello?"),
                SizedBox(height: 20,),
                Obx(() => 
                  c.randomPlay.value==true ? 
                  GestureDetector(
                    onTap: (){
                      c.updateRandomPlay(false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shuffle
                        ),
                        SizedBox(width: 5,),
                        Text("随机播放")
                      ],
                    ),
                  ) :
                  GestureDetector(
                    onTap: (){
                      c.updateRandomPlay(true);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.all_inclusive
                        ),
                        SizedBox(width: 5,),
                        Text("顺序播放")
                      ],
                    ),
                  )
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        widget.audioHandler.skipToPrevious();
                      },
                      child: Icon(
                        Icons.skip_previous_rounded,
                        size: 65,
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        playController();
                      },
                      child: Obx(() => 
                        c.isPlay==true ? 
                        Icon(
                          Icons.pause_rounded,
                          size: 70,
                        ):
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 70,
                        )
                      )
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        widget.audioHandler.skipToNext();
                      },
                      child: Icon(
                        Icons.skip_next_rounded,
                        size: 65,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}