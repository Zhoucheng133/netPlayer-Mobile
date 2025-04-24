import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final controller1 = FRadioSelectGroupController(value: local.cellularOnly ? '仅移动网络' : '移动网络和无线网络');
  final controller2 = FRadioSelectGroupController(value: local.quality==0 ? '原始' : local.quality==320 ? '320Kbps' : '128Kbps');

  await d.showOkCancelDialogRaw(
    title: '修改音质',
    context: context,
    okText: '完成',
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState)=>Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FSelectMenuTile(
            groupController: controller1,
            title: ListenableBuilder(
              listenable: controller1,
              builder: (_, context) {
                return Text(controller1.value.first, style: GoogleFonts.notoSansSc(),);
              }
            ), 
            menu: types.map((item)=>FSelectTile(
              value: item,
              title: Text(item, style: GoogleFonts.notoSansSc(),),
            )).toList(),
            autoHide: true,
          ),
          const SizedBox(height: 15,),
          FSelectMenuTile(
            groupController: controller2,
            title: ListenableBuilder(
              listenable: controller2,
              builder: (_, context) {
                return Text(controller2.value.first, style: GoogleFonts.notoSansSc(),);
              }
            ), 
            menu: qualitiesAll.map((item)=>FSelectTile(
              title: Text(item, style: GoogleFonts.notoSansSc(),), 
              value: item
            )).toList(),
            autoHide: true,
          ),
        ],
      )
    ),
    okHandler: () async {
      local.cellularOnly=controller1.value.first=='仅移动网络';
      local.quality=controller2.value.first=='原始' ? 0 : controller2.value.first=='320Kbps' ? 320 : 128;
      s.quality.value=local;
      s.quality.refresh();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('quality', jsonEncode(s.quality.value.toJson()));
    }
  );

  controller1.dispose();
  controller2.dispose();
}