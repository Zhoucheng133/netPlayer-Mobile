import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/artist_content.dart';
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: s.darkMode.value ? s.bgColor2 : Colors.white,
      child: InkWell(
        onTap: (){
          Get.to(()=>ArtistContent(id: widget.item['id'], artist: widget.item['name'], albumCount: widget.item['albumCount'] ?? 0));
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item['name'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      if(widget.item['albumCount']!=null) Text(
                        "${widget.item['albumCount']} ${"albumEnd".tr}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color:Colors.grey[400]
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}