import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showQualityDialog(BuildContext context) async {
  final SettingsVar s=Get.find();
  final DialogVar d=Get.find();

  final List<String> types=[
    '移动网络和无线网络',
    '仅移动网络',
  ];

  final List<String> qualitiesAll=[
    '原始',
    '128Kbps',
    '320Kbps'
  ];

  CustomQuality local=s.quality.value;

  // final controller1 = FSelectController(value: local.cellularOnly ? '仅移动网络' : '移动网络和无线网络');
  // final controller2 = FRadioSelectGroupController(value: local.quality==0 ? '原始' : local.quality==320 ? '320Kbps' : '128Kbps');

  bool cellularOnly=local.cellularOnly==true;
  int quality=local.quality;

  await d.showOkCancelDialogRaw(
    title: '修改音质',
    context: context,
    okText: '完成',
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState)=>Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FSelect(
            // groupController: controller1,
            // title: ListenableBuilder(
            //   listenable: controller1,
            //   builder: (_, context) {
            //     return Text(controller1.value.first, style: GoogleFonts.notoSansSc(),);
            //   }
            // ),
            format: (int s)=>types[s],
            initialValue: cellularOnly ? 1 : 0,
            autoHide: true, 
            onChange: (int? value){
              if(value!=null){
                cellularOnly=value==1;
              }
            },
            // children: types.map((item)=>FSelectItem(
            //   // value: item,
            //   // title: Text(item, style: GoogleFonts.notoSansSc(),),
            //   item, item
            // )).toList(),
            children: [
              FSelectItem("移动网络和无线网络", 0),
              FSelectItem("仅移动网络", 1)
            ],
          ),
          const SizedBox(height: 15,),
          FSelect(
            // groupController: controller2,
            // title: ListenableBuilder(
            //   listenable: controller2,
            //   builder: (_, context) {
            //     return Text(controller2.value.first, style: GoogleFonts.notoSansSc(),);
            //   }
            // ),
            format: (int s)=>qualitiesAll[s],
            autoHide: true, 
            onChange: (value){
              if(value!=null){
                if(value==0){
                  quality=0;
                }else if(value==1){
                  quality=128;
                }else if(value==2){
                  quality=320;
                }
              }
            },
            // menu: qualitiesAll.map((item)=>FSelectTile(
            //   title: Text(item, style: GoogleFonts.notoSansSc(),), 
            //   value: item
            // )).toList(),
            // children: qualitiesAll.map((item)=>FSelectItem(
            //   // value: item,
            //   // title: Text(item, style: GoogleFonts.notoSansSc(),),
            //   item, item
            // )).toList(),
            initialValue: quality==0 ? 0 : quality==128 ? 1 : 2,
            children: [
              FSelectItem("原始", 0),
              FSelectItem("128Kbps", 1),
              FSelectItem("320Kbps", 2),
            ],
          ),
        ],
      )
    ),
    okHandler: () async {
      // local.cellularOnly=controller1.value.first=='仅移动网络';
      // local.quality=controller2.value.first=='原始' ? 0 : controller2.value.first=='320Kbps' ? 320 : 128;
      s.quality.value.cellularOnly=cellularOnly;
      s.quality.value.quality=quality;
      s.quality.refresh();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('quality', jsonEncode(s.quality.value.toJson()));
    }
  );
}