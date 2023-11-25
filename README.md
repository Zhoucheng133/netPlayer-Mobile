# netPlayer Mobile

<img src="./_assets/icon.png" width="100px">

![Flutter](https://img.shields.io/badge/Flutter-3.13-blue?logo=Flutter)
![get](https://img.shields.io/badge/get-4.6.5-red)
![audioservice](https://img.shields.io/badge/audio_service-0.18.10-green)
![just_audio](https://img.shields.io/badge/just_audio-0.9.35-yellow)
![http](https://img.shields.io/badge/http-1.1.0-orange)
![shared_preferences](https://img.shields.io/badge/shared_preferences-2.2.0-lightgreen)
![crypto](https://img.shields.io/badge/crypto-3.0.3-lightblue)

![License](https://img.shields.io/badge/License-MIT-dark_green)

**基于Subsonic API的移动端播放器**

**支持Android设备和iOS设备**

经过测试的平台：iPhone13 & 小米5X

（`apk`安装包见`Release`，iOS设备请自行下载源码安装）

**受限于Subsonic API，“所有歌曲”只能显示500首（随机的500首歌曲排序展示），如果你要随机播放所有的歌曲，可以点击所有歌曲页面右上角的随机播放按钮**

关于桌面版的netPlayer，你可以在这里查看：[Github](https://github.com/Zhoucheng133/net-player)  
关于移动Lite的netPlayer，你可以在这里查看：[Github](https://github.com/Zhoucheng133/neyPlayer_Lite)  
关于PWA版本的netPlayer，你可以在这里查看：[Github](https://github.com/Zhoucheng133/netPlayer-PWA)


## 截图

以下截图运行在iPhone13上，不同设备上运行效果可能略有不同

<img src="./_assets/截图1.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图2.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图3.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图4.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图5.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />
<img src="./_assets/截图6.PNG" alt="netPlayer_Lite_截图.jpg" width="200px" />

## 更新日志

### v1.3.1 (iOS & Android & PWA) (2023/11/10)
- 添加完全随机播放
- 修改加载上次播放信息的问题

### v1.3.0 (iOS & Android & PWA) (2023/10/31)
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

## 运行配置

建议使用Visual Studio Code打开

### 对于Android设备上运行

需要安装`Android Studio`和`Gradle`

**通过Visual Studio Code运行**

在项目根目录中进入`android`文件夹，然后执行:  
```bash
gradle wrapper
```

**通过Android Studio运行**

直接打开android文件夹

### 对于iOS设备上运行

受限于苹果的证书问题，你需要先用`Xcode`打开`ios/Runner.xcworkspace`  
然后直接运行即可