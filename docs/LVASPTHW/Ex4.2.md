# Ex4.2 for+sed

前面练习中我们在0.01的文件夹基础上，通过一行for循环命令，复制得到了从0.02到0.10的文件夹。但是， 所有文件夹中的输入文件都是一样的，我们还需要把INCAR中的SIGMA参数值 SIGMA = 0.01 改成与文件夹对应的数值。 首先我们可以逐个进行编辑，但太浪费时间，这也不是大师兄的风格。今天就学习一个Linux下强大的文本处理命令：`sed`以及它与for循环的结合。通过本节的学习，最终我们会顺利掌握结合for循环和sed命令进行批量处理输入文本的方法。**还是要强调一下：**大家要主动，多去网上找资料，并系统性的学习linux下面的基本命令。光指望着本书中的这么一点，是很难提高的。

#### **sed 命令修改INCAR**

前面我们提到，可以使用vim打开INCAR然后修改SIGMA的参数。除了vim当然还有文本编辑器等其他的工具。但这些工具都有个缺点，就是得把文件打开后才能修改。下面我们使用sed命令，不打开文本，直接对里面的内容进行替换操作。

```
qli@bigbrosci Ex02 % cd 0.01
qli@bigbrosci 0.01 % sed '3s/0.01/0.02/g' INCAR 
SYSTEM = O atom 
ISMEAR = 0       
SIGMA = 0.02      
qli@bigbrosci 0.01 % cat INCAR  
SYSTEM = O atom 
ISMEAR = 0       
SIGMA = 0.01      
```

**精解：**

1) 	单引号中是我们的操作， 3s 表示的是选择第三行，因为我们知道 0.01 在第三行中出现，s 是`substitute `的缩写;
2)	3s 后面跟一个斜杠 /  用来和后面被替换的内容分开，这里0.01 表示选择第三行的0.01;

3)	0.01后面再用一个斜杠，将其和替换后的数字分开(0.01  0.02  0.03 等)，表示将0.01替换为斜杠后面的内容;

4)	再加一个斜杠，后面的`g` 代表 `global `，意思是全部替换。

5)	输入完毕后，我们选择要执行该命令的对象(要替换的文件)，也就是当前目录下INCAR 文件。

6)	 命令的意思就是：我们用sed命令，将INCAR中的第三行的0.01全部（例子中0.01只出现了一次）替换成0.02。

从上面实例中最后的`cat INCAR`命令结果不难发现，实际上我们并没有将INCAR文件中的0.01替换成0.02。也就是说这个命令只是输出了替换后的结果，但没有更新INCAR文件。那怎么样才可以更新INCAR文件呢？ 我们可以这样做：

```
qli@bigbrosci 0.01 % sed '3s/0.01/0.02/g' INCAR > INCAR_new
qli@bigbrosci 0.01 % cat INCAR_new 
SYSTEM = O atom 
ISMEAR = 0       
SIGMA = 0.02      
qli@bigbrosci 0.01 % mv INCAR_new  INCAR 
qli@bigbrosci 0.01 % cat INCAR  
SYSTEM = O atom 
ISMEAR = 0       
SIGMA = 0.02      
```

箭头`>`的意思是：我们将命令的输出存到一个新的文件`INCAR_new`中，通过mv命令之前的INCAR替换掉。 但，这样做也太麻烦了，更简单一点，可以如下：

前面例子的INCAR中SIGMA的值已经不是0.01了，我们先从ex02/0.01中复制一个过来。

```
qli@bigbrosci 0.01 % cp ../0.02/INCAR  .
qli@bigbrosci 0.01 % cat INCAR  -n 
     1	SYSTEM = O atom 
     2	ISMEAR = 0       
     3	SIGMA = 0.01      
qli@bigbrosci 0.01 % sed -i '3s/0.01/0.02/g' INCAR 
qli@bigbrosci 0.01 % cat INCAR  -n 
     1	SYSTEM = O atom 
     2	ISMEAR = 0       
     3	SIGMA = 0.02    
```

**注意**

`sed –i` 是`sed 的命令`和`其附加选项`， `-i` 表示直接对源文件进行编辑，也就是说编辑之后源文件被新文件替换掉。因此，使用这个参数的时候要小心，小心，再小心，要格外小心！！！

* 最保险的做法就是运行前，先对操作的对象进行备份

```
qli@bigbrosci 0.01 % cp INCAR  INCAR_back
qli@bigbrosci 0.01 % sed -i '3s/0.01/0.02/g' INCAR 
qli@bigbrosci 0.01 % ls
INCAR  INCAR_back  KPOINTS  POSCAR  POTCAR
```

* 其次是，先`不加 -i` 运行下sed命令，确保输出的是正确结果后，然后再加上 `-i` 运行.

```
qli@bigbrosci 0.01 % cp INCAR_back  INCAR 
qli@bigbrosci 0.01 % sed '3s/0.01/0.02/g' INCAR
SYSTEM = O atom 
ISMEAR = 0       
SIGMA = 0.02      
qli@bigbrosci 0.01 % sed -i '3s/0.01/0.02/g' INCAR
qli@bigbrosci 0.01 % cat INCAR  -n 
     1	SYSTEM = O atom 
     2	ISMEAR = 0       
     3	SIGMA = 0.02    
```



#### For + Sed

1. 下面演示批量将0.01到0.09中所有INCAR中的0.01替换成0.05。既然我们知道了sed可以对单个文件进行操作，那么我们也可以结合for循环，来实现一个批量操作的目的。到现在为止，相信大家都可以看懂下面的命令操作。就不再啰嗦解释了。有一点需要注意的是grep 命令中的星号`*`，检查输入输出的时候用`*`非常方便。

```
qli@bigbrosci 0.01 % grep SIGMA */INCAR
0.01/INCAR:SIGMA = 0.01
0.02/INCAR:SIGMA = 0.01
0.03/INCAR:SIGMA = 0.01
0.04/INCAR:SIGMA = 0.01
0.05/INCAR:SIGMA = 0.01
....
qli@bigbrosci 0.01 % for i in *; do sed -i '3s/0.01/0.05/g' $i/INCAR; done 
qli@bigbrosci 0.01 % grep SIGMA */INCAR
0.01/INCAR:SIGMA = 0.05
0.02/INCAR:SIGMA = 0.05
0.03/INCAR:SIGMA = 0.05
0.04/INCAR:SIGMA = 0.05
0.05/INCAR:SIGMA = 0.05
....
```

2. sed 也可以不依赖for进行批量操作，下面例子中将前面替换的0.05全部替换回原来的0.01。

```bash
qli@bigbrosci 0.01 % sed -i '3s/0.05/0.01/g' */INCAR
qli@bigbrosci 0.01 % grep SIGMA */INCAR
0.01/INCAR:SIGMA = 0.01
0.02/INCAR:SIGMA = 0.01
0.03/INCAR:SIGMA = 0.01
0.04/INCAR:SIGMA = 0.01
0.05/INCAR:SIGMA = 0.01
....
```

2. 下面通过for + sed 将所有INCAR中的0.01替换为文件夹对应的数值。来实现我们之前的目标：每个文件夹中的SIGMA值与文件夹相同。命令如下：

```
qli@bigbrosci 0.01 % ls
0.01  0.02  0.03  0.04  0.05  0.06  0.07  0.08  0.09  0.10
qli@bigbrosci 0.01 % for i in *; do sed -i "3s/0.01/$i/g" $i/INCAR ; done  
qli@bigbrosci 0.01 % grep SIGMA */INCAR
0.01/INCAR:SIGMA = 0.01
0.02/INCAR:SIGMA = 0.02
0.03/INCAR:SIGMA = 0.03
0.04/INCAR:SIGMA = 0.04
0.05/INCAR:SIGMA = 0.05
....
```

**注意：**

* 这里我们用的是双引号` " "` ，sed 命令中你会见到有时候用单引号` ' '`，有时候用双引号 `" "`。但如果这里使用单引号，则所有的 0.01 都会被替换成 `字符$i` ，因为单引号中的所有内容都会被当做字符来处理，也就是里面是什么就输出什么。使用双引号，则可以读取`变量 $i` 的值，下面的例子大家一看就知道怎么回事了:

```bash
qli@bigbrosci 0.01 % abc=bigbro
qli@bigbrosci 0.01 % echo abc
abc
qli@bigbrosci 0.01 % echo '$abc'
$abc
qli@bigbrosci 0.01 % echo $abc
bigbro
qli@bigbrosci 0.01 % echo "$abc"
bigbro
```

* 给变量abc赋予一个值的时候，`=`前后没有空格；
* 这里单引号中的内容被原封不动地打印出来了。而双引号的话，则可以顺利地把变量调用起来。

* for i in *;  这里的 * 指的是当前目录下所有的文件以及文件夹，本例中没有文件，只有从0.01， 0.02， 0.03 到 0.10 的文件夹；所以： for i in  *  =   for i in 0.01 0.02 0.03  0.04  0.05 0.06  0.07  0.08 0.09 0.10
*  使用sed 命令将INCAR中的 0.01 (所有文件夹中的都是0.01)替换成文件夹的数字;  

```
sed -i "3s/0.01/$i/g" $i/INCAR 
```

当$i的值为0.01的时候，我们就把0.01/INCAR中的0.01替换为0.01；为0.02的时候，就把0.02/INCAR中的0.05替换为0.02，依次类推，直至for循环完成。

* 该命令瞬间运行完成，我们使用`grep SIGMA */INCAR`来查看下这些文件夹中的INCAR参数 ，圆满完成任务!

------



#### 实例演示

下面是for 循环结合`cp`,`sed`实现批量复制，并修改INCAR的例子。

```
qli@bigbrosci Ex02 % cat 01/INCAR  -n 
     1	SYSTEM = O atom 
     2	ISMEAR = 0       
     3	SIGMA = 0.01      
qli@bigbrosci Ex02 % for i in 0.{02..10}; do cp 0.01 $i ; sed -i "3s/0.01/$i/g"  $i/INCAR ;done 
qli@bigbrosci Ex02 % cat 0.05/INCAR
SYSTEM = O atom 
ISMEAR = 0       
SIGMA = 0.05     
```

上面的操作依次为：

* 通过`cat` 命令查看文件夹`0.01`中`INCAR`的内容; 后面添加` -n` 表示在查看INCAR中的内容时，也在输出对应的行数，方便我们查看；
* 第二行每一个for循环中，先将0.01 复制为 `$i`; 修改`$i/INCAR` 中SIGMA的取值。然后进入下一个循环，直至完成；
* Linux 下面的命令都有很多的选项，用以丰富我们的不同需求，比如上面的` cat -n`，可以使用 `man cat` 这个命令查看 cat 的其他选项。使用这个命令后，如果想退出，敲 q 键即可； 另外，我们也可以使用 `cat –help` 来查看，效果与`man cat` 一样。



### 总结

sed 是一个非常强大的命令，对于做计算的我们来说，熟练正确地使用sed可以极大的提高我们的工作效率。一方面sed不依靠for循环可以将批量替换多个文本中固定的字符；另一方面可以结合for循环，将字符替换为for循环相关的变量。大家务必硬着头皮掌握这个命令。这个网站列举了一些基本的用法：**http://man.linuxde.net/sed** 。大家参照着进行练习，也可以百度里面搜索一些其他的 sed 使用技巧，如果你有认为很好的sed 技巧，也可以发邮件分享给大师兄（lqcata@gmail.com）。在本节以及之前的练习中，我们并不着急去提交任务，反正已经走了计算的路，以后提交任务的机会还多着呢，也不差这一两天的学习时间。先从简单到复杂些，逐渐掌握Linux的一节操作命令，对以后的学习帮助很大。

1) 学会 `man command` 或者 `command –help` 查看命令的具体参数;

2) 大量使用`sed` 命令进行操作练习;

3) 知道 `*` 在for循环中代表的含义;

3) 熟知单引号`''`和双引号`""`的使用，以及区别;

4) 主动搜索相关的Linux命令的相关知识，积极操练;

5) 学会从单一操作，通过for循环转化成批量操作的思路。

```bash
for i in XXX; do YYY; done 
```

* XXX就是我们要操作的范围或者对象;
* YYY就是单一的一个操作。
