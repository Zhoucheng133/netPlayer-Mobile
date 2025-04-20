# netPlayer Mobile

<img src="./assets/icon.png" width="100px">

![License](https://img.shields.io/badge/License-MIT-dark_green)

**基于Subsonic API的移动端播放器**

[**netPlayer Next**](https://github.com/Zhoucheng133/netPlayer-Next) | [**netPlayer**](https://github.com/Zhoucheng133/net-player) | **★ netPlayer Mobile**

**支持Android设备和iOS设备**

经过测试的平台：小米5X & iPhone13

（`apk`安装包见`Release`，iOS设备请自行下载源码安装）

> [!NOTE]
> 受限于Subsonic API，“所有歌曲”和“专辑”只能显示500首/张（随机的500首歌曲排序展示），如果你要随机播放所有的歌曲，可以点击主页右上角更多-随机播放所有歌曲

> [!WARNING]
> 如果你已经安装了v1.x版本的netPlayer Mobile，那么请在升级到v2.0.0或更新版本时卸载旧版本

## 一些使用技巧

> [!TIP]
> 在主页-更多(位于右上角三个点)中可以选择随机播放所有歌曲，这种方式随机播放的歌曲**不受**API中500首歌曲的限制

> [!TIP]
> 在播放页面可以点击封面来查看歌词，同理点击歌词可以隐藏歌词

## 截图

以下截图运行在模拟机上，不同设备上运行效果可能略有不同

<img src="demo/1.png" alt="netPlayer_Mobile_截图.jpg" width="200px" /><img src="demo/2.png" alt="netPlayer_Mobile_截图.jpg" width="200px" /><img src="demo/3.png" alt="netPlayer_Mobile_截图.jpg" width="200px" />

<img src="demo/4.png" alt="netPlayer_Mobile_截图.jpg" width="200px" /><img src="demo/5.png" alt="netPlayer_Mobile_截图.jpg" width="200px" /><img src="demo/6.png" alt="netPlayer_Mobile_截图.jpg" width="200px" />

<img src="demo/7.png" alt="netPlayer_Mobile_截图.jpg" width="200px" /><img src="demo/8.png" alt="netPlayer_Mobile_截图.jpg" width="200px" /><img src="demo/9.png" alt="netPlayer_Mobile_截图.jpg" width="200px" />

## 常见问题

### 无法连接到音乐服务器:

> 你需要先检查你的客户端设备是否可以直接打开音乐库网页，很大概率是服务器防火墙或者设置问题  
> 另外务必检查地址，http和https

### 所有歌曲显示不全:

> Subsonic音乐库的API并不支持查看所有的歌曲，因此至多只能显示500首歌曲 但是你可以通过完全随机播放来随机播放所有的歌曲，不受歌曲数量显示

### 没有找到歌词:

> 歌词API见文末，没有找到歌词就是字面意思
> 歌词的内容取决于歌曲标题、所属专辑、艺人和歌曲长度

### 没有封面 (或者是默认封面):

> 歌曲的封面来自你上传的音频文件，如果音频文件没有内嵌封面则会显示默认封面  
> 另外经过测试部分编码的音频文件内嵌封面加载存在异常（或加载时间过长），可能会导致崩溃，因此也会显示默认封面

## 在你的设备上配置netPlayer Mobile

> [!NOTE]
> 如果你使用较新版本的Flutter，建议使用`for_new_flutter`这个分支，新版本的Flutter的部分组件显示有一些问题

### 环境配置

- 如果你需要在Android设备上运行或者调试，需要安装Android Studio和Gradle
- 如果你需要在iOS设备上运行或者调试，需要使用Mac，并且安装Xcode<sup>*</sup>
- 安装Flutter，安装步骤见[Flutter - 开始使用](https://flutter.cn/docs/get-started/install)，本项目使用的Flutter版本为`3.22`
- 建议使用Visual Studio Code打开项目
  - 在Visual Studio Code的右下角找到`Device`按钮（也有可能显示为可用的设备），选择目标设备或者模拟器
  - 在`运行和调试`面板选择`Debug`，`Profile`或者`Release`<sup>**</sup>，详细的区别见[Flutter官网](https://docs.flutter.dev/testing/build-modes)

<sup>*</sup>注意，你需要通过Xcode（使用Xcode打开文件`ios/Runner.xcworkspace`可以自动获取）获取证书，非开发者账户的证书的有效期为一个星期，也就是说一个星期之后你需要重新打开Xcode获取证书

<sup>**</sup>注意，模拟器无法使用`Release`模式，实体iPhone无法使用`Debug`模式

## 一些API

[Subsonic API](http://www.subsonic.org/pages/api.jsp)

[lrclib API](https://lrclib.net/docs)

网易云音乐