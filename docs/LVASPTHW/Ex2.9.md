# Ex2.10 VASP任务的提交

前面我们已经准备好了VASP的四个输入文件，学习了一系列的批量操作。相信大家对VASP的四个输入文件有了一定的认识，对Linux的基本操作，一些常用的命令也有所了解。本教程并不是快餐，填鸭式的教程。大师兄的思路就是带着你们去思考，去查阅，去练习，进而达到掌握VASP计算的目的。而不是很多公众号所谓的几分钟，几小时学会啥啥啥教程。前面瞎BB了好多节才讲到VASP任务的提交，相信很多图快的同学早已经弃学了。言归正传，那么该如何让vasp 算起来呢？这里要说明几点：

1. 四个输入文件我们已经准备好了，剩下的就是运行VASP，读取这四个文件进行计算
2. 每个课题组都会有自己不同的任务提交系统，一般常见的有以下2种，大家可以花些时间学习下相关的命令以及介绍。网上搜一搜也能发现一堆。

* [The Portable Batch System (**PBS**)](https://www.openpbs.org/)
* [Simple Linux Utility for Resource Management (**SLURM**)](https://slurm.schedmd.com/documentation.html)

3. 大家可以向自己的师兄师姐学习提交任务的方法。如果使用的是超算中心，这也是大家经常接触到的，开通账号的时候，管理员肯定会把提交，查看任务的基本操作文档发到你手上，自己认真看一下即可。



### 提交任务的脚本：

任务的提交一般就是通过脚本，或者命令，告诉服务器运行VASP去计算我们这个任务。下面简单浏览下`PBS`和`SLURM`的两个任务脚本。

`PBS`: （脚本名：`run_vasp.sh`）

```bash
#!/bin/bash
#$ -cwd
#$ -pe mpi 20
#$ -N O_atom
#$ -l exclusive=1
#$ -o stdout_$JOB_NAME.$JOB_ID
#$ -e stderr_$JOB_NAME.$JOB_ID
#$ -l h_cpu=100:00:00
#$ -m ae
#$ -M lqcata@gmail.com

module load  openmpi/4.0.2:intel
module load  ase/3.16.2:python3

BIN=/home/2092/bin/vasp5.4.4/src/bin/vasp_std

mpirun -np 20   $BIN > vasp.out
```



`SLURM`：(脚本名为：`run_vasp.sh`)

```bash
#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --tasks-per-node=36
#SBATCH --cpus-per-task=1
#SBATCH --mem=72G
#SBATCH --job-name=O_atom
#SBATCH --partition=standard
#SBATCH --time=108:00:00
#SBATCH --output=%j.out
#SBATCH --error=%j.out
#SBATCH --mail-user='lqcata@gmail.com'
#SBATCH --mail-type=END,FAIL,TIME_LIMIT_90
#SBATCH --export=NONE
#SBATCH --no-step-tmpdir

module load  openmpi/4.0.2:intel
module load  ase/3.16.2:python3

BIN=/home/2092/bin/vasp5.4.4/src/bin/vasp_std

mpirun -np 36   $BIN > vasp.out

```


### 提交任务注意的地方：

1. 提交到什么队列（`partition`）？使用超算或者大型集群的时候，针对任务类型或者超算中心的分配，会有不同的队列用于短时间测试、普通计算、（超）长时间计算、大内存计算、 GPU计算等。自己要确定提交到什么队列，在脚本里面相应地修改。
2. 任务调用多少计算资源？根据自己的计算大小，根据服务器的能力，大体估测一下需要的节点数目，内存，以及计算的时间等信息，然后相应的修改。
3. 任务的名字简洁清晰，方便自己查看，有时候不能以数字或者特殊符号开头，可能会出错。
4. 服务器支持邮箱通知，也可以专门申请一个接受任务通知的邮件，或者设置过滤规则，避免自己的邮箱被服务器狂轰滥炸。 
5. `原则：Rubbish in, Rubbish out.` 提交任务的时候为了提高计算成功率，避免得到一堆无用的数据，要认真检查输入文件，也就是这里`Rubbish`主要来源的五部分：（Windows用户出现问题，第一解决方案就是用`dos2unix`先去尝试解决。）

* `INCAR`: 错误或者不合理的参数；
* `KPOINTS`：过大或者过小；VASP的输出文件（一）

* `POSCAR`：太粗糙或者严重不合理的模型结构；

* `POTCAR`：选取不合理的`POTCAR`，或则与`POSCAR`中元素不一致；

* `run_vasp.sh` ：提交任务脚本相关的错误。

  

### 提交命令：

检查完输入文件，根据要调用的资源写好脚本后，可以通过下面的命令提交任务。具体以自己的实际情况为准：

```bash
$ qsub run_vasp.sh   # PBS 
Your job 5198249 ("O_atom") has been submitted

$ sbatch run_vasp.sh # Slurm
Submitted batch job 987963
```



### 总结

本节我们简单介绍了下任务的提交，大家需要学习的有以下几点：

1. 谨记`Rubbish in, Rubbish out`的原则，提交任务前认真检查输入文件以及提交任务的脚本。
2. 研究自己服务器的任务管理系统（`PBS`或者`Slurm`），有针对地去了解，学习下相关的命令。
3. 提交前面我们准备好的`VASP`任务。
