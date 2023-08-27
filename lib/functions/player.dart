import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final Controller c = Get.put(Controller());
  final player = AudioPlayer();
  
  @override
  Future<void> play() async {
    
  }

  @override
  Future<void> pause() async {
    
  }

  @override
  Future<void> skipToNext()async {
    
  }

  @override
  Future<void> skipToPrevious()async{

  }
}