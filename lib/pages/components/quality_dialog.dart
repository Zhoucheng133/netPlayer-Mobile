import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showQualityDialog(BuildContext context){
  final SettingsVar s=Get.find();

  final List<String> types=[
    '移动网络和无线网络',
    '仅移动网络',
  ];

  final List<String> qualities=[
    '128Kbps',
    '320Kbps'
  ];

  final List<String> qualitiesAll=[
    '原始',
    '128Kbps',
    '320Kbps'
  ];

  CustomQuality local=s.quality.value;

  showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      title: const Text('修改音质'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState)=>Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonHideUnderline(
              child: Obx(()=>
                DropdownButton2(
                  isExpanded: true,
                  value: local.cellularOnly ? '仅移动网络' : '移动网络和无线网络',
                  items: types.map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                      ),
                    ),
                  ))
                  .toList(),
                  onChanged: (val){
                    if(val=='移动网络和无线网络'){
                      setState(() {
                        local.cellularOnly=false;
                      });
                    }else{
                      if(local.quality==0){
                        setState(() {
                          local.quality=320;
                        });
                      }
                      setState(() {
                        local.cellularOnly=true;
                      });
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
            const SizedBox(height: 15,),
            DropdownButtonHideUnderline(
              child: Obx(()=>
                DropdownButton2(
                  isExpanded: true,
                  value: local.quality==0 ? '原始' : local.quality==320 ? '320Kbps' : '128Kbps',
                  items: local.cellularOnly ? qualities.map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                  .toList() : qualitiesAll.map((String item) => DropdownMenuItem<String>(
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
                    if(val=='原始'){
                      setState(() {
                        local.quality=0;
                      });
                    }else if(val=='128Kbps'){
                      setState(() {
                        local.quality=128;
                      });
                    }else{
                      setState(() {
                        local.quality=320;
                      });
                    }
                  },
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: s.darkMode.value ? s.bgColor1 : Colors.white,
                    )
                  ),
                ),
              ),
            )
          ],
        )
      ),
      actions: [
        TextButton(
          onPressed: () async {
            s.quality.value=local;
            s.quality.refresh();
            Navigator.pop(context);
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('quality', jsonEncode(s.quality.value.toJson()));
          }, 
          child: const Text('完成')
        )
      ],
    )
  );
}