### Ex1.5 VASP的编译


本节简单介绍如果编译基础款的VASP。这里说的基础款指的是直接安装从官网下载的VASP版本。我们在计算中，常常根据自己的计算需求来选择不同的版本，比如加了溶剂化效应的，考虑VTST计算过渡态的，计算Wannier90的，亦或者是只优化xy轴的版本等等。它们都是在VASP官网的版本上修改代码，重新编译的。原理上来说，只要官网的版本可以顺利编译，其他版本的编译也只是一个时间问题，后面随着练习内容进行介绍。

我们简单理一下编译的思路，其实主要有以下四方面：

 * 编译前的准备工作（一）

    * 浏览官网：<https://www.vasp.at/wiki/index.php/Installing_VASP.6.X.X>   我们从官网描述的的:`Requirements`可以发现发现，不管是Compiler, Numberical Libraries, 还是MPI，它们都有一个共同的要求，就是`intel-opneapi`。 `Intel OneAPI` 是Intel推出的一套统一的编程模型和开发工具，旨在简化不同硬件平台（如 CPU、GPU、FPGA 等）上的开发工作。它是一款免费，功能强大，且全面的软件包，有兴趣的可以去官网看看相关介绍。
*  因为编译 VASP 需要用 `Math Kernel Library` 和 `MPI Library`，我们需要下载 `Base toolkit` 和 `HPC toolkit` 。下载连接如下： 
    
<https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html#hpc-kit>
   
 *  也可以通过命令下载以及安装，具体参考下载网页中`Command-Line Installation Instructions`的描述。 

```shell
qli@bigbro$ ls
l_BaseKit_p_20XXX_offline.sh  l_HPCKit_p_XXX_offline.sh
qli@bigbro$ sh l_BaseKit_p_20XXX_offline.sh  
qli@bigbro$ sh l_HPCKit_p_XXX_offline.sh
```

运行上面命令首先会解压安装包。注意的有下面三点：

- 下载完成后进行安装,注意顺序：先安装 `Base toolkit`，然后是`HPCkit`。

+ 解压结束后，如果是用 `xshell` 远程登陆的话，会问要不要`run X11`图形界面。大家有图形界面的话就用，没有的话就选择`No`。其他的按照流程一步一步来即可。
+ 安装 `Base toolkit` 的时候，大家可以选择 `Accept & Customize` 取消安装 `Python` 解释器，从而节省时间。 `HPC toolkit` 不需要自己`customize`。 

#### 设置 Intel OneAPI 环境变量

设置 `Intel OneAPI` 环境变量需要用到 `/home/xxx/intel/oneapi/setvars.sh` 文件。大家把 `source /home/xxx/intel/oneapi/setvars.sh` 添加到 `~/.bashrc` 文件中即可。xxx 为`username`。比如用户名为`bigbro`:

```shell
echo 'source /home/bigbro/intel/oneapi/setvars.sh' >> ~/.bashrc
```

* 编译前的准备工作（二）

 另一个准备就是下载VASP的安装包了。这个自己去VASP portal下载（如果有账户的话），没有账户，在群里发个红包求助下，大家也愿意帮忙。

* 编译VASP（三）

需要注意的是：OneAPI 2024.0 以及之后的版本中，`ICC` 已经被替换成了`ICX` : **Intel® C++ Compiler Classic (icc) is deprecated and was discontinued in the oneAPI 2024.0 release.** 相应的，我们在编译前，要将makefile.include 中的`icc`和`icpc` 需要换成 `icx` 和 `icpx` （在第六行的操作中将第1，2行更新到makefile.include文件）; 然后静待安装成功即可。

```shell
1 CC_LIB      = icx
2 CXX_PARS    = icpx
3 tar zvxf vasp.5.4.4.tar.gz
4 cd vasp.5.4.4/
5 cp arch/makefile.include.linux_intel makefile.include
6 vi makefile.include
7 make all
```

**注意事项：**

+ 安装 `Base toolkit` 的时候，大家可以选择 `Accept & Customize` 取消安装 `Python` 解释器，从而节省时间。
+ OneAPI 2024.0以及之后版本中ICC被替换成了ICX, `makefile.include`需要相应的改变。


![Tip Code](figs/Tip_Code.png)
