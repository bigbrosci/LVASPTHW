**p4vasp: 重生**



俗话说字越少，事儿越大。我觉得这个事情还是蛮重大的，标题就简单些吧，其实冒号也可以删掉。

言归正传：经过本人和Whitehare大神的不懈努力，终于把p4vasp升级到了python3，并给新版本命名为：**p4vasp-py3** 

https://github.com/bigbrosci/p4vasp.git  （记得切换到p4vasp-py3这个分支）目前支持的版本有Linux和Mac。Linux 版本可以运行在正常的系统比如Ubuntu，也可以在Windows的WSL中正常运行（也算是变相支持Windows吧）。MacOs 测试中M4 和 Intel的芯片都OK。 总之：不管什么系统，主打一个傻瓜式安装： 一个命令行直接安装完毕，不需要动脑子。



**1 Linux系统的安装步骤 （Ubuntu为例）**

在terminal中，复制粘贴下面的命令，然后运行。

1.1 下载p4vasp-py3。

```
mkdir ~/opt && cd ~/opt && git clone -b p4vasp-py3  https://github.com/bigbrosci/p4vasp.git
```

1.2 编译p4vasp-py3

```
cd p4vasp/ && bash ubuntu-start.sh
```

弹出来p4vasp的界面，就说明安装成功了。 关掉或者Control + C即可，就是这么直接。

1.3 编辑~/.bashrc 文件，将下面这一行添加到文件中。

```
alias p4v="$HOME/opt/p4vasp/run-p4vasp.sh"
```

以后就可以通过`p4v`这个命令来打开单个或者多个文件了。



**2 Mac OS 安装：**

2.1 下载：

```
mkdir ~/opt && cd ~/opt && git clone -b p4vasp-py3   https://github.com/bigbrosci/p4vasp.git
```

2.2 编译，类似Ubuntu，运行的脚本变成了macos-start.sh

```
cd p4vasp/ && bash macos-start.sh
```

2.3 修改~/.zshrc 

```
alias p4v="$HOME/opt/p4vasp/run-p4vasp.sh"
```

2.4 在terminal中运行的时候直接敲命令即可。

```
p4v POSCAR 
```

3 安装实例：

```
qli@qli:~$ mkdir ~/opt && cd ~/opt && git clone -b p4vasp-py3   https://github.com/bigbrosci/p4vasp.git
Cloning into 'p4vasp'...
remote: Enumerating objects: 1998, done.
remote: Counting objects: 100% (173/173), done.
remote: Compressing objects: 100% (47/47), done.
remote: Total 1998 (delta 147), reused 128 (delta 126), pack-reused 1825 (from 1)
Receiving objects: 100% (1998/1998), 5.60 MiB | 8.14 MiB/s, done.
Resolving deltas: 100% (1252/1252), done.
qli@qli:~/opt$ cd p4vasp/ && bash ubuntu-start.sh
Installing Ubuntu packages for p4vasp...
[sudo] password for qli:
Get:1 http://security.ubuntu.com/ubuntu jammy-security InRelease [129 kB]
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease
Get:3 http://archive.ubuntu.com/ubuntu jammy-updates InRelease [128 kB]
Get:4 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [3242 kB]
Get:5 http://archive.ubuntu.com/ubuntu jammy-backports InRelease [127 kB]
Get:6 http://archive.ubuntu.com/ubuntu jammy-updates/restricted amd64 Packages [5993 kB]
Get:7 http://security.ubuntu.com/ubuntu jammy-security/main Translation-en [455 kB]
Get:8 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [5758 kB]
Get:9 http://security.ubuntu.com/ubuntu jammy-security/restricted Translation-en [1099 kB]
Get:10 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [1031 kB]
Get:11 http://security.ubuntu.com/ubuntu jammy-security/universe Translation-en [227 kB]
Get:12 http://archive.ubuntu.com/ubuntu jammy-updates/restricted Translation-en [1140 kB]
Get:13 http://archive.ubuntu.com/ubuntu jammy-updates/multiverse amd64 Packages [71.6 kB]
Get:14 http://archive.ubuntu.com/ubuntu jammy-updates/multiverse Translation-en [15.5 kB]
Fetched 19.4 MB in 2s (8694 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
build-essential is already the newest version (12.9ubuntu3).
g++ is already the newest version (4:11.2.0-1ubuntu1).
libglu1-mesa-dev is already the newest version (9.0.2-1).
libxcursor-dev is already the newest version (1:1.2.0-2build4).
libxext-dev is already the newest version (2:1.3.4-1build1).
libxft-dev is already the newest version (2.3.4-1).
libxinerama-dev is already the newest version (2:1.1.4-3).
libxrender-dev is already the newest version (1:0.9.10-1build4).
make is already the newest version (4.3-4.1build1).
pkg-config is already the newest version (0.29.2-1ubuntu3).
python3-cairo is already the newest version (1.20.1-3build1).
libfltk1.3-dev is already the newest version (1.3.8-4).
python3-opengl is already the newest version (3.1.5+dfsg-1).
swig is already the newest version (4.0.2-1ubuntu1).
ca-certificates is already the newest version (20240203~22.04.1).
gir1.2-gtk-3.0 is already the newest version (3.24.33-1ubuntu2.2).
libgl1-mesa-dev is already the newest version (23.2.1-1ubuntu3.1~22.04.3).
libx11-dev is already the newest version (2:1.7.5-1ubuntu0.3).
mesa-common-dev is already the newest version (23.2.1-1ubuntu3.1~22.04.3).
python3 is already the newest version (3.10.6-1~22.04.1).
python3-dev is already the newest version (3.10.6-1~22.04.1).
python3-gi is already the newest version (3.42.1-0ubuntu1).
python3-numpy is already the newest version (1:1.21.5-1ubuntu22.04.1).
0 upgraded, 0 newly installed, 0 to remove and 62 not upgraded.
Using Python executable: /usr/bin/python3
Using Python include: /usr/include/python3.10
Using extension suffix: .cpython-310-x86_64-linux-gnu.so
Using FLTK config: /usr/bin/fltk-config
Generating odpdom/cODP_wrap.cpp
Compiling odpdom/string.cpp
Compiling odpdom/markText.cpp
Compiling odpdom/Exceptions.cpp
Compiling odpdom/Node.cpp
Compiling odpdom/NodeSequences.cpp
Compiling odpdom/Document.cpp
Compiling odpdom/CharacterNodes.cpp
Compiling odpdom/Element.cpp
Compiling odpdom/parse.cpp
Compiling src/Exceptions.cpp
Compiling src/AtomtypesRecord.cpp
Compiling src/AtomInfo.cpp
Compiling src/vecutils3d.cpp
Compiling src/vecutils.cpp
Compiling src/utils.cpp
Compiling src/domutils.cpp
Compiling src/FArray.cpp
Compiling src/Structure.cpp
Compiling src/Chgcar.cpp
Compiling src/ChgcarSmear.cpp
Compiling src/Process.cpp
Compiling src/VisFLWindow.cpp
Compiling src/VisMain.cpp
Compiling src/VisWindow.cpp
Compiling src/VisEvent.cpp
Compiling src/VisDrawer.cpp
Compiling src/VisNavDrawer.cpp
Compiling src/VisStructureDrawer.cpp
Compiling src/VisStructureArrowsDrawer.cpp
Compiling src/VisIsosurfaceDrawer.cpp
Compiling src/ClassInterface.cpp
Compiling src/VisSlideDrawer.cpp
Compiling src/VisPrimitiveDrawer.cpp
Compiling src/VisBackEvent.cpp
Compiling src/cp4vasp_wrap.cpp
Linking /home/qli/opt/p4vasp/lib/_cp4vasp.cpython-310-x86_64-linux-gnu.so
Checking Python imports
p4vasp Unix build OK
Built /home/qli/opt/p4vasp/lib/_cp4vasp.cpython-310-x86_64-linux-gnu.so
```

![image-20260519121321112](C:\Users\lqlhz\AppData\Roaming\Typora\typora-user-images\image-20260519121321112.png)

当我看到这个界面的时候，流下了欢喜的泪水（夸张的描述）。P4VASP，我最爱的模型编辑器，活过来啦！！！