// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool enableAutoLogin=true;
  bool savePlay=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          TitleAria(title: '设置', subtitle: ' '),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '自动登录',
                            style: GoogleFonts.notoSansSc(
                              fontSize: 18
                            ),
                          ),
                        ),
                        Switch(
                          activeTrackColor: Colors.blue,
                          value: enableAutoLogin, 
                          onChanged: (val) async {
                            setState(() {
                              enableAutoLogin=val;
                            });
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('autoLogin', val);
                          }
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '保存上次播放位置',
                            style: GoogleFonts.notoSansSc(
                              fontSize: 18
                            ),
                          ),
                        ),
                        Switch(
                          activeTrackColor: Colors.blue,
                          value: savePlay, 
                          onChanged: (val) async {
                            setState(() {
                              savePlay=val;
                            });
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('savePlaty', val);
                          }
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}