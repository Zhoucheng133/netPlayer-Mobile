// ignore_for_file: prefer_const_constructors

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/index_body.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
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

  late OverlayEntry overlayEntry;

  void setOverlayPlayingBar(BuildContext context){
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Obx(()=>
        AnimatedPositioned(
          bottom: 0,
          right: 0,
          left: 0,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: p.showPlayingBar.value ? PlayingBar(key: Key("0"),) : Container(key: Key("1"),),
          ) 
        ),
      )
    );
    overlayState.insert(overlayEntry);
  }

  void removeOverlayPlayingBar(){
    overlayEntry.remove();
  }
  
  @override
  void initState() {
    super.initState();
    dataGet.getPlayLists();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setOverlayPlayingBar(context);
    });
  }

  Future<void> logout(BuildContext context) async {
    p.showPlayingBar.value=false;
    final rlt=await showOkCancelAlertDialog (
      context: context,
      title: "注销",
      message: "确定要注销吗？这会返回到登录界面",
      okLabel: "注销",
      cancelLabel: "取消",
    );
    if(rlt==OkCancelResult.ok){
      account.logout();
      removeOverlayPlayingBar();
    }
    p.showPlayingBar.value=true;
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
      body: const IndexBody(),
    );
  }
}