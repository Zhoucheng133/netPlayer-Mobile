// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:netplayer_mobile/para/para.dart';

// 请求函数
Future<Map<String, dynamic>> httpRequest(String url, {int timeoutInSeconds = 3}) async {
  try {
    final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: timeoutInSeconds));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> data = json.decode(responseBody);
      return data;
    } else {
      Map<String, dynamic> data = {};
      throw Exception(data);
    }
  } on TimeoutException {
    // 请求超时处理逻辑
    Map<String, dynamic> data = {};
    return data;
  } catch (error) {
    // 其他错误处理逻辑
    Map<String, dynamic> data = {};
    return data;
  }
}

// 获取随机数
String generateRandomString(int length) {
  const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  Random random = Random();
  String result = "";

  for (int i = 0; i < length; i++) {
    int randomIndex = random.nextInt(charset.length);
    result += charset[randomIndex];
  }

  return result;
}

// 登录请求
Future<Map> loginRequest(String url, String username, String password) async {
  if(url.endsWith("/")){
    url=url.substring(0, url.length - 1);
  }
  String salt=generateRandomString(6);
  var bytes = utf8.encode(password+salt);
  var token = md5.convert(bytes);
  Map response=await httpRequest("${url}/rest/ping.view?v=1.12.0&c=myapp&f=json&u=${username}&t=${token}&s=${salt}");
  if(response.isEmpty){
    return {"status": "URL Err"};
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return {"status": "URL Err"};
  }
  response["url"]=url;
  response["username"]=username;
  response["salt"]=salt;
  response["token"]=token;
  return response;
}

// 获取所有（随机的）歌曲
Future<Map> allSongsRequest() async {
  final Controller c = Get.put(Controller());

  String url="${c.userInfo["url"]}/rest/getRandomSongs?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&size=500";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return {"status": "URL Err"};
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return {"status": "URL Err"};
  }
  if(response["status"]!="ok"){
    return {"status": "Pass Err"};
  }
  return response;
}

// 获取喜欢的歌曲
Future<List> lovedSongRequest()async {
  final Controller c = Get.put(Controller());
  String url="${c.userInfo["url"]}/rest/getStarred?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return [];
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return [];
  }
  if(response["status"]!="ok"){
    return [];
  }
  if(response["starred"]["song"]!=null){
    return response["starred"]["song"];
  }else{
    return [];
  }
}

// 获取所有歌单
Future<List> allListsRequest()async {
  final Controller c = Get.put(Controller());
  // print("请求所有歌单");
  String url="${c.userInfo["url"]}/rest/getPlaylists?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return [];
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return [];
  }
  if(response["status"]!="ok"){
    return [];
  }
  if(response["playlists"]["playlist"]!=null){
    return response["playlists"]["playlist"];
  }else{
    return [];
  }
}

// 获取播放列表
Future<List> getListContent(String id)async {
  final Controller c = Get.put(Controller());
  // print("请求所有歌单");
  String url="${c.userInfo["url"]}/rest/getPlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${id}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return [];
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return [];
  }
  if(response["status"]!="ok"){
    return [];
  }
  if(response["playlist"]["entry"]==null){
    return [];
  }else{
    return response["playlist"]["entry"];
  }
}

// 将某一首歌设置为喜欢
Future<bool> setLove(String id)async {
  final Controller c = Get.put(Controller());
  String url="${c.userInfo["url"]}/rest/star?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${id}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return false;
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return false;
  }
  if(response["status"]!="ok"){
    return false;
  }
  return true;
}

// 将某一首歌从喜欢中删除
Future<bool> setDelove(String id)async {
  final Controller c = Get.put(Controller());
  String url="${c.userInfo["url"]}/rest/unstar?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${id}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return false;
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return false;
  }
  if(response["status"]!="ok"){
    return false;
  }
  return true;
}

// 将某首歌添加到歌单
Future<bool> addToList(String listId, String songId) async {
  final Controller c = Get.put(Controller());
  String url="${c.userInfo["url"]}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&playlistId=${listId}&songIdToAdd=${songId}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return false;
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return false;
  }
  if(response["status"]!="ok"){
    return false;
  }
  return true;
}

// 删除歌单
Future<bool> delListRequest(String listId) async {
  final Controller c = Get.put(Controller());
  String url="${c.userInfo["url"]}/rest/deletePlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${listId}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return false;
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return false;
  }
  if(response["status"]!="ok"){
    return false;
  }
  return true;
}

// 将某首歌从歌单中删除
Future<bool> delFromListRequest(String listId, int songIndex) async {
  final Controller c = Get.put(Controller());
  String url="${c.userInfo["url"]}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&playlistId=${listId}&songIndexToRemove=${songIndex}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return false;
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return false;
  }
  if(response["status"]!="ok"){
    return false;
  }
  return true;
}

// 重命名歌单
Future<bool> reNameList(String listId, String name) async {
  final Controller c = Get.put(Controller());
  String url="${c.userInfo["url"]}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&playlistId=${listId}&name=${name}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return false;
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return false;
  }
  if(response["status"]!="ok"){
    return false;
  }
  return true;
}

// 搜索
Future<List> searchRequest(String key) async {
  final Controller c = Get.put(Controller());
  String url="${c.userInfo["url"]}/rest/search2?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&query=${key}";
  Map response=await httpRequest(url);
  if(response.isEmpty){
    return [];
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return [];
  }
  if(response["status"]!="ok"){
    return [];
  }
  return response["searchResult2"]["song"];
}