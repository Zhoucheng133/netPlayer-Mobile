// 注意，由于新版本的Flutter在显示showCupertinoModalPopup的时候有字体显示问题
// 因此使用此文件的函数代替原有的adaptive_dialog调用区分安卓和iOS系统的对话框

import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart' show showCupertinoModalPopup, CupertinoActionSheet, CupertinoActionSheetAction;
import 'package:flutter/material.dart';

Future<dynamic> showAdaptiveConfirmationSheet({
  required BuildContext context,
  required String title,
  required List<AlertDialogAction> actions
}) async {
  if(Platform.isAndroid){
    return await showConfirmationDialog(
      context: context, 
      title: title,
      actions: actions,
    );
  }else{
    String? data;
    await showCupertinoModalPopup(
      context: context, builder: (BuildContext context){
        return CupertinoActionSheet(
          title: Text(title),
          actions: actions.map((item)=>CupertinoActionSheetAction(
            onPressed: (){
              data=item.key;
              Navigator.pop(context);
            },
            child: Text(item.label, style: const TextStyle(fontSize: 17),),
          )).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: ()=>Navigator.pop(context),
            child: const Text('取消', style: TextStyle(fontSize: 17),),
          )
        );
      },
    );
    return data;
  }
}

Future<dynamic> showAdaptiveActionSheet({
  required BuildContext context,
  required String title,
  required List<SheetAction> actions
}) async {
  if(Platform.isAndroid){
    return await showModalActionSheet(
      context: context,
      title: title,
      actions: actions,
    );
  }else{
    String? data;
    await showCupertinoModalPopup(
      context: context, builder: (BuildContext context){
        return CupertinoActionSheet(
          title: Text(title),
          actions: actions.map((item)=>CupertinoActionSheetAction(
            onPressed: (){
              data=item.key;
              Navigator.pop(context);
            },
            child: Text(item.label, style: const TextStyle(fontSize: 17),),
          )).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: ()=>Navigator.pop(context),
            child: const Text('取消', style: TextStyle(fontSize: 17),),
          )
        );
      },
    );
    return data;
  }
}