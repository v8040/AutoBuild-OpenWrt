<div align="center">
<img width="768" src="https://image.v8040v.top/file/b0c3270176d75764add55.png"/>
<h1>OpenWrt 固件云编译</h1>
</div>

## 项目说明
- OpenWrt 源码：[ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 、 [hanwckf](https://github.com/hanwckf/immortalwrt-mt798x)
- 云编译方法：[P3TERX](https://github.com/P3TERX/Actions-OpenWrt) 、 [Haiibo](https://github.com/haiibo/OpenWrt)
- 固件打包：[Flippy](https://github.com/unifreq/openwrt_packit) 、 [ophub](https://github.com/ophub/kernel)
- 固件默认管理地址：`10.10.10.1` 、 `10.10.11.1` 默认用户：`root` 默认密码：`password` 默认主题：`Argon`
- 固件可以在 [Releases](https://github.com/v8040/AutoBuild-OpenWrt/releases) 内进行下载
- 默认添加[kiddin9](https://github.com/kiddin9/openwrt-packages)的opkg源，可在线opkg安装插件
- 项目编译的固件插件为最新版本，最新版插件可能有 BUG，如果之前使用稳定则无需追新
- 第一次使用请采用全新安装，避免出现升级失败以及其他一些可能的 BUG

## 插件预览
<details>
<summary><b>&nbsp;ARMv8 固件插件预览</b></summary>
<br/>
<img src="https://image.v8040v.top/file/faad25abd01fe8a4bd969.png"/>
</details>

<details>
<summary><b>&nbsp;ramips 固件插件预览</b></summary>
<br/>
参照 ARMv8 固件插件预览（集成ddns zerotier，没有集成任何存储、下载、USB等相关插件）
</details>

## 定制固件
1. 首先要登录 Gihub 账号，然后 Fork 此项目到你自己的 Github 仓库
2. 修改 `configs` 目录对应文件添加或删除插件，或者上传自己的 `xx.config` 配置文件
3. 插件对应名称及功能请参考恩山网友帖子：[Applications 添加插件应用说明](https://www.right.com.cn/forum/thread-3682029-1-1.html)
4. 如需修改默认 IP、添加或删除插件包以及一些其他设置请在 `scripts/common.sh` 、 `scripts/diy/xx.sh` 文件内修改
5. 添加或修改 `xx.yml` 文件，最后点击 `Actions` 运行要编译的 `workflow` 即可开始编译
6. 编译大概需要1-5小时，编译完成后在仓库主页 [Releases](https://github.com/v8040/AutoBuild-OpenWrt/releases) 对应 Tag 标签内下载固件

## 特别提示

- **本项目（包括但不限于workflows、scripts、README.md）来源于Github上的各位大佬**

- **本项目自用，欢迎在遵守规则的前提下使用、下载、Fork**

- **因精力有限不提供任何技术支持和教程等相关问题解答，不保证完全无 BUG！**

- **本人不对任何人因使用本固件所遭受的任何理论或实际的损失承担责任！**

- **本固件禁止用于任何商业用途，请务必严格遵守国家互联网使用相关法律规定！**

- **请务必遵从 “不涉及政治，不涉及宗教，不涉及黄赌毒” 三不原则！**

## 鸣谢
| [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) | [coolsnowwolf](https://github.com/coolsnowwolf) | [P3TERX](https://github.com/P3TERX) | [Flippy](https://github.com/unifreq) | [kiddin9](https://github.com/kiddin9) |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| <img width="100" src="https://avatars.githubusercontent.com/u/53193414"/> | <img width="100" src="https://avatars.githubusercontent.com/u/31687149"/> | <img width="100" src="https://avatars.githubusercontent.com/u/25927179"/> | <img width="100" src="https://avatars.githubusercontent.com/u/39355261"/> | <img width="100" src="https://avatars.githubusercontent.com/u/48883331"/> |
| [Ophub](https://github.com/ophub) | [SuLingGG](https://github.com/SuLingGG) | [haibo](https://github.com/haiibo) | [hanwckf](https://github.com/hanwckf) | [kenzok8](https://github.com/kenzok8/small-package) |
| <img width="100" src="https://avatars.githubusercontent.com/u/68696949"/> | <img width="100" src="https://avatars.githubusercontent.com/u/22287562"/> | <img width="100" src="https://avatars.githubusercontent.com/u/85640068"/> | <img width="100" src="https://avatars.githubusercontent.com/u/27666983"/> | <img width="100" src="https://avatars.githubusercontent.com/u/39034242"/> |
