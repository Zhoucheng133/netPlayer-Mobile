import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/seek_check.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class DevTool extends StatefulWidget {

  final dynamic data;

  const DevTool({super.key, this.data});

  @override
  State<DevTool> createState() => _DevToolState();
}

class _DevToolState extends State<DevTool> {

  SettingsVar s=Get.put(SettingsVar());
  final seekCheck=SeekCheck();
  UserVar u = Get.put(UserVar());
  PlayerVar p=Get.put(PlayerVar());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '当前播放id',
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.data['subsonic-response']['song']['id'],
                  softWrap: true,
                ),
              )
            ],
          ),
          const SizedBox(height: 5,),
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '当前播放url',
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  seekCheck.enableSeek() ? "${u.url.value}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=***&s=***&id=${p.nowPlay["id"]}"
                    : "${u.url.value}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=***&s=***&id=${p.nowPlay["id"]}&maxBitRate=${s.quality.value.quality}",
                  softWrap: true,
                ),
              )
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Text('使用无线网络'),
              ),
              Text(s.wifi.value.toString())
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Text('指定比特率'),
              ),
              Text((!SeekCheck().enableSeek()).toString())
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Text('最大比特率'),
              ),
              Text((SeekCheck().enableSeek()) ? '' : s.quality.value.quality.toString())
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Text('播放源比特率'),
              ),
              Text(widget.data['subsonic-response']['song']['bitRate'].toString())
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Text('格式'),
              ),
              Text(widget.data['subsonic-response']['song']['suffix'])
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Text('大小'),
              ),
              Text(widget.data['subsonic-response']['song']['size'].toString())
            ],
          )
        ],
      )
    );
  }
}