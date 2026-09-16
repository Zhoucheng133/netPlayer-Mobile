import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/album_content.dart';
import 'package:netplayer_mobile/pages/artist_content.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class AlbumItem extends StatefulWidget {

  final int index;
  final dynamic item;
  final bool useRootNavigator;

  const AlbumItem({super.key, required this.index, required this.item, this.useRootNavigator=false});

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {

  final DialogVar d=Get.find();
  final DataGet dataGet=DataGet();
  final UserVar u=Get.find();
  final Operations operations=Operations();
  final SettingsVar s=Get.find();

  LsVar ls=Get.find();

  bool isLoved(){
    for (var val in ls.lovedAlbums) {
      if(val["id"]==widget.item['id']){
        return true;
      }
    }
    return false;
  }

  Future<void> showAlbumMenu(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: 'showArtist'.tr, key: "artist", icon: Icons.mic_rounded),
        ActionItem(name: 'albumInfo'.tr, key: "info", icon: Icons.info_rounded),
        isLoved() ? ActionItem(name: 'removeFromLoved'.tr, key: "delove", icon: Icons.heart_broken_rounded) : 
        ActionItem(name: 'addToLoved'.tr, key: "love", icon: Icons.favorite_rounded)
      ]
    );
    if(req=='artist'){
      if(widget.useRootNavigator){
        Get.to(()=>ArtistContent(id: widget.item['artistId'], artist: widget.item['artist'], showPlayingBar: true));
      }else{
        Get.toNamed('/artist', id: 1, arguments: {
          'id': widget.item['artistId'],
          'artist': widget.item['artist'],
        });
      }
    }else if(req=="info"){
      Map albumInfo={};
      if(context.mounted) albumInfo=await dataGet.getAlbumInfo(widget.item['id'], context);

      if(context.mounted){
        d.showOkDialogRaw(
          context: context, 
          title: 'albumInfo'.tr, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    operations.coverLink(albumInfo['coverArt']),
                    height: 150,
                    width: 150,
                    frameBuilder:(context, child, frame, wasSynchronouslyLoaded){
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: frame != null ? child : SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 150,
                            height: 150,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "albumTitle".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      albumInfo['name'],
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
                      "albumDuration".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      operations.convertDuration(albumInfo['duration']),
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
                      albumInfo['artist'],
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
                      "songCount".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      albumInfo['songCount'].toString(),
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
                      "albumId".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      albumInfo['id'],
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
                      operations.formatIsoString(albumInfo['created']),
                    )
                  )
                ],
              )
            ],
          )
        );
      }
    }else if(req=="love"){
      if(context.mounted){
        operations.love(widget.item["id"], context);
      }
    }else if(req=="delove"){
      if(context.mounted){
        operations.delove(widget.item["id"], context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: s.darkMode.value ? s.bgColor2 : Colors.white,
      child: InkWell(
        onTap: (){
          if(widget.useRootNavigator){
            Get.to(()=>AlbumContent(album: widget.item['title'], id: widget.item['id'], songCount: widget.item['songCount']??0, showPlayingBar: true));
          }else{
            Get.toNamed('/album', id: 1, arguments: {
              'album': widget.item['title'],
              'id': widget.item['id'],
              'songCount': widget.item['songCount'],
            });
          }
        },
        onLongPress: ()=>showAlbumMenu(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  child: Center(
                    child: Text((widget.index+1).toString())
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item['title'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Obx(
                        ()=> Row(
                          mainAxisAlignment: .start,
                          crossAxisAlignment: .center,
                          children: [
                            isLoved() ? const Padding(
                              padding: EdgeInsets.only(right: 5),
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
                                  color:Colors.grey[400]
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                IconButton(
                  onPressed: () => showAlbumMenu(context),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
