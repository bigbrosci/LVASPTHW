# Ex2.7 基本的Linux命令

前面几节大家已经学习了怎么`亲自手动`制作文本格式的输入文件。回顾一下我们所学的东西：

* VASP必须有的输入文件都有哪些？  INCAR、KPOINTS、POSCAR、POTCAR

* 这些文件用什么编辑器修改或者制作？
* 文本内部格式都有哪些需要的注意事项？
* 目前学到的INCAR中各个参数代表的含义？
* KPOINTS， POSCAR文本中每一行所代表的含义？
* POTCAR中几个参数的含义？

当我们准备好输入文件后，下一步就是在服务器里面提交任务，运行VASP了。在这之前，很有必要给大家介绍一些常用的Linux命令，也就是大家今后在终端（Terminal）经常敲的命令。

####  Linux里面的一些基本命令


首先：教给大家常用的进入目录，查看目录下文件（夹），查看文件内部信息的几个相关的命令: `cd`, `ls`，`  cat`，和  `grep`。 通过这几个命令，复习并查看上一节我们制作的输入文件: INCAR， KPOINTS， POSCAR 和POTCAR。

大师兄在超算中心的一些具体的基本操作。大家可以照着命令自己练习下面的几个命令。先敲一遍，看下输出结果。（老司机自动跳过）

```bash
qli@bigbrosci ~ % cd ~/Desktop/LVASPTHW/Ex01/     
qli@bigbrosci Ex01 % ls
INCAR    KPOINTS  POSCAR   POTCAR
qli@bigbrosci Ex01 % pwd
/Users/qli/Desktop/LVASPTHW/Ex01
qli@bigbrosci Ex01 % cat INCAR 
SYSTEM = O atom 
ISMEAR = 0       
SIGMA = 0.01      
qli@bigbrosci Ex01 % grep TIT POTCAR 
   TITEL  = PAW_PBE O 08Apr2002
qli@bigbrosci Ex01 % grep ENMAX POTCAR 
   ENMAX  =  400.000; ENMIN  =  300.000 eV
```

**详解:** 

1）`cd`： 进入文件夹所在的目录；

2）`ls` ：列出来当前目录下的所有文件和文件夹；

3） `pwd`：显示当前所在的绝对目录。

4） `cat` 后面加上文件名，就可以在输出里面查看该文件的内容：cat 和文件名之间有空格， 可以是一个，也可以是N个。（上一节，我们也使用cat命令来生成VASP的POTCAR）

5） 对于一个大文件来说，里面有很多行， 用`cat`就不方便查看了， 我们可以用`grep`这个命令提取出来所关心的信息，比如上一节的`POTCAR`文件，复习下上节的操作：

* 例子1：我们想知道`POTCAR`中包含的元素，可以用: `grep TIT POTCAR` ， 

TIT就是POTCAR中的一个固定的字符，通过提取这个字符，获取我们需要的结果，这里我们知道了 POTCAR中含有O元素;

* 例子2：通过使用：`grep ENMAX POTCAR`  可以获取POTCAR中O元素的截断能是400 eV;

* **注意：**`grep` 后面提取的字符，最好在文件中是唯一存在的或者只出现几次。否则我们不容易得到期望的结果; 大家可以运行下面这两个命令，感受下结果;

```bash
grep EMAX POTCAR
grep  PBE POTCAR  
grep  0  POTCAR  （可以是0，也可以是字母O）
```

6） 查看文件的命令还有 `more`，例如下面的操作：

```bash
qli@bigbrosci Ex01 % ls
INCAR  KPOINTS  POSCAR  POTCAR 
qli@bigbrosci Ex01 % more  INCAR  
SYSTEM = O atom 
ISMEAR = 0       
SIGMA = 0.01      
qli@bigbrosci Ex01 % more POSCAR  
O atom in a box 
1.0            
8.0 0.0 0.0   
0.0 8.0 0.0  
0.0 0.0 8.0 
O          
1         
Cartesian
0.0 0.0 0.0   
qli@bigbrosci Ex01 %
```

7） 或者less， 运行less  命令 后，会弹出类似VIM的界面，并显示文件的内容，

```bash
qli@bigbrosci Ex01 % less INCAR
```

* 如果要退出，敲一下 q 键即可;

* 如果想编辑文件，再敲一下键盘上的v键，则可以直接进入vim 的编辑界面。退出时和vim的退出方法是一样的。

上一小节，我们学习了一些基本的与输入文件相关的linux操作，今天我们学习下文件以及文件夹的操作命令：`mkdir`,`touch`, `cp`，`mv`。跟Gaussian不一样，VASP的计算是以文件夹为单位的，也就是一个文件夹里面包含有一个计算任务。2个计算任务，则对应的是2个文件夹。那么可不可以都放在一个文件夹里面呢？ 可以，但没人这样做，会死的很惨。本节大家熟悉下在终端里创建文件夹，复制，重命名的过程，对应着Windows中鼠标右键，创建新文件夹，鼠标选中，`Control + C`,`Control + V`等操作。

### mkdir 

`mkdir` 是创建文件夹的命令，后面跟着你要创建的文件夹的名字。（`mkdir` 和文件夹名字中间有空格）`mkdir`的使用有很多窍门。大家可以google或者百度关键词查找： mkdir 窍门，小诀窍 等等。下面我们创建一个名为Ex02的文件夹，创建Ex03并同时在该文件夹中创建另一个文件夹`bigbro`。  (`mkdir -p`)

```
qli@bigbrosci ~ % cd Desktop/LVASPTHW 
qli@bigbrosci LVASPTHW % ls
Ex01/
qli@bigbrosci LVASPTHW % mkdir Ex02 
qli@bigbrosci LVASPTHW % mkdir -p Ex03/bigbro 
qli@bigbrosci LVASPTHW % ls
Ex01/ Ex02/ Ex03/
qli@bigbrosci LVASPTHW % ls *
Ex01:
INCAR    KPOINTS  POSCAR   POTCAR

Ex02:

Ex03:
bigbro/
qli@bigbrosci LVASPTHW % rm -fr Ex02 Ex03 
qli@bigbrosci LVASPTHW % ls
Ex01/

```



### cp 和 mv

`cp`这个命令适用于文件以及文件夹的复制（`copy`），重命名或者移动文件（夹）的话，则用`mv`命令。比如：

2.1） 将文件夹bigbro 复制为: bigbra

```
qli@bigbrosci LVASPTHW % ls
Ex01/
qli@bigbrosci LVASPTHW % mkdir bigbro 
qli@bigbrosci LVASPTHW % ls
Ex01/   bigbro/
qli@bigbrosci LVASPTHW % cp bigbro bigbra 
qli@bigbrosci LVASPTHW % ls
Ex01/   bigbra/ bigbro/
```

* 如果复制文件夹的时候，如出现`cp: omitting directory`这个错误，在cp命令后，或者前面命令的结尾加上`-r`即可。复制文件的时候，不用加 -r。

```bash
cp -r  bigbro bigbra
cp bigbro bigbra -r
```

* 大师兄这里之所以没有加`-r`,是因为在`~/.bashrc` (Linux)或者`~/.bash_profile`(Mac OS)文件中设置了默认`-r`。

```bash
qli@bigbrosci LVASPTHW % grep cp ~/.bash_profile
alias cp='cp -r'
```

2.2） 将文件夹bigbro 重命名为：bigbro_1

```
qli@bigbrosci LVASPTHW % mv bigbro bigbro_1
qli@bigbrosci LVASPTHW % ls
Ex01/     bigbra/   bigbro_1/
```

2.3） 将文件夹bigbro_1移动到：bigbra

```
qli@bigbrosci LVASPTHW % mv bigbro_1 bigbra 
qli@bigbrosci LVASPTHW % ls
Ex01/     bigbra/
qli@bigbrosci LVASPTHW % ls *
Ex01:
INCAR    KPOINTS  POSCAR   POTCAR

bigbra:
bigbro_1/
```

2.4）将Ex01中的内容复制到当前目录。`当前目录`在linux命令中，用`.`表示。

```
qli@bigbrosci LVASPTHW LVASPTHW % ls
Ex01/   bigbra/
qli@bigbrosci LVASPTHW LVASPTHW % ls Ex01      
INCAR    KPOINTS  POSCAR   POTCAR
qli@bigbrosci LVASPTHW LVASPTHW % cp Ex01/* . 
qli@bigbrosci LVASPTHW LVASPTHW % ls
Ex01/    INCAR    KPOINTS  POSCAR   POTCAR   bigbra/
qli@bigbrosci LVASPTHW LVASPTHW % 
```

2.5） 将Ex01中的四个输入文件复制到bigbra这个文件夹中：

```
qli@bigbrosci LVASPTHW LVASPTHW % cp Ex01/* bigbra 
qli@bigbrosci LVASPTHW LVASPTHW % ls * 
Ex01:
INCAR    KPOINTS  POSCAR   POTCAR

bigbra:
INCAR     KPOINTS   POSCAR    POTCAR    bigbro_1/

```

* 学会用tab键来自动补全提高自己在终端输入的速度，更多窍门，百度搜索`linux tab键`

```bash
qli@bigbrosci LVASPTHW LVASPTHW % cp E
```

摁tab键

```bash
qli@bigbrosci LVASPTHW LVASPTHW % cp Ex01/
```

* `*`代表某个目录下所有的内容。



**思考下：**

对于一个文件A，我们的目的是将A重命名为B。有下面2种操作可供选择：

第一种） mv A B 

第二种） cp A B 然后 rm A 

从结果上来说，这两种做法都是可以的。这里大师兄想告诉你的是：

i） 尽量找最简单的方法（第一种）实现所期望的目的；

ii） 如果不知道最简单的方法， 那么可以尝试其他方式来解决（第二种）。





### 总结

本节的内容虽名为详解，实为简介！如果想学的更加深入还要靠自己百度或者google查找相关的Linux命令学习手册，ppt等（关键词：`Linux 常用命令 技巧`），平时多加操练。但千万不要让我推荐参考书给你。到现在，我们讲到的Linux基本命令有： `ls`，`cd`，`pwd`，`cat`，`grep`，`more`，`less` 以及`vim` 这个编辑器。如何才能圆满达到本节的要求呢？

1） 熟练操作使用这些命令；

2） 搜索并尝试一些教程相关的学习；

3） 养成遇到不会的命令，就自己**主动**认真搜索学习的习惯。



通过本小节的学习：一方面我们熟悉文件（夹）创建，复制，移动，以及重命名的linux命令：mkdir， mv， cp，以及一些特殊的字符比如`*`和 `.`。此外， linux的命令操作有很多的小技巧，大家**一定一定一定**要多多去网上搜集，加以练习，这对于提高工作效率非常有帮助。 熟悉使用这几个命令，能跟Windows的鼠标操作对应起来，本节任务就完成了。当然喽，跟拍照一样，现在越来越多的公司把计算做的越来越傻瓜化，鼠标点点就完事。如果你想要这样的教程，本书后面的内容也可以不看了。

