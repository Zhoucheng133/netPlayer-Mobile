import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showProgressDialog(BuildContext context) async {
  SettingsVar s=Get.find();
  DialogVar d=Get.find();
  final List<String> types=[
    '关闭',
    '环状',
    '背景色',
  ];

  var style=s.progressStyle.value.index;

  final controller = FRadioSelectGroupController(value: style);

  await d.showOkDialogRaw(
    context: context, 
    title: '播放栏进度显示方式', 
    child: StatefulBuilder(
      builder: (context, _) {
        return FSelectMenuTile(
          groupController: controller,
          title: ListenableBuilder(
            listenable: controller,
            builder: (_, context) {
              return Text(types[controller.value.first], style: GoogleFonts.notoSansSc(),);
            }
          ), 
          menu: List.generate(types.length, (index) {
            return FSelectTile(
              value: index,
              title: Text(types[index], style: GoogleFonts.notoSansSc()),
            );
          }),
          autoHide: true,
        );
      }
    ),
    okText: '完成',
    okHandler: () async {
      s.progressStyle.value=ProgressStyle.values[controller.value.first];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('progressStyle', controller.value.first);
    }
  );
}