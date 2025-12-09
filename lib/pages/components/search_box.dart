import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class SearchBox extends SliverPersistentHeaderDelegate {
  late final Widget Function(BuildContext) builder; // 接收构建函数

  SearchBox(this.builder);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context);
  }

  @override
  double get maxExtent => 90;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}

class SearchInput extends StatefulWidget {

  final TextEditingController textController;
  final FocusNode focus;
  final VoidCallback search;
  final String mode;
  const SearchInput({super.key, required this.textController, required this.focus, required this.search, required this.mode});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {

  SettingsVar s=Get.find();
  final DialogVar d=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Container(
        color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
        height: 90,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: s.darkMode.value ? s.bgColor3 : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      // color: Colors.grey.withOpacity(0.1),
                      color: Colors.grey.withAlpha(2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${"search".tr}${widget.mode=="song" ? "songs".tr: widget.mode=="album" ? "albums".tr: "artists".tr}',
                        style: GoogleFonts.notoSansSc(
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.search_rounded),
                          const SizedBox(width: 5,),
                          Expanded(
                            child: TextField(
                              controller: widget.textController,
                              focusNode: widget.focus,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.only(top: 9, bottom: 10, left: 5, right: 10),
                              ),
                              autocorrect: false,
                              onEditingComplete: (){
                                if(widget.textController.text.isEmpty){
                                  d.showOkDialog(
                                    context: context,
                                    okText: "ok".tr,
                                    title: "searchFailed".tr,
                                    content: "searchKeywordsEmpty".tr
                                  );
                                  return;
                                }
                                widget.focus.unfocus();
                                widget.search();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}