import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forui/widgets/tile.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum DirListType{
  document,
  temp,
}

class DirList extends StatefulWidget {

  final DirListType type;

  const DirList({super.key, required this.type});

  @override
  State<DirList> createState() => _DirListState();
}

class _DirListState extends State<DirList> {

  SettingsVar s=Get.find();

  List<File> ls=[];
  
  Future<void> getTempFiles() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      List<FileSystemEntity> entities = await tempDir.list(recursive: true).toList();
      setState(() {
        ls = entities.whereType<File>().toList();
      });
    } catch (e) {}
  }

  Future<void> getDocumentFiles() async {
    try {
      final Directory appDocDir = Directory(p.join((await getApplicationDocumentsDirectory()).path, 'downloads'));
      List<FileSystemEntity> entities = await appDocDir.list(recursive: true).toList();
      setState(() {
        ls = entities.whereType<File>().toList();
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    if(widget.type==DirListType.document){
      getDocumentFiles();
    }else{
      getTempFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness==Brightness.dark ? s.bgColor2 : Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness==Brightness.dark ? s.bgColor1 : Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.type==DirListType.document ? "AppDocumentDir".tr : "TempDir".tr,
          )
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: ls.length,
        itemBuilder: (BuildContext context, int index)=>FTile(
          title: Text(
            p.basename(ls[index].path),
            style: TextStyle(
              fontFamily: 'PuHui',
            ),
          ),
        )
      ),
    );
  }
}