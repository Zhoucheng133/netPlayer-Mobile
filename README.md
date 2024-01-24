# netPlayer Mobile

<img src="./_assets/icon.png" width="100px">

![Flutter](https://img.shields.io/badge/Flutter-3.13-blue?logo=Flutter)
![get](https://img.shields.io/badge/get-4.6.5-red)
![audioservice](https://img.shields.io/badge/audio_service-0.18.10-green)
![just_audio](https://img.shields.io/badge/just_audio-0.9.35-yellow)
![http](https://img.shields.io/badge/http-1.1.0-orange)
![shared_preferences](https://img.shields.io/badge/shared_preferences-2.2.0-lightgreen)
![url_launcher](https://img.shields.io/badge/url_launcher-6.2.1-purple)
![flutter_native_splash](https://img.shields.io/badge/flutter_native_splash-2.3.6-lightyellow)
![package_info_plus](https://img.shields.io/badge/package_info_plus-4.2.0-pink)
![crypto](https://img.shields.io/badge/crypto-3.0.3-lightblue)
![decimal](https://img.shields.io/badge/decimal-2.3.3-green)

![License](https://img.shields.io/badge/License-MIT-dark_green)

**基于Subsonic API的移动端播放器**

**支持Android设备和iOS设备**

经过测试的平台：iPhone13 & 小米5X

（`apk`安装包见`Release`，iOS设备请自行下载源码安装）

**受限于Subsonic API，“所有歌曲”只能显示500首（随机的500首歌曲排序展示），如果你要随机播放所有的歌曲，可以点击所有歌曲页面右上角的随机播放按钮**

关于桌面版的netPlayer，你可以在这里查看：[Github](https://github.com/Zhoucheng133/net-player)  
关于移动Lite的netPlayer，你可以在这里查看：[Github](https://github.com/Zhoucheng133/neyPlayer_Lite)  
关于PWA版本的netPlayer，你可以在这里查看：[Github](https://github.com/Zhoucheng133/netPlayer-PWA)

注意，从`1.3.0`版本开始，放弃支持`PWA`设备，如果你有需要可以使用上面的PWA版本的netPlayer

## 在你的设备上配置netPlayer Mobile

由于本项目没有区分`正在开发的版本`和`发布的版本`，如果你需要获取可以正确执行的代码，**不要直接下载最新的代码! 请在Tag中选择最新的版本下载（或者在Release中下载Source code）**

请不要使用本项目的代码发布Web/PWA版本，本项目的PWA存在很多问题，因此如果如果你希望在Web端（PWA）上使用netPlayer，可以使用PWA版本的netPlayer

### 环境配置

- Flutter^3.13.7，**经过测试最新版本的Flutter运行此项目可能会出现问题，因此不建议使用最新版本的Flutter运行此项目**
- 如果你需要在Android设备上运行或者调试，需要安装Android Studio和Gradle
- 如果你需要在iOS设备上运行或者调试，需要使用Mac，并且安装Xcode<sup>*</sup>
- 建议使用Visual Studio Code打开项目
  - 在Visual Studio Code的右下角找到`Device`按钮（也有可能显示为可用的设备），选择目标设备或者模拟器
  - 在`运行和调试`面板选择`Debug`，`Profile`或者`Release`<sup>**</sup>，详细的区别见[Flutter官网](https://docs.flutter.dev/testing/build-modes)

<sup>*</sup>注意，你需要通过Xcode（使用Xcode打开文件`ios/Runner.xcworkspace`可以自动获取）获取证书，非开发者账户的证书的有效期为一个星期，也就是说一个星期之后你需要重新打开Xcode获取证书

<sup>**</sup>注意，模拟器无法使用`Release`模式，实体iPhone无法使用`Debug`模式

## 截图

以下截图运行在iPhone13上，不同设备上运行效果可能略有不同

<img src="./_assets/截图1.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图2.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图3.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图4.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图5.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图6.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />

## 更新日志

### 1.4.0 (iOS & Android) (开发中)
- 添加显示歌词功能

### 1.3.4 (iOS & Android) (2024/1/1)
- 添加定位到当前播放歌曲的功能

### 1.3.3 (iOS & Android) (2023/12/5)
- 添加所有歌曲≥500首歌曲的提示

### v1.3.2 (iOS & Android) (2023/11/27)
- 播放页添加star/unstar操作
- 添加打开App的启动页面

### v1.3.1 (iOS & Android) (2023/11/10)
- 添加完全随机播放
- 修改加载上次播放信息的问题

### v1.3.0 (iOS & Android) (2023/10/31)
- 添加设置选项卡
- 自定义是否自动保存播放信息
- 自定义是否自动登录
- 改进刷新歌单逻辑
- 改进了参数传递的效率
- 改进了一些图标显示效果
- 改进播放界面布局
- 修复搜索时输入框为空时的错误
- 修复了歌单内容刷新没有刷新喜欢歌曲的问题

### v1.2.0 (iOS & Android & PWA) (2023/10/27)
- 添加播放进度条
- 添加播放进度条的跳转功能
- 支持在设备控制中心跳转功能
- 提高页面跳转性能
- 修复重新请求出现错误的问题
- 修复页面滚动问题
- 修复暂停播放进度条错误的问题

### v1.1.1 (iOS & Android & PWA) (2023/10/24)
- 修复登录时输入框遮挡问题
- 添加请求超时的提示

### v1.1.0 (iOS & Android & PWA) (2023/10/20)
- 添加了新建歌单的功能
- 修改了没有及时刷新的bug
- 重构了获取版本号的逻辑
- 改进软键盘输入的交互

### v1.0.2 (iOS & Android & PWA) (2023/10/12)
- 取消了底部栏上层阴影
- 添加了对Web和PWA的支持
- 解决了在PWA环境中标题栏的一些问题
- 使用just audio库代替audio players

### v1.0.1 (iOS & Android) (2023/10/10)
- 添加对安卓设备的支持
- 修复一些问题
- 在Android设备上使用Material弹窗
- 修复弹窗文本错误

### ~~v1.0.1 (2023/10/10)~~
- ~~添加对安卓版本的支持~~
- ~~修复一些问题~~

### v1.0.0 (iOS)
- 第一个版本

## Subsonic API

[关于所有的API点此](http://www.subsonic.org/pages/api.jsp)

## 歌词API

[关于歌词的API点此](https://lrclib.net/docs)