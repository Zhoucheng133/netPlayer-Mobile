// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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

  late OverlayEntry overlayEntry;

  void setOverlayPlayingBar(BuildContext context){
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: PlayingBar()
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
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom+PageStatic().playbarHeight),
        child: const IndexBody()
      ),
    );
  }
}