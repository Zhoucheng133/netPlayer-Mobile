// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

void moreOperations(BuildContext context, Map item){
  final Controller c = Get.put(Controller());
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
          color: Colors.white
        ),
        // height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Obx(() => 
                      Image.network(
                        "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${item["id"]}",
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/blank.jpg",
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        item["title"],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        item["artist"]
                      )
                    ],
                  )
                ],
              ),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 40,
                      color: Colors.red,
                    ),
                    SizedBox(width: 20,),
                    Text(
                      "添加到到\"我喜欢的\"",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      );
    },
  );
}