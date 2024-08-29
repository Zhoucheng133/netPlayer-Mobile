import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/operations/player_control.dart';
import 'package:netplayer_mobile/pages/about.dart';
import 'package:netplayer_mobile/pages/albums.dart';
import 'package:netplayer_mobile/pages/all.dart';
import 'package:netplayer_mobile/pages/artists.dart';
import 'package:netplayer_mobile/pages/components/index_item.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/loved.dart';
import 'package:netplayer_mobile/pages/search.dart';
import 'package:netplayer_mobile/pages/settings.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/page_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

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
  LsVar l=Get.put(LsVar());
  PlayerVar pl=Get.put(PlayerVar());
  SettingsVar s=Get.put(SettingsVar());

  Future<void> initGet(BuildContext context) async {
    if(context.mounted){
      await dataGet.getPlayLists(context);
    }
    if(context.mounted){
      l.loved.value=await dataGet.getLoved(context);
    }
  }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initGet(context);
    });
    controller.addListener((){
      if(controller.offset>200){
        p.index.value=1;
      }else{
        p.index.value=0;
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
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
    controller.animateTo(index*230, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        leading: Row(
          children: [
            Expanded(child: Container()),
            IconButton(
              onPressed: (){
                Get.to(()=>const Search());
              }, 
              icon: const Icon(
                Icons.search_rounded
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final rlt=await showModalActionSheet(
                context: context,
                title: '更多...',
                actions: [
                  const SheetAction(label: '随机播放所有歌曲', icon: Icons.shuffle_rounded, key: 'shuffle'),
                  const SheetAction(label: '设置', icon: Icons.settings_rounded, key: 'settings'),
                  const SheetAction(label: '关于', icon: Icons.info_rounded, key: 'about'),
                  const SheetAction(label: '注销', icon: Icons.logout_rounded, key: 'logout'),
                ]
              );
              if(rlt!=null){
                if(rlt=='shuffle'){
                  PlayerControl().shufflePlay();
                }else if(rlt=='settings'){
                  Get.to(()=>const Settings());
                }else if(rlt=='about'){
                  Get.to(()=>const About());
                }else if(rlt=='logout'){
                  if(context.mounted){
                    logout(context);
                  }
                }
              }
            }, 
            icon: const Icon(
              Icons.more_vert_rounded,
            )
          ),
          const SizedBox(width: 10,)
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
                  const SizedBox(height: 20,),
                  Obx(()=>
                    Row(
                      children: [
                        MenuItem(isSet: p.index.value==0, name: '固定项', func: ()=>jumpIndex(0),),
                        const SizedBox(width: 30,),
                        MenuItem(isSet: p.index.value==1, name: '歌单', func: ()=>jumpIndex(1),)
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: ()=>initGet(context),
              child: Obx(()=>
                CustomScrollView(
                  controller: controller,
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 15,),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            const SizedBox(width: 20,),
                            IndexPinItem(icon: Icons.queue_music_rounded, label: '所有歌曲', bgColor: Colors.blue[50]!, contentColor: Colors.blue, func: ()=>Get.to(()=>const All()),),
                            const SizedBox(width: 10,),
                            IndexPinItem(icon: Icons.favorite_rounded, label: '喜欢的歌曲', bgColor: Colors.red[50]!, contentColor: Colors.red, func: ()=>Get.to(()=>const Loved()),),
                            const SizedBox(width: 10,),
                            IndexPinItem(icon: Icons.mic_rounded, label: '艺人', bgColor: Colors.blue[50]!, contentColor: Colors.blue, func: ()=>Get.to(()=>const Artists()),),
                            const SizedBox(width: 10,),
                            IndexPinItem(icon: Icons.album_rounded, label: '专辑', bgColor: Colors.blue[50]!, contentColor: Colors.blue, func: ()=>Get.to(()=>const Albums()),),
                            const SizedBox(width: 20,),
                          ],
                        ),
                      )
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20,),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '歌单',
                              style: GoogleFonts.notoSansSc(
                                fontSize: 25,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            const SizedBox(width: 10,),
                            IconButton(
                              onPressed: () async {
                                var rlt=await showTextInputDialog(
                                  context: context,
                                  title: "创建一个新的歌单",
                                  textFields: [
                                    const DialogTextField(
                                      hintText: "新歌单名称"
                                    )
                                  ],
                                );
                                if(rlt!=null){
                                  // print(rlt[0]);
                                  if(context.mounted){
                                    Operations().newPlayList(rlt[0], context);
                                  }
                                }
                              }, 
                              icon: const Icon(Icons.add_rounded)
                            )
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 10,),
                    ),
                    SliverList.builder(
                      itemCount: ls.playList.length,
                      itemBuilder: (context, index){
                        return PlayListItem(name: ls.playList[index]['name'], id: ls.playList[index]['id'], songCount: ls.playList[index]['songCount'], coverArt: ls.playList[index]['coverArt']);
                      }
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 10,),
                    ),
                  ],
                )
              )
            ),
          ),
          const PlayingBar()
        ],
      ),
    );
  }
}