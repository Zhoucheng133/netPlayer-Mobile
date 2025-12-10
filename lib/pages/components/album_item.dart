import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/album_content.dart';
import 'package:netplayer_mobile/pages/artist_content.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class AlbumItem extends StatefulWidget {

  final int index;
  final dynamic item;

  const AlbumItem({super.key, required this.index, required this.item});

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {

  final DialogVar d=Get.find();
  final DataGet dataGet=DataGet();
  final UserVar u=Get.find();
  final Operations operations=Operations();

  Future<void> showAlbumMenu(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: 'showArtist'.tr, key: "artist", icon: Icons.mic_rounded),
        ActionItem(name: 'albumInfo'.tr, key: "info", icon: Icons.info_rounded),
      ]
    );
    if(req=='artist'){
      Get.to(()=>ArtistContent(id: widget.item['artistId'], artist: widget.item['artist']));
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${albumInfo['coverArt']}",
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(() =>AlbumContent(album: widget.item['title'], id: widget.item['id'], songCount: widget.item['songCount'],));
      },
      onLongPress: ()=>showAlbumMenu(context),
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
                      style: GoogleFonts.notoSansSc(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.item['artist'],
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 12,
                        color:Colors.grey[400]
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
    );
  }
}