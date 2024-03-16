// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ListHeader extends StatefulWidget {

  final String pageFrom;
  final VoidCallback locate;
  final VoidCallback refresh;
  final bool allowLocate;
  final int cnt;

  const ListHeader({super.key, required this.pageFrom, required this.locate, required this.refresh, required this.allowLocate, required this.cnt});

  @override
  State<ListHeader> createState() => _ListHeaderState();
}

class _ListHeaderState extends State<ListHeader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Text(
              widget.pageFrom=="所有歌曲" && widget.cnt==500 ?
              "共有 ≥${widget.cnt} 首歌曲" :
              widget.pageFrom=="歌单列表" ?
              "共有 ${widget.cnt} 个歌单":
              "共有 ${widget.cnt} 首歌曲",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () => widget.refresh(),
              child: Icon(Icons.refresh_rounded),
            ),
            widget.pageFrom!="歌单列表" ?
            SizedBox(width: 20,) : Container(),
            widget.pageFrom!="歌单列表" ? 
            GestureDetector(
              onTap: () => widget.locate(),
              child: Icon(
                Icons.radio_button_on_rounded,
                color: widget.allowLocate ? Colors.black : Colors.grey[400],
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }
}