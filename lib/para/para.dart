import 'package:get/get.dart';

class Controller extends GetxController{
  // 是否已经登录了
  var isLogin=false.obs;
  // 用户信息
  var userInfo={}.obs;
  // 是否正在播放
  var isPlay=false.obs;
  // 当前播放歌曲信息
  var playInfo={}.obs;
  // 所有歌曲信息
  var allSongs=[].obs;
  // 所有歌手信息
  var artists=[].obs;
  // 所有专辑信息
  var albums=[].obs;

  void updateLogin(data) => isLogin.value=data;
  void updateUserInfo(data) => userInfo.value=data;
  void updateIsPlay(data) => isPlay.value=data;
  void updatePlayInfo(data) => playInfo.value=data;
  void updateAllSongs(data) => allSongs.value=data;
  void updateArtists(data) => artists.value=data;
  void upateAlbums(data) => albums.value=data;
}