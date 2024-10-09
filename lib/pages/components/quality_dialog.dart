import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class QualityDialog extends StatefulWidget {
  const QualityDialog({super.key});

  @override
  State<QualityDialog> createState() => _QualityDialogState();
}

class _QualityDialogState extends State<QualityDialog> {

  final s=Get.put(SettingsVar());

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

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              value: s.quality.value.cellularOnly ? '仅移动网络' : '移动网络和无线网络',
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
                if(val=='移动网络和无线网络'){
                  s.quality.value.cellularOnly=false;
                  s.quality.refresh();
                }else{
                  if(s.quality.value.quality==0){
                    s.quality.value.quality=320;
                  }
                  s.quality.value.cellularOnly=true;
                  s.quality.refresh();
                }
              },
              dropdownStyleData: const DropdownStyleData(
                decoration: BoxDecoration(
                  color: Colors.white,
                )
              ),
            ),
          ),
          const SizedBox(height: 15,),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              value: s.quality.value.quality==0 ? '原始' : s.quality.value.quality==320 ? '320Kbps' : '128Kbps',
              items: s.quality.value.cellularOnly ? qualities.map((String item) => DropdownMenuItem<String>(
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
                  s.quality.value.quality=0;
                }else if(val=='128Kbps'){
                  s.quality.value.quality=128;
                }else{
                  s.quality.value.quality=320;
                }
                s.quality.refresh();
              },
              dropdownStyleData: const DropdownStyleData(
                decoration: BoxDecoration(
                  color: Colors.white,
                )
              ),
            ),
          )
        ],
      )
    );
  }
}