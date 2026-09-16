import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class ArtistItem extends StatefulWidget {
  final int index;
  final dynamic item;

  const ArtistItem({super.key, required this.index, required this.item});

  @override
  State<ArtistItem> createState() => _ArtistItemState();
}

class _ArtistItemState extends State<ArtistItem> {

  SettingsVar s=Get.find();
  LsVar ls=Get.find();
  final DialogVar d=Get.find();
  final Operations operations=Operations();

  bool isLoved(){
    for (var val in ls.lovedArtists) {
      if(val["id"]==widget.item['id']){
        return true;
      }
    }
    return false;
  }

  Future<void> showArtistMenu(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        isLoved() ? ActionItem(name: 'removeFromLoved'.tr, key: "delove", icon: Icons.heart_broken_rounded) : 
        ActionItem(name: 'addToLoved'.tr, key: "love", icon: Icons.favorite_rounded)
      ]
    );
    if(req=="love"){
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
          Get.toNamed('/artist', id: 1, arguments: {
            'id': widget.item['id'],
            'artist': widget.item['name'],
            'albumCount': widget.item['albumCount'] ?? 0,
          });
        },
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
                  child: Obx(
                    ()=> Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            isLoved() && widget.item['albumCount']==null ? const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: Colors.red,
                                size: 15,
                              ),
                            ) : Container(),
                            Expanded(
                              child: Text(
                                widget.item['name'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if(widget.item['albumCount']!=null) Row(
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
                                "${widget.item['albumCount']} ${"albumEnd".tr}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:Colors.grey[400]
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                IconButton(
                  onPressed: () => showArtistMenu(context),
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