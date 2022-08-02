# Ex_N 通过关键词判断优化任务收敛或者结束

怎么通过OUTCAR中的关键词来判断自己的任务是否收敛呢？今天我们就通过学习bash来简单介绍一下脚本工作的原理。



### 手动判断任务结束

首先我们要知道一个任务结束后的输出结果长什么样子，用什么关键词去判断任务结束或者收敛。一般来说可以通过查看`OUTCAR`文件来判断。 下面是一个已经收敛的优化例子：

```bash
qli@bigbrosci H2O_gas % ls
CONTCAR          EIGENVAL         INCAR            OSZICAR          POSCAR           freq/            vasprun.xml
DOSCAR           IBZKPT           KPOINTS          OUTCAR           XDATCAR          run_vasp_single*
qli@bigbrosci H2O_gas % tail OUTCAR 
                            User time (sec):       26.466
                          System time (sec):        5.283
                         Elapsed time (sec):       32.497
  
                   Maximum memory used (kb):      210180.
                   Average memory used (kb):           0.
  
                          Minor page faults:      1151515
                          Major page faults:            3
                 Voluntary context switches:         2501
qli@bigbrosci H2O_gas % grep reach OUTCAR 
------------------------ aborting loop because EDIFF is reached ----------------------------------------
------------------------ aborting loop because EDIFF is reached ----------------------------------------
------------------------ aborting loop because EDIFF is reached ----------------------------------------
------------------------ aborting loop because EDIFF is reached ----------------------------------------
------------------------ aborting loop because EDIFF is reached ----------------------------------------
------------------------ aborting loop because EDIFF is reached ----------------------------------------
------------------------ aborting loop because EDIFF is reached ----------------------------------------
------------------------ aborting loop because EDIFF is reached ----------------------------------------
 reached required accuracy - stopping structural energy minimisation
```

1） `tail OUTCAR` 查看OUTCAR最后的几行，如果出现这样的结果，说明任务结束了。

这里需要注意的是：`结束≠收敛`。

2）判断是否收敛，我们可以使用`grep reached OUTCAR`这个命令，我们会得到2个结果，一个是`aborting loop because EDIFF is reached`，暂且记为A1， 另一个是`reached required accuracy - stopping structural energy minimisation` ，暂且记为A2。如果一个优化任务收敛的话，我们是通过A2来判断的。



### 关键词判据

现在我们就可以把A2名字改成A。A有什么特点呢？ 我们随便列几个：

* 我们读OUTCAR，一旦发现A这一行，那么就知道任务收敛了。（但是`收敛≠结束`，有时候收敛这一步完成后，任务因为其他原因终止了，比如误删、写WAVECAR内存不够了，服务器停电了，都会导致不输出`tail OUTCAR`的那些信息。这种情况处理很简单，排除故障后，直接把CONTCAR复制成POSCAR，再次提交一次任务即可。 ）
* A在OUTCAR中只出现一次，且出现在`grep reach OUTCAR` 命令输出的最后一行，如果用``'reached required accuracy' ``做为grep的对象，那么只有一行。

* A的第一个单词是reached，最后一个单词是minimisation；第2个单词是`required`；你也可以选其他的单词。

* 这些词就可以作为关键词来判断任务是否结束或者收敛。

  

### 写脚本的思路

* 如果看到前面`tail OUTCAR`输出的内容，判断任务结束。

* 如果发现A，判断任务收敛。
* 前面两个都可以用一些关键词作为判据。如果发现某个唯一出现的关键词，说明任务结束后者收敛。比如下面我们运行一个命令，如果输出结果是`reached`，那么任务收敛了。使用一些常见的：`tail`,`cut`,`awk`命令来获取关键词作为判据。cut还得数空格数目，除非格式非常固定，这里建议用awk。

```bash 
qli@bigbrosci H2O_gas % grep reached OUTCAR  |tail -n 1
 reached required accuracy - stopping structural energy minimisation
qli@bigbrosci H2O_gas % grep reached OUTCAR | tail -n 1| awk '{print $1}'
reached
qli@bigbrosci H2O_gas % grep reached OUTCAR  |tail -n 1 | cut -c 2-8
reached
qli@bigbrosci H2O_gas % grep 'reached required accuracy' OUTCAR 
 reached required accuracy - stopping structural energy minimisation
qli@bigbrosci H2O_gas % grep 'reached required accuracy' OUTCAR |awk '{print $1}'
reached
qli@bigbrosci H2O_gas % grep 'reached required accuracy' OUTCAR |awk '{print $NF}'
minimisation
qli@bigbrosci H2O_gas % grep 'reached required accuracy' OUTCAR |awk '{print $2}' 
required
```

* 判断关键词这一过程通过`if`来实现，

```bash
qli@bigbrosci H2O_gas % b='reached'
qli@bigbrosci H2O_gas % c=$(grep reached OUTCAR  |tail -n 1 | awk '{print $1}')
qli@bigbrosci H2O_gas % echo $c
reached
qli@bigbrosci H2O_gas % c=`grep reached OUTCAR  |tail -n 1 | awk '{print $1}'`
qli@bigbrosci H2O_gas % echo $c
reached
qli@bigbrosci H2O_gas % if [ c=b ]; then echo bigbro ; fi
bigbro
```

### 脚本及效果

看完上面的部分，基本上有些眉目了，下面具体看下脚本以及工作的效果。

```bash
qli@bigbro H2O_gas % cat check_out.sh 
#!/usr/bin/env bash 
kwc='reached' # Key Word for Convergence
kwf='Voluntary' # Key word for job finish
soc=$(grep $kwc OUTCAR |tail -n 1 |awk '{print $1}')
sof=$(grep $kwf OUTCAR |tail -n 1 |awk '{print $1}')

if [ $soc=$kwc ]; then 
echo 'converged'
fi

if [ $sof=$kwf ]; then 
echo 'finished'
fi

if [ $soc=$kwc -a $sof=$kwf ]; then 
echo 'Perfect'
fi
(base) qli@lqlhz H2O_gas % bash check_out.sh 
converged
finished
Perfect
```

* 脚本里面用了2个关键词，一个判断任务结束，一个判断任务收敛；
* 当2个关键词都能被找到的时候，说明任务顺利完成了。
* `echo` 命令输出，可以根据自己喜好稍微改改，方便以后在别人面前装逼。
