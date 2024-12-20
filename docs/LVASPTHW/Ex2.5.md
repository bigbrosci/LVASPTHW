# Ex2.5 POTCAR的准备

这一节，我们学习VASP计算中的赝势文件：**POTCAR**

### 简单说明

如果组里购买了VASP，那么再在VASP相关的某个目录下，一定会有对应的一套对应的赝势文件，本书默认大家已经知道去哪里找，不讨论从哪里下载POTCAR（小窍门：一般各个VASP相关的QQ群中，都会有打包的POTCAR文件）。在该目录下， 一般来说，会有LDA，PBE，和PW91这三个文件夹，主流的计算一般都是用PBE。当你进入PBE的文件夹后，就会找到各个元素所对应的POTCAR文件了。

### 劝退声明

没买VASP版权的话，就跟偷别人车上路一样，被交警逮住就坏事。平时自己练习还好，发文章的时候就犯难了。趁现在还早，如果组里没有版权，建议转到QE，CP2K等开源软件，工作照样继续，文章照样发。坚持使用的话，建议让老板出钱买版权，如果他不买还让你算，你就先忍着，等文章发表，毕业拿到学位之后，拿文章当举报信勒索他一票，不要太贪，十万块钱应该可以拿到手。


**POTCAR中各项的含义**

POTCAR中有很多信息，对于大部分的参数，本人也是只认识字母和数字，不知具体含义，所以只能介绍一下在实际计算中会用到的一些参数。本节用Fe的POTCAR中前面的几行作为一个例子，简单介绍一下。

```
 PAW_PBE Fe 06Sep2000
 8.00000000000000000
 parameters from PSCTR are:
   VRHFIN =Fe:  d7 s1
   LEXCH  = PE
   EATOM  =   594.4687 eV,   43.6922 Ry

   TITEL  = PAW_PBE Fe 06Sep2000
   LULTRA =        F    use ultrasoft PP ?
   IUNSCR =        1    unscreen: 0-lin 1-nonlin 2-no
   RPACOR =    2.000    partial core radius
   POMASS =   55.847; ZVAL   =    8.000    mass and valenz
   RCORE  =    2.300    outmost cutoff radius
   RWIGS  =    2.460; RWIGS  =    1.302    wigner-seitz radius (au A)
   ENMAX  =  267.883; ENMIN  =  200.912 eV
   RCLOC  =    1.701    cutoff for local pot
   LCOR   =        T    correct aug charges
   LPAW   =        T    paw PP
   EAUG   =  511.368
   DEXC   =    -.022
   RMAX   =    2.817    core radius for proj-oper
   RAUG   =    1.300    factor for augmentation sphere
   RDEP   =    2.442    radius for radial grids
   QCUT   =   -4.437; QGAM   =    8.874    optimization parameters
```

依个人的学习经验，VRHFIN， LEXCH，TITEL，ZVAL，ENMAX是用到最多的几个参数。

* VRHFIN 用来看元素的价电子排布，如果你元素周期表倒背如流，可以忽略这个参数；
* LEXCH 表示这个POTCAR对应的是GGA-PBE泛函；如果INCAR中不设定泛函，则默认通过这个参数来设定。
* TITEL 就不用说了，指的是哪个元素，以及POTCAR发布的时间；
* ZVAL 指的是实际上POTCAR中价电子的数目，尤其是做Bader电荷分析的时候，极其重要。
* ENMAX 代表默认的截断能。与INCAR中的ENCUT这个参数相关。

当然，如果你进入文件夹，使用`ls`命令后，会发现：即使对于同一个元素来说，也可能会有很多不同的情况。比如：

* 与GW 计算的对应的POTCAR，则标注为：`Fe_GW` 这样。（GW计算本人没接触过，这里就先不介绍了）；
* 根据价电子的处理方式，分成了诸如：`Fe`，`Fe_pv`，`Fe_sv`的这样的情况。v是valence的缩写。pv代表把内层的`p`电子作为价电子来处理。sv代表则是把更内层的`s`电子也作为价电子来处理。具体到自己体系中的元素，可以结合元素周期表，以及`ZVAL`关键词所对应的价电子数目，来进行推断。
* 此时，我们就需要学习一个非常有用的Linux命令了： `grep`。 下面是我们使用grep命令，来获取所有与Fe相关POTCAR的价电子信息。

```
$ ls Fe*
Fe:
POTCAR  PSCTR

Fe_GW:
POTCAR  PSCTR

Fe_pv:
POTCAR  PSCTR

Fe_sv:
POTCAR  PSCTR

Fe_sv_GW:
POTCAR  PSCTR

$ grep ZVAL Fe*/POTCAR
Fe/POTCAR:   POMASS =   55.847; ZVAL   =    8.000    mass and valenz
Fe_GW/POTCAR:   POMASS =   55.847; ZVAL   =    8.000    mass and valenz
Fe_pv/POTCAR:   POMASS =   55.847; ZVAL   =   14.000    mass and valenz
Fe_sv/POTCAR:   POMASS =   55.847; ZVAL   =   16.000    mass and valenz
Fe_sv_GW/POTCAR:   POMASS =   55.847; ZVAL   =   16.000    mass and valenz
```

* 还有把内层d轨道考虑到价电子层里面去的，比如：`Ge_d`。
* 某些元素，还有一些以 _h， _s 结尾的，是 hard和soft的缩写。带`h`的POTCAR中截断能比普通的要高出很多。带`s`的截断能要小很多。这里我们就可以通过`grep` 结合 `ENMAX`来查看一下：

```
$ grep ENMAX Ge*/POTCAR
Ge/POTCAR:   ENMAX  =  173.807; ENMIN  =  130.355 eV
Ge_d/POTCAR:   ENMAX  =  310.294; ENMIN  =  232.720 eV
Ge_d_GW/POTCAR:   ENMAX  =  375.434; ENMIN  =  281.576 eV
Ge_GW/POTCAR:   ENMAX  =  173.807; ENMIN  =  130.355 eV
Ge_h/POTCAR:   ENMAX  =  410.425; ENMIN  =  307.818 eV
Ge_sv_GW/POTCAR:   ENMAX  =  410.425; ENMIN  =  307.818 eV
```

**POTCAR的选择**

既然对于同一个元素，存在那么多的POTCAR类型，计算的时候我们改怎么选择呢？这里大师兄只能给的建议是：如果没有特别的需求，直接采用VASP官网推荐的即可, 去VASP Wiki: <https://www.vasp.at/wiki/index.php/Available_pseudopotentials> 

**Standard potentials** --> **List of PBE potentials** --> **加粗的即为vasp所推荐的**

我们在计算的时候，根据体系中的元素，将这些元素的POTCAR结合起来，组成一个新的POTCAR，这个结合的步骤，我们需要用到Linux的另一个命令：`cat`。比如VASP官网的例子，体系中含有Al， C，H三种元素。

```
cat ~/pot/Al/POTCAR ~/pot/C/POTCAR ~/pot/H/POTCAR > POTCAR
```

通过这一行命令就可以把`Al`，`C`，`H`所对应的POTCAR结合在一起，生成一个新的POTCAR文件，OUTCAR中的元素顺序一定要和POSCAR保持一致，否则计算会出错，为了避免计算出错，还有一些高级的方法，这个在后面会慢慢讲解。

本节讲的是O原子的计算，官网推荐的氧原子POTCAR，默认的截断能是400，价层有6个原子。直接把O这个文件夹中的POTCAR直接复制到INCAR所在的目录即可。



**POTCAR检查常用的Linux命令：**

查看POTCAR中的元素:  

```
grep  TIT POTCAR
```

查看POTCAR的截断能: 

```
grep  ENMAX POTCAR
```

查看POTCAR中元素的价电子数目：

```
grep  ZVAL POTCAR
```

举一反三，只要找到了关键词，我们就可以通过`grep`命令来进行查看。不仅仅局限在POTCAR， `grep`命令也可以用来查看任何文件。



### 总结：

这一节，我们简单介绍了一下`POTCAR`中的内容，选取规则，以及通过`grep`命令和关键词进行查看。如果你能独立完成下面的几点，就圆满完成了本节的学习：

* VRHFIN， LEXCH，TITEL，ZVAL，ENMAX 这几个参数的大体意思；
* 初步了解：Fe_sv，Fe_pv， Ge_d,  Ge_gw，C_s, C_h 这些标记的含义；
* 查看VASP官网，了解VASP推荐的POTCAR；
* 使用`grep`命令来获取POTCAR中有价值的信息， 开始学习并熟悉使用`cat`命令。百度下就能发现网上有大量免费的例子，自己照着敲，多练习就完事，没什么好途径。



通过前面几节的学习，初步了解VASP四个主要输入文件的是怎么制作的，一些简单参数的含义，以及每个文件所对应的格式和细节。本节我们分成了很多小节，每节内容都很多，但对新手来说，信息量可能有些大。但不需要一次性全部掌握，因为在后面的学习中，我们会逐渐深入。自己在课题进行的过程中，也会加深自己的理解。但书中要求掌握的部分，必须要牢牢记住。

本书的名字为：`The Hard Way`。意思是，学习VASP并不是一蹴而就的，需要一个长时间的积累过程。所以，新手切勿急躁，很多内容看不懂不要紧，务必要静下心来浏览一遍，自己跟着说明亲自去实践，**切不可复制粘贴**。 本节所讲解的东西，都务必去VASP官网找对应的说明，认真阅读，反复思考。养成潜心学习官网教程，查找参数说明的良好习惯，从而远离网络上那些错误的信息。尤其是对于新手来说，很多都不懂的时候，没有自己的主见，别人一说就被牵着鼻子走了。

