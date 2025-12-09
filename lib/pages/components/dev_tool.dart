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

  SettingsVar s=Get.find();
  final seekCheck=SeekCheck();
  UserVar u = Get.find();
  PlayerVar p=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'playingId'.tr,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'playingUrl'.tr,
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
              SizedBox(
                width: 120,
                child: Text('useWifi'.tr),
              ),
              Text(s.wifi.value.toString())
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text('useBitrate'.tr),
              ),
              Text((!SeekCheck().enableSeek()).toString())
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text('maxBitrate'.tr),
              ),
              Text((SeekCheck().enableSeek()) ? '' : s.quality.value.quality.toString())
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text('originalBitrate'.tr),
              ),
              Text(widget.data['subsonic-response']['song']['bitRate'].toString())
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text('format'.tr),
              ),
              Text(widget.data['subsonic-response']['song']['suffix'])
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text('size'.tr),
              ),
              Text(widget.data['subsonic-response']['song']['size'].toString())
            ],
          )
        ],
      )
    );
  }
}