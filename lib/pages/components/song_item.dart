import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/download_var.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/operations/player_control.dart';
import 'package:netplayer_mobile/pages/album_content.dart';
import 'package:netplayer_mobile/pages/artist_content.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class SongItem extends StatefulWidget {

  final dynamic item;
  final int index;
  final List ls;
  final String from;
  final String listId;
  final dynamic refresh;

  const SongItem({super.key, required this.item, required this.index, required this.ls, required this.from, required this.listId, this.refresh});

  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {

  PlayerVar p=Get.find();
  LsVar l=Get.find();
  SettingsVar s=Get.find();
  UserVar u=Get.find();
  final DialogVar d=Get.find();
  final DownloadVar downloadVar=Get.find();
  final Operations operations=Operations();

  bool playing(){
    if(p.nowPlay['fromId']==widget.listId && p.nowPlay['playFrom']==widget.from && p.nowPlay['index']==widget.index){
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

  bool downloaded(){
    return downloadVar.downloadList.any(
      (item) => item.id == widget.item['id'] && item.percent==100,
    );
  }

  bool downloading(){
    return downloadVar.downloadList.any(
      (item) => item.id == widget.item['id'] && item.percent!=100,
    );
  }

  String percent(){
    int index=downloadVar.downloadList.indexWhere(
      (item) => item.id == widget.item['id'],
    );
    if(index==-1){
      return "0 %";
    }
    return downloadVar.downloadList[index].percent.toString()+" %";
  }

  Future<void> showSongMenu(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: 'addToPlaylist'.tr, key: "add", icon: Icons.playlist_add_rounded),
        isLoved() ? ActionItem(name: 'removeFromLoved'.tr, key: 'delove', icon: Icons.heart_broken_rounded) : 
        ActionItem(name: 'addToLoved'.tr, key: "love", icon: Icons.favorite_rounded),
        ActionItem(name: "showAlbum".tr, key: "album", icon: Icons.album_rounded),
        ActionItem(name: "showArtist".tr, key: "artist", icon: Icons.mic_rounded),
        if(widget.from=="playlist") ActionItem(name: "removeFromPlaylist".tr, key: "delist", icon: Icons.playlist_remove_rounded, ),
        if(!downloadVar.isDownloaded(widget.item['id'])) ActionItem(name: "download".tr, key: "download", icon: Icons.download_rounded),
        ActionItem(name: "songInfo".tr, key: "info", icon: Icons.info_rounded),
      ]
    );
    if(req=="album"){
      if(widget.item['album']!=null && widget.item['albumId']!=null){
        Get.to(()=>AlbumContent(album: widget.item['album'], id: widget.item['albumId']));
      }
      
    }else if(req=='artist'){
      if(widget.item['artistId']!=null && widget.item['artist']!=null){
        Get.to(()=>ArtistContent(id: widget.item['artistId'], artist: widget.item['artist']));
      }
    }else if(req=='love'){
      if(context.mounted){
        Operations().love(widget.item["id"], context);
      }
    }else if(req=='delove'){
      if(context.mounted){
        Operations().delove(widget.item["id"], context);
      }
    }else if(req=='add'){
      if(l.playList.isEmpty && context.mounted){
        d.showOkDialog(context: context, title: "cantAddToPlaylist".tr, content: "noPlaylist".tr);
        return;
      }
      if(context.mounted){
        String selectedId = l.playList[0]['id'];
        await d.showOkCancelDialogRaw(
          context: context,
          title: "addToPlaylist".tr,
          okText: "add".tr,
          child: StatefulBuilder(
            builder: (context, setState) {
              return FSelect<String>.rich(
                control: .managed(initial: selectedId, onChange: (val) {
                  if(val!=null){
                    setState(() {
                      selectedId = val;
                    });
                  }
                }), autoHide: true,
                format: (String id) {
                  final item = l.playList.firstWhere(
                    (e) => e['id'] == id,
                  );
                  return item['name'];
                },
                children: List.generate(l.playList.length, (index) {
                  return FSelectItem<String>(
                    title:  Text(l.playList[index]['name']),
                    value: l.playList[index]['id'],
                  );
                }),
              );
            },
          ),
          okHandler: () async {
            await Operations().addToList(widget.item["id"], selectedId, context);
          },
        );
      }
    }else if(req=="delist"){
      if(widget.from!="playlist" || widget.listId.isEmpty){
        return;
      }
      if(context.mounted){
        if(await Operations().deList(widget.index, widget.listId, context)){
          try {
            widget.refresh();
          } catch (_) {}
        }
      }
    }else if(req=="info"){
      if(context.mounted){
        d.showOkDialogRaw(
          context: context, 
          title: 'songInfo'.tr, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  // "${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${widget.ls[widget.index]['id']}",
                  operations.coverLink(widget.ls[widget.index]['id']),
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 10,),
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
                      widget.ls[widget.index]['title'],
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
                      operations.convertDuration(widget.ls[widget.index]['duration']),
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
                      widget.ls[widget.index]['artist'],
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
                      widget.ls[widget.index]['album'],
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
                      widget.ls[widget.index]['id'],
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
                      "playlistId".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.listId.isEmpty ? "N/A" : widget.listId,
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
                      "created".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      operations.formatIsoString(widget.ls[widget.index]['created']),
                    )
                  )
                ],
              )
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
    return Material(
      color: s.darkMode.value ? s.bgColor2 : Colors.white,
      child: InkWell(
        onTap: (){
          if(s.selectMode.value){
            if(s.selectList.contains(widget.item['id'])){
              s.selectList.remove(widget.item['id']);
            }else{
              s.selectList.add(widget.item['id']);
            }
          }else{
            PlayerControl().playSong(context, widget.item['id'], widget.item['title'], widget.item['artist'], widget.from, widget.item['duration'], widget.listId, widget.index, widget.ls, widget.item['album']);
          }
        },
        onLongPress: (){
          s.selectMode.value = true;
          s.selectList.add(widget.item['id']);
        },
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isLoved() ? const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: Colors.red,
                                size: 15,
                              ),
                            ) : Container(),
                            downloaded() ? const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                                size: 15,
                              ),
                            ) : downloading() ? Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 1,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text(
                                    percent(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}