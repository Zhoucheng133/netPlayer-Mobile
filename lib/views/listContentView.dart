// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/playingBar.dart';
import 'package:netplayer_mobile/para/para.dart';

class listContentView extends StatefulWidget {
  const listContentView({super.key, required this.audioHandler, required this.item});

  final Map item;
  final dynamic audioHandler;

  @override
  State<listContentView> createState() => _listContentViewState();
}

class _listContentViewState extends State<listContentView> {
  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.item["name"]),
        backgroundColor: Colors.white,
        foregroundColor: c.mainColor,
      ),
      body: Stack(
        children: [
          Center(child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("内容页，测试按钮"))),
          Positioned(
            bottom: 0,
            height: 110,
            child: Column(
              children: [
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, -3), // 在顶部添加阴影偏移
                      ),
                    ],
                  ),
                  // color: Colors.white,
                  child: playingBar(audioHandler: widget.audioHandler,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  color: Color.fromARGB(255, 250, 250, 250),
                )
              ],
            )
          )
        ]
      ),
    );
  }
}