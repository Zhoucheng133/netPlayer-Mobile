// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../para/para.dart';

class lyricView extends StatefulWidget {
  const lyricView({super.key});

  @override
  State<lyricView> createState() => _lyricViewState();
}

class _lyricViewState extends State<lyricView> {
  final Controller c = Get.put(Controller());

  void hideLyric(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: GestureDetector(
          onHorizontalDragUpdate: (details){
            if(details.delta.dx<20){
              hideLyric();
            }
          },
          child: Center(
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
                          Icons.swipe_left_alt,
                          size: 40,
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        "向左滑动返回",
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Hero(
                    tag: "title", 
                    child: Text(
                      c.playInfo["title"]==null ? "没有播放" : c.playInfo["title"].toString(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-50,
                    height: 400,
                    color: Colors.red,
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}