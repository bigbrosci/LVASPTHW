# Ex3.7 VASP的电荷密度输出文件



在 VASP 中，电荷密度相关的输出文件主要包括以下几类，它们分别用于记录不同类型的电子密度数据（总电荷密度、赝密度、全电子密度、静电势等），用途各异。比如： CHGCAR 主要包含计算体系的电荷密度相关信息，这也是我们进行电子结构分析时候的一个重要文件。 用这个文件我们可以做以下的事情：

1） **重启后续计算（restart）**  
使用 `ICHARG=1`（或者其它相应方法）可基于已有 CHGCAR 实现快速收敛计算，特别适合在微调参数或 k 点网格时重启。尤其是你的体系电子 结构 比较 复杂的时候，如果已经有一个比较合理的结果，可以保存CHGCAR，以备后面的计算需要。需要注意的是，CHGCAR比较大，如果存储吃紧，而且体系电子结构不是很复杂 的时候，可以在 INCAR 中设置 `LCHARG = .FALSE.`控制不写入数据，等需要分析的时候再换成 `.TRUE.`

2）**电荷密度可视化**  
CHGCAR 提供精细电子密度数据，可用于在软件如 VESTA、VMD、EDP 等中绘制等值面、平面切片图等。也可以 用来构建电荷密度差图（Charge Density Difference）去分析吸附、界面或反应过程中的电子转移。这里需要 强调的 一点是：Charge Density Difference 是电荷密度差，而不是差分电荷。大家在交流的时候不要混淆。

3）**用于 Bader 电荷分析** 
CHGCAR 文件是 Bader 程序所需输入之一，用于将电荷空间按原子进行分割，计算每个原子上的电荷分布。详细的计算细节请参考：[theory.cm.utexas.edu/henkelman/code/bader/](https://theory.cm.utexas.edu/henkelman/code/bader/)  



除了CHGCAR，VASP的输出结果中还有其他的电荷密度相关的文件，我们大致看下，心里有数即可。

| 输出文件名  | 文件内容说明                                   | 常见用途                                     | 对应 INCAR 参数                            |
| ----------- | ---------------------------------------------- | -------------------------------------------- | ------------------------------------------ |
| **CHGCAR**  | 总电子密度 + PAW one-center 占据数             | 差分电荷图、Bader 分析、自洽重启、电荷可视化 | `LCHARG = .TRUE.`（默认）                  |
| CHG         | 电荷密度 × 网格体积（无 PAW 修正）             | 可视化用，轻量级版本                         | `LCHARG = .TRUE.`（默认）                  |
| **AECCAR0** | 原子核（core electrons）电荷密度               | 与 AECCAR2 联合用于全电子密度或 Bader 分析   | `LAECHG = .TRUE.`                          |
| AECCAR1     | 原子赝电荷密度                                 | 算bader的时候生成，但没用到                  | `LAECHG = .TRUE.`                          |
| **AECCAR2** | 价电子（valence electrons）电荷密度            | 与 AECCAR0 联合使用计算Bader                 | `LAECHG = .TRUE.`                          |
| **LOCPOT**  | 局域静电势（electrostatic potential）          | 功函数，电势图、电势差分析、电场分布         | `LVTOT = .TRUE.`                           |
| ELFCAR      | 电子局域函数（Electron Localization Function） | 共价性分析、电子成键性可视化                 | `LELF = .TRUE.`                            |
| PARCHG      | 指定态的波函数密度分布（如特定能带、k点）      | LUMO/HOMO 可视化、缺陷态空间分布分析         | `LPARD = .TRUE.` + 设置 `IBAND`, `KPOINTS` |
| vaspwave.h5 | HDF5 格式电荷密度（含 CHGCAR 信息）            | 替代 CHGCAR 存储为 HDF5，节省空间            | `LH5 = .TRUE.`                             |



需要注意的主要有以下几点：

1） 加粗的是大师兄本人日常计算中用到的比较多的。其他的基本都不用，直接删掉。

2）这些Car的文件都很大，很容易爆存储，需要注意 。

3）网上有很多关于如何通过脚本去处理并分析结果的教程。这里大师兄本人推荐的主要有以下几个：

3.1：VTST： ` chgsum.pl`, `bader`, `chgdiff.pl` 等，具体参考：[SCRIPTS — Transition State Tools for VASP](https://theory.cm.utexas.edu/vtsttools/scripts.html#) 

3.2:  ASE的`vtotav.py` 可以用来分析`LOCPOT`  功函数分析很方便。(https://github.com/znotft/ase_tools/blob/master/scripts/vtotav.py) 

3.3: ASE 和 Pymatgen 都有相关的I/O模块，有兴趣的可以去研究。 

3.4: VESTA 用来可视化，基本上大家都在这么做。这里提一个很有意思的问题：VESTA是来自日本的一款强大的建模软件，看完照相馆的你是否还会继续用？我们有没有自己开发的可以替代的产品？



**简单小结一下：** 

本节主要列举了VASP关于电荷密度的相关输出文件 ，大家心里有数即可。如果后面的计算需要相关的文件，不要担心，已经有很多成熟的脚本/程序帮你处理，可视化，网上也有很多相关的教程。你所需要知道的就是这些文件可以做什么样的分析，可以得到关于体系什么样的结果，做出什么样的图？ 此外，文件中各行各列的数字所代表的信息，经过前面几节的学习，相信你可以完全去浏览官网，结合AI等工具去自主探索了。这里 就不再啰嗦了。

