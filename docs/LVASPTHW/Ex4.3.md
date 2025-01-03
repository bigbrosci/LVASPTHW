# Ex4.3 For + sed + KPOINTS

前面我们学习了使用sed命令结合for循环对INCAR进行批量操作。同样，我们也可以对KPOINTS文件进行类似的批处理操作。本节，我们复习下KPOINTS的内容，病介绍下for + sed 组合对KPOINTS文件的操作。

### KPOINTS文件

前面我们学习到，KPOINTS文件只有简单的几行，如下：

```
K-POINTS  
0  
Gamma
1 1 1
0 0 0 
```

目前，对于大家来说，需要掌握的有以下几点：

* 会自己闭着眼把这几行写出来；

* 第三行的Gamma代表的是`gamma centered`的意思；
* 第四行中的1 1 1 俗称`gamma`点。很多时候，在QQ群里面提问题，别人说用`gamma`点算一下，指的就是`1 1 1`；
* 除了使用`gamma`点，我们还可以使用其他的数值，比如`2 2 2`，`3 3 3`， `3 3 1` 等，数值越大，计算量也就越大。具体的要根据你自己的体系进行测试，还要结合组里的计算能力来确定，这个我们后面会介绍；

* 对于气体分子或者原子的计算来说，也就是把它们放到一个格子的体系，使用`gamma`点就足够了。

本节，我们主要对KPOINTS的文件的第四行进行批量操作，将`1 1 1`改成` 2 2 2`， `3 3 3 `等。首先浏览下面的命令：

```bash
qli@bigbrosci LVASPTHW % ls
Ex01/  Ex02/ 
qli@bigbrosci LVASPTHW % mkdir Ex03 && cd Ex03
qli@bigbrosci Ex03 % for i in {1..6}; do cp ../Ex02/0.01/ ${i}${i}${i} ; done 
qli@bigbrosci Ex03 % ls 
111/  222/  333/  444/  555/  666/
qli@bigbrosci Ex03 % cat 333/KPOINTS  -n 
     1	K-POINTS  
     2	 0  
     3	Gamma
     4	1 1 1
     5	0 0 0 
qli@bigbrosci Ex03 % for i in {1..6}; do sed -i "4s/1 1 1/$i $i $i/g" ${i}${i}${i}/KPOINTS ; done 
qli@bigbrosci Ex03 % cat 333/KPOINTS  -n 
     1	K-POINTS  
     2	 0  
     3	Gamma
     4	3 3 3
     5	0 0 0  
```

**详解：**

* 第三行：我们使用了 `mkdir Ex03 && cd Ex03`这个命令。 `&&`的作用是将两个命令连起来运行，如果`&&`前面的命令运行成功，则继续后面的命令。这里我们先运行了`mkdir Ex03`的命令，成功后，然后通过`cd Ex03`这个新建的目录。但如果前面的命令运行不成功，我们还想运行第二个命令，那么可以用 ||这个将两个命令联系起来。百度自己搜索：`&&`  和 `||`的使用，多多练习，可以提高你敲命令的工作效率。

* 我们使用for循环，将`Ex02/0.01`文件夹复制成`111`， `222`， `333`等。这里我们在调用for 循环中的变量`i`的时候，使用的是`${i}`。为什么要加花括号呢？ 这是为了避免`$i`和后面的连在一起，从而导致调用失败。比如下面的命令行：

  ```
  iciq-lq@ln3:/THFS/home/iciq-lq/LVASPTHW/ex04$ for i in {1..6}; do echo $iA; done 
  
  
  
  
  
  
  iciq-lq@ln3:/THFS/home/iciq-lq/LVASPTHW/ex04$ for i in {1..6}; do echo ${i}A; done 
  1A
  2A
  3A
  4A
  5A
  6A
  ```



**反面教材**：在本书的第二版中，大师兄因为操作失误，把应该使用的双引号写成了单引号，导致`1 1 1`被替换成了`$i $i $i`。 在该错误的基础上，成功将把`$i $i $i` 批量替换成文件夹对应的数字：

```bash
qli@bigbrosci LVASPTHW % ls
Ex01/  Ex02/ 
qli@bigbrosci LVASPTHW % mkdir Ex03 && cd Ex03
qli@bigbrosci Ex03 % for i in {1..6}; do cp ../Ex02/0.01/ ${i}${i}${i} ; done 
qli@bigbrosci Ex03 % ls 
111/  222/  333/  444/  555/  666/
qli@bigbrosci Ex03 % cat 333/KPOINTS  -n 
     1	K-POINTS  
     2	 0  
     3	Gamma
     4	1 1 1
     5	0 0 0 
qli@bigbrosci Ex03 % for i in {1..6}; do sed -i '4s/1 1 1/$i $i $i/g' ${i}${i}${i}/KPOINTS ; done 
qli@bigbrosci Ex03 % cat 333/KPOINTS  -n 
     1	K-POINTS  
     2	 0  
     3	Gamma
     4	$i $i $i
     5	0 0 0 
qli@bigbrosci Ex03 % for i in {1..6} ; do sed -i "s/\$i \$i \$i/$i $i $i/g" $i$i$i/KPOINTS ; done 
qli@bigbrosci Ex03 % cat 333/KPOINTS  
K-POINTS  
 0  
Gamma
3 3 3
0 0 0 
```

* 这里我们没有用`${i}`，而是直接`$i$i$i`连在一起用了。说明这个时候，花括号有或者没有，对命令行影响不大。

* sed 操作的难点在于区别`$i`是调用的参数还是要被替换的字符。例子中我们用一个反斜杠 `\`将`$`转义成字符，进而避免将其按照变量来处理。说白了，就是让`$`这个符号变成一个纯文本符号，而不再发挥调用变量的作用。这一部分的知识，大家自行百度搜索：`Linux 转义符` 进行学习。

再举个例子：如果被替换的内容中含有`/`  , 直接输入则会被认为是分隔符，因此我们需要将其作为分隔符的作用去掉。怎么做呢? 输入`\/` (一个反斜杠加单斜杠，中间没有空格)，这样的话 `/` 就会被当成字符来处理啦! 大家好好琢磨下面的这个命令，我们要把`big/bro`中的`/`替换为`\`。如果你能理解了，转义符就基本入门了。

```bash
qli@bigbrosci Ex03 % echo big/bro 
big/bro
qli@bigbrosci Ex03 % echo big/bro | sed 's/\//\\/g'
big\bro
```

* 这里我们用了一个`|`，中文名字叫管道符，它的作用是将前面命令的输出结果传递给后面的命令，用作操作对象。百度自行搜索：`Linux 管道符`自主学习。



### 总结

在本节的操作中，我们可以学到很多知识，私以为对于一个新手来说，这一节的内容难度有些大，需要认真操作，思考，查阅相关的资料。简单总结一下，本节需要掌握的内容有：

* `&&`，`||`  和 `|` 的用法 ;

*  `${i} `中什么时候用花括号，什么时候不用;

*  sed 中的单引号，双引号的区别;

* 转义符在字符处理中的作用。

* 如何避免命令出错，以及出错后改怎么改正。

前面的四点都是死死的基本Linux操作，而最后一点则是考验大家智商的时候。做计算，肯定避免不了会敲错命令，犯各种各样的错误。在避免出错方面，我们要认真掌握命令操作的关键点以及总结前面错误的经验；在错误的改正方面，我们要多多动脑子，及时想办法补救。众多补救的办法中，提前将操作的对象进行备份是最为有效的。比如，在前面例子中，由于在`Ex02`中有源文件，即使在`Ex03`目录犯错后，我们大不了全部删除，重新再来一遍。所以，在大家没有正式进行计算前，先提个醒：**一定要时刻牢记备份自己的文件**。
