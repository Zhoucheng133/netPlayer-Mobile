// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class playingView extends StatefulWidget {
  const playingView({super.key});

  @override
  State<playingView> createState() => _playingViewState();
}

class _playingViewState extends State<playingView> {
  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onVerticalDragUpdate: (details){
          if(details.delta.dy>10){
            Navigator.pop(context);
        }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.swipe_down_alt,
                  size: 40,
                  color: c.mainColor,
                ),
              ),
              SizedBox(height: 40,),
              Hero(
                tag: "cover",
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset.zero,
                      )
                    ]
                  ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}