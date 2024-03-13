// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unrelated_type_equality_checks, use_build_context_synchronously, invalid_use_of_protected_member

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/bottomArea.dart';
import 'package:netplayer_mobile/functions/requests.dart';
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

  void failDialog(BuildContext context){
    if(Platform.isIOS){
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("操作失败!"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('好'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("操作失败!"),
            actions: <Widget>[
              TextButton(
                child: Text('好'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  Future<void> reloadLoved() async {
    var tmp=await lovedSongRequest();
    c.updateLovedSongs(tmp);

    if(c.playInfo["name"]=="lovedSongs"){
      int index = c.lovedSongs.indexWhere((element) => element["id"] == c.playInfo["id"]);
      if(index==-1){
        widget.audioHandler.stop();
        c.updatePlayInfo({});
        return;
      }
      var tmpPlayInfo=c.playInfo.value;
      tmpPlayInfo["index"]=index;
      tmpPlayInfo["list"]=c.lovedSongs.value;
      c.updatePlayInfo(tmpPlayInfo);
    }
  }

  var isCalled=false;

  // var showBottom=false;

  var positionBottomSize=-500.0;
  void changeSize(double val){
    setState(() {
      positionBottomSize=val-600.0;
    });
    if(val==100){
      Timer(Duration(milliseconds: 300), () { 
        setState(() {
          showShadow=false;
        });
      });
    }else{
      showShadow=true;
    }
  }

  var showShadow=false;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: GestureDetector(
              onVerticalDragUpdate: (details) async {
                if(details.delta.dy>10){
                  // TODO 下面的代码需要重新编写
                  if(isCalled){
                    return;
                  }
                  if(!c.showLyric.value){
                    Navigator.pop(context);
                    setState(() {
                      isCalled=true;
                    });
                  }else{
                    c.updateShowLyric(false);
                    Future.delayed(Duration(milliseconds: 300), (){
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    });
                    setState(() {
                      isCalled=true;
                    });
                  }
                }
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe_down_alt,
                          size: 30,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          "向下滑动返回",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40,),
                        // 封面
                        Hero(
                          tag: "cover",
                          child: AnimatedContainer(
                            width: MediaQuery.of(context).size.width-100,
                            height: MediaQuery.of(context).size.width-100,
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
                        SizedBox(height: 10,),
                        // 标题和艺术家信息
                        SizedBox(
                          width: MediaQuery.of(context).size.width-120,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => 
                                      Text(
                                        c.playInfo["title"]==null ? "没有播放" : c.playInfo["title"].toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ),
                                    Obx(() => 
                                      Text(
                                        c.playInfo["title"]==null ? "/" : c.playInfo["artist"].toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ),
                                  ],
                                )
                              ),
                              SizedBox(width: 10,),
                              Obx(() => 
                                (c.playInfo.isNotEmpty && c.fav(c.playInfo['id'])) ? 
                                GestureDetector(
                                  onTap: () async {
                                    if(await setDelove(c.playInfo['id'])==false){
                                      failDialog(context);
                                    }
                                    reloadLoved();
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ) : 
                                GestureDetector(
                                  onTap: () async {
                                    if(c.playInfo.isNotEmpty){
                                      if(await setLove(c.playInfo['id'])==false){
                                        failDialog(context);
                                      }
                                      reloadLoved();
                                    }else{
                                      return;
                                    }
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.grey,
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        // 进度条
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: SliderTheme(
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
                              c.playInfo["duration"] is num && c.playInfo["duration"]!=0 ?
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            children: [
                              Obx(() => 
                                Text(
                                  timeConvert(c.nowDuration.value),
                                ),
                              ),
                              Expanded(child: Container()),
                              Obx(() => 
                                Text(
                                  c.playInfo.isEmpty ? 
                                  "0:00" :
                                  timeConvert(c.playInfo["duration"]),
                                )
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        // 控制播放
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
                        SizedBox(height: 70,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: showShadow ? GestureDetector(
            onTap: (){
              c.updateMenuType("");
              changeSize(100);
            },
            onVerticalDragUpdate: (details) async {
              if(details.delta.dy>10){
                c.updateMenuType("");
                changeSize(100.0);
              }
            },
            child: Obx(() => 
              AnimatedOpacity(
                opacity: c.menuType=="" ? 0 : 0.7, 
                duration: Duration(milliseconds: 300),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black,
                ),
              ),
            )
          ) : Container(),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              left: 0,
              bottom: positionBottomSize,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                height: 600,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: BottomArea(changeSize: (value) => changeSize(value),)
              )
            ),
          ],
        )
      ],
    );
  }
}
