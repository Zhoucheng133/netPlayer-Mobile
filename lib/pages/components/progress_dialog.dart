import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showProgressDialog(BuildContext context){
  SettingsVar s=Get.find();
  final List<String> types=[
    '关闭',
    '环状',
    '背景色',
  ];

  var style=s.progressStyle.value.index;
  

  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('修改播放栏进度显示方式', style: GoogleFonts.notoSansSc(),),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState)=>DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true, 
            value: types[style],
            items: types.map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
            .toList(),
            onChanged: (val){
              if(val!=null){
                if(val=='关闭'){
                  setState((){style=0;});
                }else if(val=='环状'){
                  setState((){style=1;});
                }else{
                  setState((){style=2;});
                }
              }
            },
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: s.darkMode.value ? s.bgColor1 : Colors.white,
              )
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            s.progressStyle.value=ProgressStyle.values[style];
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('progressStyle', style);
          }, 
          child: const Text('完成')
        )
      ],
    )
  );
}