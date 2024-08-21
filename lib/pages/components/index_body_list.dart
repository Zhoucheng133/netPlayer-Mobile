// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/all.dart';
import 'package:netplayer_mobile/pages/components/index_body_item.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/page_var.dart';

class IndexBodyList extends StatefulWidget {
  const IndexBodyList({super.key});

  @override
  State<IndexBodyList> createState() => _IndexBodyListState();
}

class _IndexBodyListState extends State<IndexBodyList> {

  ScrollController controller=ScrollController();
  PageVar p=Get.put(PageVar());
  LsVar ls=Get.put(LsVar());

  @override
  void initState() {
    super.initState();
    controller.addListener((){
      if(controller.offset>200){
        p.index.value=1;
      }else{
        p.index.value=0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      child: ListView(
        controller: controller,
        children: [
          SizedBox(height: 10,),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IndexPinItem(icon: Icons.queue_music_rounded, label: '所有歌曲', bgColor: Colors.blue[50]!, contentColor: Colors.blue, func: ()=>Get.to(All()),),
                const SizedBox(width: 10,),
                IndexPinItem(icon: Icons.favorite_rounded, label: '喜欢的歌曲', bgColor: Colors.red[50]!, contentColor: Colors.red, func: () {  },),
                const SizedBox(width: 10,),
                IndexPinItem(icon: Icons.mic_rounded, label: '艺人', bgColor: Colors.blue[50]!, contentColor: Colors.blue, func: () {  },),
                const SizedBox(width: 10,),
                IndexPinItem(icon: Icons.album_rounded, label: '专辑', bgColor: Colors.blue[50]!, contentColor: Colors.blue, func: () {  },),
              ],
            )
          ),
          SizedBox(height: 20,),
          Text(
            '歌单',
            style: GoogleFonts.notoSansSc(
              fontSize: 25,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 10,),
          Obx(()=>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(ls.playList.length, (index){
                return Column(
                  children: [
                    PlayListItem(name: ls.playList[index]['name'], id: ls.playList[index]['id'], songCount: ls.playList[index]['songCount'], coverArt: ls.playList[index]['coverArt']),
                    if (index != ls.playList.length - 1) SizedBox(height: 10),
                  ],
                );
              }),
            )
          )
        ],
      ),
    );
  }
}