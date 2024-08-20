
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/components/index_body_item.dart';
import 'package:netplayer_mobile/pages/components/index_body_list.dart';
import 'package:netplayer_mobile/variables/page_var.dart';

class IndexBody extends StatefulWidget {
  const IndexBody({super.key});

  @override
  State<IndexBody> createState() => _IndexBodyState();
}

class _IndexBodyState extends State<IndexBody> {

  PageVar p=Get.put(PageVar());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100]
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '主页',
                  style: GoogleFonts.notoSansSc(
                    fontSize: 35,
                    fontWeight: FontWeight.w300,
                    color: Colors.black
                  ),
                ),
                SizedBox(height: 20,),
                Obx(()=>
                  Row(
                    children: [
                      MenuItem(isSet: p.index.value==0, name: '固定项',),
                      SizedBox(width: 30,),
                      MenuItem(isSet: p.index.value==1, name: '歌单')
                    ],
                  )
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: IndexBodyList()
        )
      ],
    );
  }
}