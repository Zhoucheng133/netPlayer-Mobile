import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/playlist.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class MenuItem extends StatefulWidget {

  final bool isSet;
  final String name;
  final VoidCallback func;

  const MenuItem({super.key, required this.isSet, required this.name, required this.func});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.func();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.name,
            style: GoogleFonts.notoSansSc(
              fontSize: 16,
              color: widget.isSet ? Colors.black : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 5,),
          AnimatedOpacity(
            opacity: widget.isSet ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2)
              ),
            ),
          )
        ],
      ),
    );
  }
}

class IndexPinItem extends StatefulWidget {

  final IconData icon;
  final String label;
  final Color bgColor;
  final Color contentColor;
  final VoidCallback func;

  const IndexPinItem({super.key, required this.icon, required this.label, required this.bgColor, required this.contentColor, required this.func});

  @override
  State<IndexPinItem> createState() => _IndexPinItemState();
}

class _IndexPinItemState extends State<IndexPinItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      color: widget.bgColor,
      child: InkWell(
        onTap: (){
          widget.func();
        },
        child: SizedBox(
          height: 200,
          width: 150,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Icon(
                    widget.icon,
                    size: 30,
                    color: widget.contentColor,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(80)
                  ),
                  child: Center(
                    child: Text(
                      widget.label,
                      style: GoogleFonts.notoSansSc(
                        color: widget.contentColor,
                        fontSize: 15
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlayListItem extends StatefulWidget {

  final String name;
  final String id;
  final int songCount;
  final String coverArt;

  const PlayListItem({super.key, required this.name, required this.id, required this.songCount, required this.coverArt});

  @override
  State<PlayListItem> createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {

  final UserVar u = Get.put(UserVar());

  Future<void> showAction(BuildContext context) async {
    var req=await showModalActionSheet(
      context: context,
      title: widget.name,
      actions: [
        const SheetAction(label: '重命名歌单', key: "rename", icon: Icons.edit_rounded),
        const SheetAction(label: '删除歌单', key: "del", icon: Icons.delete_rounded)
      ]
    );
    if(req=="rename"){
      if(context.mounted){
        var newname=await showTextInputDialog(
          context: context, 
          textFields: [
            DialogTextField(
              hintText: widget.name
            )
          ],
          title: "重命名歌单",
          okLabel: "完成",
          cancelLabel: "取消"
        );
        if(newname!=null){
          if(context.mounted){
            Operations().renamePlayList(widget.id, newname[0], context);
          }
        }
      }
    }else if(req=="del"){
      if(context.mounted){
        var req=await showOkCancelAlertDialog(
          context: context, 
          title: "删除歌单",
          message: "确定要删除这个歌单吗",
          okLabel: "删除",
          cancelLabel: "取消",
        );
        if(req==OkCancelResult.ok){
          if(context.mounted){
            Operations().delPlayList(widget.id, context);
          }
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(()=>Playlist(id: widget.id, name: widget.name,));
      },
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: NetworkImage(
                      '${u.url.value}/rest/getCoverArt.view?u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&v=1.16.1&c=netPlayer&f=json&id=${widget.coverArt}',
                    ),
                    fit: BoxFit.cover,
                  )
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("${widget.songCount}首")
                    ],
                  ),
                )
              ),
              IconButton(
                onPressed: ()=>showAction(context), 
                icon: const Icon(
                  Icons.more_vert_rounded,
                  size: 20,
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}