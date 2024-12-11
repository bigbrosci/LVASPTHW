### Ex1.5 磨剑



Ex1.4讨论了Windows系统中的三剑客： WSL， Ubuntu，和 Anaconda。 本节趁机会再分享一些具体的细节内容，好好打磨这三把剑，把计算砍个稀吧碎。 


#### WSL 

WSL 可以跟Windows的VS-Code无缝衔接。使用Python写代码，脚本的时候也很方便。具体去参考我们下一节的教程。


#### Ubuntu

对于Ubuntu，我们这里再细分成三个方面： （1）常用软件的安装，（2）  文件的传输 ， （3）挂载硬盘，（4）快捷方式。

2.1 常用软件就直接列举对应的安装命令，后面的教程会具体介绍它们的功能，目前需要你自己去搜索学习掌握。

```bash
sudo apt-get  update 
sudo apt-get  p4vasp
sudo apt-get install libxcb-* 
sudo apt-get install vim
sudo apt-get install tree
sudo apt install firefox
### Image  Convert  install.
sudo apt update && sudo apt upgrade
sudo apt install libpng-dev libjpeg-dev libtiff-dev
sudo apt install imagemagick   # For Image
sudo apt install default-jre   # For Jmol 
sudo apt-get install sshfs
1. sudo apt-get install ttf-mscorefonts-installer ### Install Times New-Roman in Ubuntu
2. use "Tab" key to select then "Enter" to Confirm
3. rm /home/XXX/.cache/matplotlib/ -fr   ### XXX is your usrname 
```

2.2 文件的传输：

Ubuntu是Subsystem，但是Ubuntu跟Windows的文件系统是连通的。怎么从Ubuntu进入到Windows的目录呢？ 前面我们安装Anaconda的时候提到了一下，这里再具体讲一下： 在Ubuntu的terminal中敲命令。把bigbro换成你自己的用户名。这样我们就可以进到Windows的Downloads文件。

```bash 
 cd /mnt/c/Users/bigbro/Downloads/
```

同理，我们要进入到Windows的桌面：

```bash 
cd /mnt/c/Users/bigbro/Desktop
```

我们也可以建立一个超链接把Desktop放在Ubuntu的Home目录下：

```bash 
ln -s /mnt/c/Users/bigbro/Desktop ~/Desktop
```

下次想去Windows桌面的时候，直接敲命令：

```bash
cd ~/Desktop
```

此外，大师兄再介绍另外一个快捷的方式。

```bash 
1. vi ~/.bashrc	
2. export DES='/mnt/c/Users/bigbro/Desktop'
3. cd $DES
```

第一行打开 `.bashrc`文件，第二行把桌面的目录作为一个变量让Ubuntu记住， 第三行是进去桌面的命令。

一旦我们的目录或者path跟Windows 打通，数据的传输，无非就是敲打`cp`, `mv`, `rsync` 之类的命令了。



2.3 挂载硬盘

做计算，没有硬盘肯定是不行的。如果我们的数据在硬盘里面，该怎么样直接连接呢？ 同样编辑`.bashrc`文件，添加以下的几行。注意：大师兄的电脑没有分区，只有一个C盘，所以挂载的硬盘第一个是D盘，如果你已经把电脑分区了，盘符别写错了。



```bash 
1. mkdir ~/ssd ~/sse ~/ssf 
2. vi ~/.bashrc
3. alias  ssd='sudo mount -t drvfs D: ssd'
4. alias  sse='sudo mount -t drvfs E: sse'
5. alias  ssf='sudo mount -t drvfs F: ssf'
6. cd ~ && ssd 
7. cd ssd 
```

1. 先创见几个硬盘挂载的目录，ssd，sse,  ssf，分别对应的 D， E， F盘。名字随意，你也可以改成其他的。

2. 打开`~/.bashrc`文件，添加第3-5行的内容。

3. 'ssd=' 中的ssd 是我自己定义的一个挂载硬盘到ssd目录的命令。

4. 第6行是在terminal中挂载硬盘所需要敲的命令。 

5. 第7行是进入硬盘的命令，对应alias行中`=`前的命令。

   

2.4 快捷方式：

对于快捷方式，2.2也已经讲过了，学会合理使用`.bashrc`这个文件。但是提前打好预防针：修改前一定要先备份当前的版本（第一行命令），万一写错了还能还原（第二行命令）。

```bash 
1. cp ~/.bashrc  bashrc_2024_12_10
2. cp bashrc_2024_12_10 ~/.bashrc
```

下面分享几个超级实用的例子：

```bash
alias ..='cd .. && ls '
alias ...='cd ../../ && ls'
alias ....='cd ../../../ && ls '
alias cp='cp -r'
alias des='cd /mnt/c/Users/lqlhz/Desktop'
```

敲不同的点，就直接实现`cd`进入上1-3级 的目录，然后显示内容。

有时候用cp 复制文件夹不加 `-r` 经常出错，直接把`cp` 默认成 加了 `-r` 的。

敲命令`des` 直接进到Windows的桌面。

剩下的就是你自己根据习惯，爱好修改的事情了。


####  Anaconda 

废话不多说了，直接上命令：

```bash 
conda create -n ase 
conda install conda-forge::ase
conda install anaconda::seaborn
conda install conda-forge::rdkit
conda install --channel conda-forge pymatgen
conda install conda-forge::pandas
conda install conda-forge::openbabel  (conflict, needs another env)
conda install anaconda::jupyter  ## Jupyter does Not work well in WSL
conda install anaconda::spyder   ## Spyder does Not work well in WSL
```

前面创建ASE的环境并安装ASE已经提到过了。

seaborn 用来画heatmap。 

rdkit 化学信息学必用，非常强大。

pymatgen： 也非常强大，跟ASE有一拼。

pandas 读取excel, csv数据，

openbabel 不同计算软件格式的转换。跟前面的冲突，得专门创建一个新的工作环境。

另外，需要注意的是：

不建议在WSL下运行Spyder，Jupyter之类的代码编写工具，也别运行VASP。阉割版的ubuntu毕竟性能一般，还会跟Windows抢资源。 最后的两个命令适合在Windows系统安装的Anaconda中运行。 底部搜索输入 `Anaconda`, 打开`Anaconda Powershell Prompt` 。其他的跟上面提到的类似。剩下的，学习工作中，遇到什么，就对应安装即可。


![Tip Code](figs/Tip_Code.png)
