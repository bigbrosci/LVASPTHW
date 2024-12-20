# Ex2.8 连接服务器

前面我们练习了使用Linux各种命令对输入文件进行修改，也准备好了众多的测试任务。

1） INCAR中SIGMA的测试；

2） KPOINTS的测试；

3）POSCAR格子大小的测试。

但是怎么计算呢？我们先理一理实现计算的几个条件：

1） 有服务器；

2）服务器上安装了VASP；

3）连接到服务器；

4）把准备好的输入文件上传到服务器（当然也可以直接在服务器上操作）；

5）提交任务到服务器。

**第一个条件**我们默认大家已经满足，如果不满足，VASP可以学到此为止了。**第二个条件**就是VASP的安装，默认大家已经按照，如果有自己的服务器，或者租赁的超算，可以参看本书VASP的安装这一章节。安装过程中一些连接服务器，上传文件的操作，可以参考本节。今天我们介绍第三个条件：**服务器的连接。**



### 连接服务器的工具：

1) 通过软件：主要指的是Windows系统，选择花样很多，比如：Winscp+Putty；Mobaxterm；XManager。大家自行百度，寻找一款适合自己装逼的软件。困难选择症患者直接使用Mobaxterm。主要目的就是：连接到服务器并且实现数据互传。也就是上传文件（前面准备的输入文件）到服务器，或者下载（计算结果等）到本地电脑。
2) 通过终端，
   1) Windows系统：
      * WSL(适用于Linux的Windows子系统)。WSL目前最新的是WSL2。安装Ubuntu的时候要注意，尽可能安装最新的。这个百度或者google都会有一堆的教程。Ubuntu官网也有对应的教程：[Install Ubuntu on WSL2 on Windows 10](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10) ；很详细照着做就行了。
      * Windows自己也出了一个Terminal。Win10或者11用户，在商店直接搜索关键词：`Windows Terminal`。既可以打开Powershell，也可以打开WSL的Ubuntu。
   2) Ubuntu和MacOs：直接打开terminal即可。

3. Ipad连接服务器的软件：

   * SSHaking
   * Terminus （Android平板也可以）
   * juiceSSH  （Android平板也可以）

   

#### Terminal 连接的命令

Terminal中，主要通过ssh （**Secure Shell Protocol**）进行连接：主要命令行为：

```bash
ssh qli@cluster.hpc.udel.edu -X 
```

`ssh `连接服务器的命令，后面跟着用户名以及服务器的域名。 -X 或者 -Y 主要是用于在服务器上运行可视化界面。国内比较流行VPN，也就是先连接VPN后，再运行上面的ssh命令行。具体以超算或者自己课题组的为准。



#### 数据传输

除了前面介绍的几款软件外，还有一些非常方便的办法。我们几乎每个人手上都会有U盘或者移动硬盘，下面介绍的方法就类似我们把移动硬盘插到电脑上，进行数据互传一样。唯一的区别在于此时的移动硬盘使我们的服务器集群。

##### Windows

* Windows的WSL2下的Ubuntu可以按照后面Ubuntu的操作进行。
* Windows还可以通过**映射网络驱动器**把服务器挂载到本地电脑。映射前需要先安装：sshfs-win （https://github.com/winfsp/sshfs-win）和winfsp （https://winfsp.dev/rel/）。挂载完成后，则可以在Terminal中通过一些常用的命令实现文件在本地电脑和服务器之间的传输；
* Windows用户还可以通过sftp进行数据传输。

##### Ubuntu

则通过使用`sshfs`将服务器挂载到本地电脑，从而在`Terminal`中实现数据传输的命令行操作。`sshfs`的下载则通过命令行进行：

```
sudo apt-get update
sudo apt-get install sshfs
```

下载完成后：

（1）创建挂载的目录：也就是建一个文件夹： `mkdir ~/cluster `

（2）将下面几行复制到`~/.bashrc` 文件中，MacOs则是`~/.bash_profile`文件，将`qli@cluster.edu` 改成你自己服务器登录的用户名和域名。

```bash
alias cluster='ssh -Y  qli@cluster.edu'
alias mcluster='sshfs qli@cluster.edu: ~/cluster'
alias ucluster='sudo umount ~/cluster -l'
```

（3）更新下`~/.bashrc`或者`~/.bash_profile`，：命令

```bash
. ~/.bashrc
```

 `.` 在这里就是更新的意思，还可以用source命令: ` source ~/.bashrc`

（4）前面设置完成后，

	* 登录服务器的时候敲命令：`cluster`; 
	* 将服务器挂载到本地电脑的命令：`mcluster`；

* 将服务器从本地电脑移除（类似拔掉U盘）的命令：`ucluster`

##### MacOs

主要通过使用`macFUSE`，`SSHFS`进行，这两个软件的下载链接：https://osxfuse.github.io。下载后双击安装，剩下的具体设置和Ubuntu一样。唯一的区别就是把`~/.bashrc`文件换成了`~/.bash_profile`,但是里面修改的内容是一样的。



#### 总结

本节主要介绍了以下不同操作系统中服务器的连接方法以及数据互传的一些软件以及Terminal中的相关设置。文章看起来很简单，但真正操作起来，可能会出现各种各样的小问题，如果能在2天之内解决服务器的连接，实现数据的互传。就圆满完成了任务。
