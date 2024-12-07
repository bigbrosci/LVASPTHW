### Ex1.4 WSL-Ubuntu-Anaconda



本节介绍如何在Windows中通过WSL（Windows Subsystem for Linux）使用Ubuntu18, 并安装p4vasp, Anaconda，以及通过Anaconda进一步安装其他Python软件。 这也是大师兄本人目前最常用的一个工作方式。不一定要求大家一定都跟我一样，但是我知道肯定有跟同样喜欢这个工作方式的人。另外，很多的步骤与Ubuntu以及Mac系统中都很相似。下面我们一步一步实现这个基本的工作配置。

#### 1  在Windows中安装WSL

Windows官网也有安装WSL的详细介绍：https://learn.microsoft.com/en-us/windows/wsl/install 

1）按照以下的步骤开启运行 WSL 的系统功能：

* 1.1 打开控制面板

*  1.2 选择 程序 

*  1.3 启用或关闭 Windows 功能 

*  1.4 勾选以下选项：

  - **适用于 Linux 的 Windows 子系统**。

  - **虚拟机平台**（必需，支持 WSL2）。

* 1.5 点击 **确定** 并等待安装完成 

* 1.6 重启电脑。

2） 安装WSL: 

* 2.1 **打开 PowerShell (管理员模式)**

  - 按 `Win + S` 打开搜索框，输入 **PowerShell**。

  - 右键点击 **Windows PowerShell**，选择 **以管理员身份运行**。

* **运行命令启用 WSL**: 输入以下命令并按回车。按提示完成安装后，重启计算机以应用更改。

   ```powershell
    wsl --install
    ```

此命令会自动：

- 启用 WSL 功能。
- 安装 Linux 内核更新包。
- 设置 WSL 版本为 WSL2。
- 安装默认的 Linux 发行版（通常是 Ubuntu）。


#### 2 安装Ubuntu 18.0 

Windows 目前支持很多Ubuntu的发行版本，我们这里只安装 Ubuntu 18。原因只有一个：在U18上可以简单安装并使用p4vasp. 如果你不想使用这个软件，可以安装最新的Ubuntu 24. 

1. **通过 Microsoft Store 安装 Ubuntu**

   - 屏幕底部搜索并打开 **Microsoft Store**，然后搜索 **Ubuntu**。
   - 在搜索结果中选择版本:  **Ubuntu 18.04.6 LTS**），点击 **获取** 或 **安装**。

2. **初始化 Ubuntu**

   - 安装完成后，运行 Ubuntu（在开始菜单搜索 "Ubuntu" 并点击运行）。
   - 按提示设置用户名和密码:
     - 用于 Linux 系统内登录，不影响 Windows 用户
     - 用户名和密码简单容易记住即可，没必要很复杂。

3. 设置Windows中的Terminal. 

   * 在Microsoft Store搜索 **Windows Terminal**，安装完成。

   * 桌面底部搜索框输入：Terminal， 点一下打开；

   * 点Terminal 最上方 **向下的箭头** --> Startup --> Default Profile --> 选择Ubuntu18
   * 再次在桌面底部搜索框输入：Terminal， 点一下，就直接进入Ubuntu18对应的Terminal。
   * 也可以进行其他个性化的设置，这里就不再赘叙了。

#### 3. 安装p4vasp  

安装完成Ubuntu 18后，在屏幕底部的搜索框输入 Ubuntu， 点击Ubuntu 18。就直接弹出Terminal 了。按照下面的命令依次输入：

```bash
1. sudo apt-get update
2. sudo apt-get install p4vasp  
```

这是迄今为止p4vasp最简单的安装办法了。其他的Ubuntu版本应该也可以安装，但是可能会有些麻烦，留给愿意折腾的人去解决吧。 如果你想安装其他的软件，可以使用跟p4vasp类似的方式，比如VIM, Tree, firefox浏览器等:

```bash
sudo apt-get install vim
sudo apt-get install tree
sudo apt install firefox
```


#### 5. 安装Anaconda 

1. 通过Windows浏览器： 

   * 1.1 下载安装包： [Download Now | Anaconda](https://www.anaconda.com/download/success) 输入邮箱后，在Anaconda Installers 找到Linux对应的版本（[64-Bit (x86) Installer (1007.9M)](https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh)）下载。此时，安装包下载到Windows的Downloads目录。

   * 1.2 打开Ubuntu的Terminal，将安装包复制到Ubuntu的目录下，并运行：

      ```python
       qli@bigbro:~$ cp /mnt/c/Users/bigbro/Downloads/Anaconda3-2024.10-1-Linux-x86_64.sh .
       qli@bigbro:~$ bash Anaconda3-2024.10-1-Linux-x86_64.sh  
       ```

       按照提示一步一步操作即可，注意：Anaconda前面的协议部分很长，要一直摁着`Enter`键。

   * Windows的版本也需要下载一份，并安装到Windows系统中。

2. Ubuntu18的Firefox 浏览器： 

   * 在 Ubuntu的Terminal中输入： firefox 命令，就可以打开浏览器了，输入Anaconda下载的网址，然后下载。（此时，安装包下载到Ubuntu的`~/Downloads`目录 ）

      ```bash
       qli@bigbro:~$ firefox
       ```

       

   * 进入Downloads目录并安装Anaconda：

      ```bash
       qli@bigbro:~$ cd Downloads/
       qli@bigbro:~/Downloads$ ls
       Anaconda3-2024.10-1-Linux-x86_64.sh
       qli@bigbro:~/Downloads$ bash Anaconda3-2024.10-1-Linux-x86_64.sh
       ```



#### 6. 安装ASE环境以及其他Python库。

一旦完成Anaconda的安装后，剩下的很多事情都变得极其简单。下面的三个命令行：

1） 创建一个以ASE这个软件为主的工作环境：

2）激活这个环境

3） 安装ASE

```bash
(base) qli@bigbro:~$ conda create -n ase 
(base) qli@bigbro:~$ conda activate ase
(ase) qli@qli:~$ conda install conda-forge::ase
```

最后一步的命令其实就类似Ubuntu中的 `sudo apt-get install p4vasp` 等后面需要安装一些Python相关的软件时，就可以直接用`conda install XXX` 这个命令来实现了。比如我们想要安装`pandas`这个软件，在Anaconda官网的库中（[Anaconda.org](https://anaconda.org/)）搜索pandas。 找到后点击，就可以进入[Pandas | Anaconda.org](https://anaconda.org/anaconda/pandas)并找到对应的下载命令。



#### Ex1.4 小结：

在本节的练习中，你会学到很多的操作知识。本节的内容，快则半天，慢则2-3天的时间来实践消化。

* WSL是什么？ 怎么安装？
* Ubuntu有哪些版本？我们为什么要安装 Ubuntu 18？
* Windows中的Terminal怎么安装，如何个性化设置？
* Ubuntu中怎么安装p4vasp以及其他软件？
* Ubuntu中怎么安装Anaconda？
* 通过Anaconda安装ASE以及其他Python软件/库。
