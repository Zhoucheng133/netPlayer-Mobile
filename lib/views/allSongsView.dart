// ignore_for_file: prefer_const_constructors, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:netplayer_mobile/functions/requests.dart';

class allSongsView extends StatefulWidget {
  const allSongsView({super.key});

  @override
  State<allSongsView> createState() => _allSongsViewState();
}

class _allSongsViewState extends State<allSongsView> {

  List songList=[];

  Future<void> getList() async {
    // print(await allSongsRequest());
    // songList=await 
    var tmp=await allSongsRequest();
    if(tmp["status"]!="ok"){
      // TODO 登录错误，返回登录页面
    }else{
      songList=tmp["randomSongs"]["song"];
    }
  }

  @override
  void initState() {
    super.initState();

    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(

        )
      ],
    );
  }
}