// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unrelated_type_equality_checks, invalid_use_of_protected_member, use_build_context_synchronously, camel_case_types, unnecessary_brace_in_string_interps

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';

final Controller c = Get.put(Controller());

// 播放页面映射
List pageNameMap(String name, {List? playlist}){
  switch (name) {
    case "allSongs":
      return c.allSongs.value;
    case "lovedSongs":
      return c.lovedSongs.value;
    case "songList" || "album": 
      if(playlist!=null){
        return playlist;
      }else{
        return [];
      }
    default: 
      return [];
  }
}

// 播放音乐
void playSong(Map item, int index, String pageName, dynamic audioHandler, {String? listID, List? playlist}){
  var newInfo={
    "name": pageName, 
    "title": item["title"],
    "artist": item["artist"],
    "duration": item["duration"],
    "id": item["id"],
    "index": index,
    "list": pageNameMap(pageName, playlist: playlist),
    "ListId": listID ?? "",
    "album": item["album"],
  };
  c.updatePlayInfo(newInfo);
  audioHandler.play();
}

// 将歌曲添加到歌单操作
Future<void> listAddController(String listId, String songId, BuildContext context) async {
  Navigator.pop(context);
  if(await addToList(listId,songId)){
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("添加成功"),
          content: Text("你可以去我的歌单中查看"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }else{
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("操作失败!"),
          content: Text("可以尝试稍后重试"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// 将歌曲从当前歌单中删除
void songRemoveListController(String? index){
  if(index==null){
    return;
  }else{
    // TODO 从歌单中删除
  }
}

// 歌曲添加到歌单抽屉
class listAddContent extends StatefulWidget {
  const listAddContent({super.key, required this.id});

  final String id;
  @override
  State<listAddContent> createState() => _listAddContentState();
}

class _listAddContentState extends State<listAddContent> {

  List list=[];

  Future<void> getList() async {
    if(c.playLists.value.isEmpty){
      var tmp=await allListsRequest();
      setState(() {
        list=tmp;
      });
      c.updatePlayLists(list);
    }else{
      setState(() {
        list=c.playLists.value;
      });
    }
  }

  @override
  void initState() {
    getList();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "添加到歌单...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                // color: Colors.red,
                child: CupertinoScrollbar(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        listAddController(list[index]["id"], widget.id, context);
                      },
                      child: Container(
                        height: 50,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.playlist_play_rounded,
                              size: 30,
                            ),
                            SizedBox(width: 17,),
                            Text(
                              list[index]["name"],
                              style: TextStyle(
                                fontSize: 17
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              )
            ),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}

// 歌曲添加到歌单中转
void songAddListController(String id, BuildContext context){
  Navigator.of(context).pop();
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return listAddContent(
        id: id
      );
    },
  );
}

// 将歌曲从我喜欢中移除
Future<void> songDeloveController(Map item, BuildContext context, dynamic widget) async {
  Navigator.pop(context);
  if(await setDelove(item["id"])){
    widget.reloadLoved();
  }else{
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("操作失败!"),
          content: Text("可以尝试稍后重试"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// 将歌曲添加到我喜欢
Future<void> songLoveController(Map item, BuildContext context, dynamic widget) async {
  Navigator.pop(context);
  if(await setLove(item["id"])){
    widget.reloadLoved();
  }else{
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("操作失败!"),
          content: Text("可以尝试稍后重试"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// 歌单操作
class listOperation extends StatefulWidget {
  const listOperation({super.key, required this.item, required this.reloadList});

  final Map item;
  final VoidCallback reloadList;

  @override
  State<listOperation> createState() => _listOperationState();
}

// 删除歌单操作
void delList(String id, dynamic widget, BuildContext context){
  Navigator.of(context).pop();
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("确定要刷新歌单列表吗?"),
        content: Text("这不会影响当前播放"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text('确定'),
            onPressed: () async {
              if(await delListRequest(id)){
                widget.reloadList();
                Navigator.of(context).pop();
              }else{
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text("操作失败!"),
                      content: Text("可以尝试稍后重试"),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          )
        ],
      );
    },
  );
}

class _listOperationState extends State<listOperation> {
  String timeFormat(int time){
    if(time~/60>0){
      int sec=time~/60;
      time=time%60;
      if(time~/60>0){
        int hour=time%60;
        time=time%60;
        return "${hour}时${sec}分${time}秒";
      }else{
        return "${sec}分${time}秒";
      }
    }else{
      return "${time}秒";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ),
        color: Colors.white
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    widget.item["name"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  child: Text(
                    "歌曲数量: ${widget.item["songCount"]}, 总时长: ${timeFormat(widget.item["duration"])}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                // TODO 重命名歌单
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.drive_file_rename_outline,
                      size: 30,
                    ),
                    SizedBox(width: 17,),
                    Text(
                      "重命名歌单",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                delList(widget.item["id"], widget, context);
              },
              child: Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete,
                      size: 30,
                    ),
                    SizedBox(width: 17,),
                    Text(
                      "删除歌单",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 歌曲的更多操作
class moreOperations extends StatefulWidget {
  const moreOperations({super.key, required this.item, required this.index, required this.pageName, required this.audioHandler, this.listIndex, required this.reloadLoved, required this.playSong});
  final Map item;
  final int index;
  final String pageName;
  final dynamic audioHandler;
  final dynamic listIndex;

  final VoidCallback reloadLoved;
  final VoidCallback playSong;

  @override
  State<moreOperations> createState() => _moreOperationsState();
}

class _moreOperationsState extends State<moreOperations> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ),
        color: Colors.white
      ),
      // height: 200,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Obx(() => 
                    Image.network(
                      "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${widget.item["id"]}",
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
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width-40-110,
                      child: Text(
                        widget.item["title"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      widget.item["artist"],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                widget.playSong();
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      size: 30,
                    ),
                    SizedBox(width: 17,),
                    Text(
                      "播放",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    )
                  ],
                ),
              ),
            ),
            c.fav(widget.item["id"])==true ? 
            GestureDetector(
              onTap: () async {
                await songDeloveController(widget.item, context, widget);
              },
              child: Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.heart_broken,
                      size: 30,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 17,),
                    Text(
                      "从\"我喜欢的\"中删除",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    )
                  ],
                ),
              ),
            ) :
            GestureDetector(
              onTap: () async {
                await songLoveController(widget.item, context, widget);
              },
              child: Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 30,
                      color: Colors.red,
                    ),
                    SizedBox(width: 17,),
                    Text(
                      "添加到到\"我喜欢的\"",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                songAddListController(widget.item["id"], context);
              },
              child: Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.playlist_add,
                      size: 30,
                      color: Colors.black,
                    ),
                    SizedBox(width: 17,),
                    Text(
                      "加入到歌单...",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                songRemoveListController(widget.listIndex);
              },
              child: Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() => 
                      Icon(
                        Icons.playlist_remove,
                        size: 30,
                        color: c.pageIndex==2 ? Colors.black : Colors.grey,
                      )
                    ),
                    SizedBox(width: 17,),
                    Obx(() => 
                      Text(
                        "从歌单中删除",
                        style: TextStyle(
                          fontSize: 17,
                          color: c.pageIndex==2 ? Colors.black : Colors.grey,
                        ),
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );  }
}