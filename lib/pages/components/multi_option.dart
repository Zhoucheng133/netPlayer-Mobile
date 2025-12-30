import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class MultiOption extends StatefulWidget {

  final bool fromPlaylist;
  final String listId;

  const MultiOption({super.key, required this.fromPlaylist, required this.listId});

  @override
  State<MultiOption> createState() => _MultiOptionState();
}

class _MultiOptionState extends State<MultiOption> {

  DialogVar d=Get.find();
  LsVar l=Get.find();
  final SettingsVar s=Get.find();

  Future<void> showOption(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: 'addToPlaylist'.tr, key: "add", icon: Icons.playlist_add_rounded),
        if(widget.fromPlaylist) ActionItem(name: "removeFromPlaylist".tr, key: "delist", icon: Icons.playlist_remove_rounded, ),
        ActionItem(name: "download".tr, key: "download", icon: Icons.download_rounded),
      ]
    );

    if(req=="add"){ 
      if(l.playList.isEmpty && context.mounted){
        d.showOkDialog(context: context, title: "cantAddToPlaylist".tr, content: "noPlaylist".tr);
        return;
      }
      if(context.mounted){
        var listId = await d.showActionSheet(
          context: context, 
          list: List.generate(l.playList.length, (index){
            return ActionItem(
              icon: Icons.playlist_play_rounded,
              key: l.playList[index]['id'],
              name: l.playList[index]['name']
            );
          })
        );
        // print(listId);
        if(listId!=null){
          if(context.mounted){
            Operations().multiAddToList(s.selectList, listId, context);
          }
        }
      }
    }else if(req=="delist"){
      // TODO 从列表中移除
    }else if(req=="download"){
      // TODO 下载
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: ()=>showOption(context), 
      icon: Icon(Icons.more_vert_rounded)
    );
  }
}