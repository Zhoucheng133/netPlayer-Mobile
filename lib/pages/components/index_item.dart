import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/playlist.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class MenuItem extends StatefulWidget {

  final bool isSet;
  final String name;
  final VoidCallback func;

  const MenuItem({super.key, required this.isSet, required this.name, required this.func});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.func();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(()=>
            Text(
              widget.name,
              style: GoogleFonts.notoSansSc(
                fontSize: 16,
                color: s.darkMode.value ? widget.isSet ? Colors.white : Colors.grey[500] : widget.isSet ? Colors.black : Colors.grey[500]
              ),
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

  SettingsVar s=Get.find();

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
                child: Obx(()=>
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: s.darkMode.value ? Colors.black.withAlpha(80) : Colors.white.withAlpha(80)
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
  final int len;
  final String created;
  final String changed;

  const PlayListItem({super.key, required this.name, required this.id, required this.songCount, required this.coverArt, required this.len, required this.created, required this.changed});

  @override
  State<PlayListItem> createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {

  final UserVar u = Get.find();
  final DialogVar d=Get.find();
  final Operations operations=Operations();

  Future<void> showAction(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: '重命名歌单', key: "rename", icon: Icons.edit_rounded),
        ActionItem(name: '删除歌单', key: "del", icon: Icons.delete_rounded),
        ActionItem(name: '歌单信息', key: "info", icon: Icons.info_rounded)
      ]
    );
    if(req=="rename"){
      if(context.mounted){
        final controller=TextEditingController();
        await d.showOkCancelDialogRaw(
          context: context, 
          title: "重命名歌单",
          okText: "完成",
          cancelText: "取消",
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FTextField(
                controller: controller,
                hint: widget.name,
              );
            }
          ),
          okHandler: (){
            if(context.mounted){
              Operations().renamePlayList(widget.id, controller.text, context);
            }
          }
        );
      }
    }else if(req=="del"){
      if(context.mounted){
        var req=await d.showOkCancelDialog(
          context: context, 
          title: "删除歌单",
          content: "确定要删除这个歌单吗",
          okText: "删除",
          cancelText: "取消",
        );
        if(req){
          if(context.mounted){
            Operations().delPlayList(widget.id, context);
          }
        }
      }
    }else if(req=="info"){
      if(context.mounted){
        d.showOkDialogRaw(
          context: context, 
          title: "歌单信息", 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${u.url.value}/rest/getCoverArt.view?u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&v=1.16.1&c=netPlayer&f=json&id=${widget.coverArt}",
                  width: 100,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      "歌单名称",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      "歌曲数量",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${widget.songCount}首",
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      "总时长",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      operations.convertDuration(widget.len),
                      maxLines: 2,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      "歌单id",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.id,
                      maxLines: 2,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      "创建于",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      operations.formatIsoString(widget.created),
                      maxLines: 2,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      "修改于",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      operations.formatIsoString(widget.changed),
                      maxLines: 2,
                    )
                  )
                ],
              ),
            ],
          )
        );
      }
    }
  }

  SettingsVar s=Get.find();
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(()=>Playlist(id: widget.id, name: widget.name, songCount: widget.songCount));
      },
      onLongPress: ()=>showAction(context),
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
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    const Center(child: SkeletonAvatar()),
                    Image.network(
                      '${u.url.value}/rest/getCoverArt.view?u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&v=1.16.1&c=netPlayer&f=json&id=${widget.coverArt}',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress){
                        if(loadingProgress==null){
                          return Container(
                            color: s.darkMode.value ? s.bgColor2 : Colors.white,
                            child: child
                          );
                        }else{
                          return const SizedBox();
                        }
                      },
                    )
                  ],
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
                        style: GoogleFonts.notoSansSc(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${widget.songCount}首",
                        style: GoogleFonts.notoSansSc(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      )
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