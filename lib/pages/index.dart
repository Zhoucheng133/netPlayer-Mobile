// ignore_for_file: prefer_const_constructors

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/all.dart';
import 'package:netplayer_mobile/pages/components/index_item.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
// import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/variables/page_var.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  Account account=Account();
  int pageIndex=0;
  DataGet dataGet=DataGet();
  PageVar p=Get.put(PageVar());
  
  @override
  void initState() {
    super.initState();
    dataGet.getPlayLists();
    controller.addListener((){
      if(controller.offset>200){
        p.index.value=1;
      }else{
        p.index.value=0;
      }
    });
  }

  Future<void> logout(BuildContext context) async {
    // p.showPlayingBar.value=false;
    final rlt=await showOkCancelAlertDialog (
      context: context,
      title: "注销",
      message: "确定要注销吗？这会返回到登录界面",
      okLabel: "注销",
      cancelLabel: "取消",
    );
    if(rlt==OkCancelResult.ok){
      account.logout();
    }
  }

  ScrollController controller=ScrollController();
  LsVar ls=Get.put(LsVar());

  void jumpIndex(int index){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        leading: const Row(
          children: [
            SizedBox(width: 30,),
            Icon(
              Icons.search_rounded
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (BuildContext context)=>[
              PopupMenuItem(
                onTap: (){
                  // TODO 跳转到设置
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.settings_rounded,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    Text('设置'),
                  ],
                )
              ),
              PopupMenuItem(
                onTap: (){
                  // TODO 跳转到关于
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_rounded,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    Text('关于'),
                  ],
                )
              ),
              PopupMenuItem(
                onTap: (){
                  logout(context);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    Text('注销'),
                  ],
                )
              )
            ],
            child: const Icon(
              Icons.more_vert_rounded
            ),
          ),
          SizedBox(width: 30,)
        ],
      ),
      body: Column(
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
                        MenuItem(isSet: p.index.value==0, name: '固定项', func: ()=>jumpIndex(0),),
                        SizedBox(width: 30,),
                        MenuItem(isSet: p.index.value==1, name: '歌单', func: ()=>jumpIndex(1),)
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
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
                            index != ls.playList.length - 1 ? SizedBox(height: 10) : Container()
                          ],
                        );
                      }),
                    )
                  )
                ],
              ),
            ),
          ),
          Hero(
            tag: "playingbar",
            child: PlayingBar()
          )
        ],
      ),
    );
  }
}