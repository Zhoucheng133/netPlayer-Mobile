// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            child: Container(),
          ),
        ],
      ),
    );
  }
}