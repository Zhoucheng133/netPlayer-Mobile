import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/operations/player_control.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/download_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class SongItemDownload extends StatefulWidget {

  final dynamic item;
  final int index;

  const SongItemDownload({super.key, this.item, required this.index});

  @override
  State<SongItemDownload> createState() => _SongItemDownloadState();
}

class _SongItemDownloadState extends State<SongItemDownload> {
  PlayerVar p=Get.find();
  LsVar l=Get.find();
  SettingsVar s=Get.find();
  UserVar u=Get.find();
  final DialogVar d=Get.find();
  final DownloadVar downloadVar=Get.find();
  final Operations operations=Operations();

  bool playing(){
    if(p.nowPlay['playFrom']=="download" && p.nowPlay['index']==widget.index){
      return true;
    }
    return false;
  }

  bool isLoved(){
    for (var val in l.loved) {
      if(val["id"]==widget.item['id']){
        return true;
      }
    }
    return false;
  }

  Future<void> showSongMenu(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: "delete".tr, key: "delete", icon: Icons.delete_rounded),
        ActionItem(name: "songInfo".tr, key: "info", icon: Icons.info_rounded),
      ]
    );
    if(req=="delete"){
      await downloadVar.delete(widget.item);
    }else if(req=="info"){
      if(context.mounted){
        d.showOkDialogRaw(
          context: context, 
          title: 'songInfo'.tr, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "songTitle".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.item['title'],
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "duration".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      operations.convertDuration(widget.item['duration']),
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "artist".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.item['artist'],
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "album".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.item['album'],
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "songId".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.item['id'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "filePath".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.item['filePath'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
            ],
          )
        );
      }
    }else if(req=='download'){
      downloadVar.downloadSongFromId(widget.item['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(s.selectMode.value){
          if(s.selectList.contains(widget.item['id'])){
            s.selectList.remove(widget.item['id']);
          }else{
            s.selectList.add(widget.item['id']);
          }
        }else{
          PlayerControl().playSong(
            context, 
            widget.item['id'], 
            widget.item['title'], 
            widget.item['artist'], 
            "download", 
            widget.item['duration'], 
            "", 
            widget.index, 
            downloadVar.downloadList.map((item)=>item.getInfo()).toList(), 
            widget.item['album'], 
            filePath: widget.item['filePath']
          );
        }
      },
      onLongPress: (){
        s.selectMode.value = true;
        s.selectList.add(widget.item['id']);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          color: Colors.transparent,
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 30,
                child: Center(
                  child: Obx(()=>
                    s.selectMode.value ? Checkbox(
                      value: s.selectList.contains(widget.item['id']), 
                      onChanged: (val){
                        if(val==true){
                          s.selectList.add(widget.item['id']);
                        }else{
                          s.selectList.remove(widget.item['id']);
                        }
                      }
                    ) : playing() ? const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.blue,
                    ) : Text((widget.index+1).toString())
                  )
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Obx(()=>
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item['title'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: playing() ? FontWeight.bold : FontWeight.normal,
                          color: playing() ? Colors.blue : s.darkMode.value ? Colors.white : Colors.black
                        ),
                      ),
                      Row(
                        children: [
                          isLoved() ? const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                              size: 15,
                            ),
                          ) : Container(),
                          Expanded(
                            child: Text(
                              widget.item['artist'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: playing() ? Colors.blue : Colors.grey[400]
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ),
              const SizedBox(width: 10,),
              IconButton(
                onPressed: () => showSongMenu(context),
                icon: Obx(()=>
                  Icon(
                    Icons.more_vert_rounded,
                    color: s.darkMode.value ? playing() ? Colors.blue : Colors.white : playing() ? Colors.blue : Colors.black,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}