// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/index_body.dart';
import 'package:netplayer_mobile/variables/len_var.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  Account account=Account();
  LenVar l=Get.put(LenVar());
  int pageIndex=0;
  DataGet dataGet=DataGet();

  late OverlayEntry overlayEntry;

  void setOverlayPlayingBar(BuildContext context){
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        right: 10.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.blueAccent,
            child: const Text(
              'This is an overlay',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
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

  void logout(){
    account.logout();
    removeOverlayPlayingBar();
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
          GestureDetector(
            onTap: (){
              logout();
            },
            child: Icon(
              Icons.more_vert_rounded
            ),
          ),
          SizedBox(width: 30,)
        ],
      ),
      body: Obx(()=>
        Padding(
          padding: EdgeInsets.only(bottom: l.bottomLen.value),
          child: const IndexBody()
        ),
      )
    );
  }
}