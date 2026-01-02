import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/download_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class MultiOption extends StatefulWidget {

  final bool fromPlaylist;
  final String listId;
  final bool fromDownload;
  final List target;

  const MultiOption({super.key, required this.fromPlaylist, required this.listId, this.fromDownload=false, this.target=const []});

  @override
  State<MultiOption> createState() => _MultiOptionState();
}

class _MultiOptionState extends State<MultiOption> {

  DialogVar d=Get.find();
  LsVar l=Get.find();
  final SettingsVar s=Get.find();
  DownloadVar downloadVar=Get.find();

  Future<void> showDownloadOption(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: 'delete'.tr, key: "delete", icon: Icons.delete_rounded),
      ]
    );

    if(req=="delete"){

      final confirm=await d.showOkCancelDialog(
        context: context, 
        title: 'deleteTheseSongs'.tr, 
        content: 'deleteTheseSongsContent'.tr,
        okText: 'delete'.tr
      );
      if(confirm){
        for(var element in widget.target) {
          await downloadVar.delete(element);
        }
        s.selectMode.value=false;
      }
    }
  }

  Future<void> showOption(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: 'addToPlaylist'.tr, key: "add", icon: Icons.playlist_add_rounded),
        ActionItem(name: "download".tr, key: "download", icon: Icons.download_rounded),
      ]
    );

    if(req=="add"){ 
      if(l.playList.isEmpty && context.mounted){
        d.showOkDialog(context: context, title: "cantAddToPlaylist".tr, content: "noPlaylist".tr);
      }else if(s.selectList.isNotEmpty && context.mounted){
        String selectedId = l.playList[0]['id'];
        await d.showOkCancelDialogRaw(
          context: context,
          title: "addToPlaylist".tr,
          okText: "add".tr,
          child: StatefulBuilder(
            builder: (context, setState) {
              return FSelect<String>(
                initialValue: selectedId,
                autoHide: true,
                format: (String id) {
                  final item = l.playList.firstWhere(
                    (e) => e['id'] == id,
                  );
                  return item['name'];
                },
                children: List.generate(l.playList.length, (index) {
                  return FSelectItem<String>(
                    l.playList[index]['name'],
                    l.playList[index]['id'],
                  );
                }),
                onChange: (val) {
                  if(val!=null){
                    setState(() {
                      selectedId = val;
                    });
                  }
                },
              );
            },
          ),
          okHandler: () async {
            await Operations().multiAddToList(s.selectList, selectedId, context);
          },
        );
      }
      s.selectMode.value = false;
    }else if(req=="download"){
      for (var element in s.selectList) {
        downloadVar.downloadSongFromId(element);
      }
      s.selectMode.value = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: ()=>widget.fromDownload ? showDownloadOption(context) : showOption(context), 
      icon: Icon(Icons.more_vert_rounded)
    );
  }
}