import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DownloadItem{
  final String id;
  final String timestamp;
  final String filePath;
  int percent;

  DownloadItem({required this.id, required this.timestamp, required this.percent, required this.filePath});

  factory DownloadItem.init(String filePath, int percent) {
    final fileName=p.basenameWithoutExtension(filePath);
    final parts = fileName.split('_');

    return DownloadItem(
      filePath: filePath,
      timestamp: parts.first,
      id: parts.sublist(1).join('_'),
      percent: percent,
    );
  }

  Map getInfo(){
    final track = File(filePath);
    final metadata = readMetadata(track, getImage: false);
    return {
      'id': id,
      'album': metadata.album,
      'artist': metadata.artist,
      'title': metadata.title,
      'duration': metadata.duration,
      'filePath': filePath,
    };
  }
}

class DownloadVar {
  final UserVar u = Get.find();
  final dio = Dio();

  RxList<DownloadItem> downloadList=RxList<DownloadItem>([]);

  Future<Directory> getDownloadDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${dir.path}/downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  Future<void> downloadSong({
    required String url,
    required String savePath,
    required void Function(int received, int total) onProgress,
  }) async {
    await dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
      options: Options(
        responseType: ResponseType.stream,
        followRedirects: true,
      ),
    );
  }

  Future<List> getDownloadList() async {
    final dir = await getDownloadDir();
    final files = dir
      .listSync()
      .whereType<File>()
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

    final List<DownloadItem> items = [];

    for (final file in files) {
      final item = DownloadItem.init(file.path, 100);
      items.add(item);
    }

    downloadList.assignAll(items);

    return downloadList.map((item)=>item.getInfo()).toList();
  }

  Future<void> downloadSongFromUrl(String id) async {
    final url = "${u.url.value}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${id}";
    final dir = await getDownloadDir();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final filename = '${ts}_$id.mp3';
    final filePath = '${dir.path}/$filename';

    await downloadSong(
      url: url,
      savePath: filePath,
      onProgress: (received, total) {
        if (total != -1) {
          final index = downloadList.indexWhere((item) => item.id == id);
          if(index != -1){
            downloadList[downloadList.indexWhere((item)=>item.id==id)].percent=(received/total*100).toInt();
            downloadList.refresh();
          }else{
            downloadList.add(DownloadItem.init(filePath, (received/total*100).toInt()));
            downloadList.refresh();
          }
        }
      },
    );

    downloadList[downloadList.indexWhere((item)=>item.id==id)].percent=100;
    downloadList.refresh();
  }
}