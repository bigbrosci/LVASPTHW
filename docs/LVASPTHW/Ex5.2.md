# Ex5.2 最新版 p4vasp 的获取方式

上一节说了 p4vasp 是干什么的，这一节就讲怎么拿到最新版的p4vasp。

## GitHub 链接

https://github.com/bigbrosci/p4vasp/tree/p4vasp-py3

## 安装方式

在终端里，复制粘贴下面三行命令，然后运行：

```bash
git clone -b p4vasp-py3 https://github.com/bigbrosci/p4vasp.git
cd p4vasp
bash install.sh
```

注意 `-b p4vasp-py3` 这个分支不能省。直接 `git clone` 不加分支，拉下来的是默认分支，不是你要的这个版本。

`install.sh` 会自动识别 Mac、Ubuntu 以及其他 Linux 系统。注意的有 2 点：

1） 看最后的输出提示，按照说明编辑下 `~/.bashrc` 就完事。

2） Mac 可能会有些慢，放哪里让它自己慢慢跑即可。

装完之后，界面弹出来就说明安装成功了。关掉或者按 Control + C 就行，就是这么直接。装的时候卡住了，先把最后的输出提示完整看一遍，大多数问题都写在那一步里。

## 老用户更新 p4vasp 的步骤

如果你以前已经装过 p4vasp，不用重新下载，直接在你原来那个文件夹里更新：

```bash
cd XXX/p4vasp
git pull
bash install.sh
```

这里的 `XXX` 是你自己放 p4vasp 的那个目录，换成你自己的路径。先 `git pull` 把最新的代码拉下来，再跑一遍 `install.sh`，就更新完了。

别干这种傻事：明明已经装过一次了，还重新 `git clone` 一份新的，两个版本放在两个地方，到时候 `p4v` 打开的是哪个你自己都不知道。

## Windows 下载的百度网盘链接

https://pan.baidu.com/s/5z-Fkh0Z4Qinjs2Zheznvew

Windows 用户直接去这个网盘链接下载就行。最新版的 Windows EXE 里能直接调用 ASE 建 Bulk、调用 RDKIT 建分子模型，这部分在下一节 Ex5.3 里会说。

## 总结

- 新用户：`git clone -b p4vasp-py3`，再 `bash install.sh`，按输出提示改 `~/.bashrc`。
- 老用户：不用重新下载，`git pull` + `bash install.sh` 就行。
- Windows 用户：去上面的百度网盘链接下载。
