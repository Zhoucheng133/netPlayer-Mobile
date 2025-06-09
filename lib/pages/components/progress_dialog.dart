import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
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

  // final controller = FRadioSelectGroupController(value: style);

  await d.showOkCancelDialogRaw(
    context: context, 
    title: '播放栏进度显示方式', 
    child: StatefulBuilder(
      builder: (context, _) {
        return FSelect(
          // groupController: controller,
          // title: ListenableBuilder(
          //   listenable: controller,
          //   builder: (_, context) {
          //     return Text(types[controller.value.first], style: GoogleFonts.notoSansSc(),);
          //   }
          // ), 
          autoHide: true,
          initialValue: s.progressStyle.value.index,
          // groupController: controller,
          // title: ListenableBuilder(
          //   listenable: controller,
          //   builder: (_, context) {
          //     return Text(types[controller.value.first], style: GoogleFonts.notoSansSc(),);
          //   }
          // ), 
          format: (int s)=>types[s],
          children: List.generate(types.length, (int index) {
            return FSelectItem(
              // value: index,
              // title: Text(types[index], style: GoogleFonts.notoSansSc()),
              // index.toString(),
              types[index],
              index
            );
          }),
          onChange: (value){
            if(value!=null){
              style=value;
            }
          },
        );
      }
    ),
    cancelText: "取消",
    okText: '完成',
    okHandler: () async {
      // s.progressStyle.value=ProgressStyle.values[controller.value.first];
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setInt('progressStyle', controller.value.first);
      s.progressStyle.value=ProgressStyle.values[style];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('progressStyle', style);
    }
  );
}