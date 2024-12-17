### Ex2.4 POSCAR的准备

#### 简单说明
POSCAR 包含计算模型的结构信息，也就是你要研究的对象。POSCAR有自己固定的格式，每一行都有特定的含义，认真掌握这些，对于搭建模型非常有帮助。对于本节的例子：O原子的计算，我们要把O原子放到一个格子里面，格子大小为：8 $\times$ 8 $\times$ 8 $\AA{^3}$。那么POSCAR至少包括：

1） 格子的信息：尺寸大小；

2） O原子信息：在格子中的位置坐标

3)  注意：这仅是例子，不是正确计算O原子的POSCAR；


#### POSCAR的输入

```
O atom in a box 
1.0             # universal scaling parameters 
8.0 0.0 0.0     # lattice vector a(1) 
0.0 8.0 0.0     # lattice vector a(2)  
0.0 0.0 8.0     # lattice vector a(3)  
O               # O element， not zero
1               # number of atoms 
Cartesian       # positions in cartesian coordinates 
0.0 0.0 0.0           #
```

**详解：**

* 第一行：同样随便写，但不能不写；
* 第二行：Scale factor，称为缩放系数，这里是1.0；简单介绍下缩放系数：
  * 本例子中我们把O原子放在一个Box里面，box尺寸为8 $\times$ 8 $\times$ 8 $\AA{^3}$
  * 如果把1.0 改成1.1，而后面保持不变，那么box的实际尺寸就是8.8 $\times$ 8.8 $\times$ 8. $\AA{^3}$
  * 如果要改变scale factor，要保持体系是分数坐标系。（下面会介绍到。）
  * 本人喜欢一直用1.0。然后直接改box大小。

* 第三到五行：是组成格子的三条边的坐标信息；从原点出发，在xyz轴上分别取8$\AA$。这个很容易理解；
* 第六行：体系中的元素，这里我们算的是氧原子，所以写：O，即氧的元素符号。需要注意的有以下几点：
  * vasp4.xx版本里面没有这一行，不过现在几乎没人用4.X的版本了；但是如果你接触到ASE，会发现ASE默认保存的POSCAR是4.X的版本；这个要注意。
  * O的符号和数字0容易混淆，一定要注意；
  * 第一个元素符号要顶格写，前面不要有空格，有可能会出错；
  * 如果计算文件夹里面，已经有与结构相一致的POTCAR，那么POSCAR里面即使删了这一行有不会影响计算，VASP计算的时候按照VASP4.X的格式读取，但输出文件CONTCAR中会把该行自动加上，加上的元素则以POTCAR为准。（新手跳过）
* 第七行：与第六行中元素相对应的原子数目，这里我们只有1个氧原子，所以写成1；
* 第八行：体系中原子的坐标系，可以为笛卡尔坐标，也可以为分数坐标系。注意的有以下几点：
  * C或者c代表笛卡尔坐标， D或者d代表分数坐标系；
  * 这一行同KPOINTS的第三行一样，即只认第一个字母；Cartesian和cat效果一样， Direct 和 dog 效果一样。
  * VASP输出文件CONTCAR里面采用的是分数坐标系。
* 第九行：体系中原子的坐标信息。这里我们把O原子放到了原点（0.0 0.0 0.0）的位置，大家也可以随便放一个位置，比如：（4.0 5.0 6.0），（1.1 2.5 6.5）都是可以的。由于周期性的存在，不管你怎么放，相邻两个格子之间氧原子的距离都是一样的。
* 写完之后，和INCAR，KPOINTS文件一样，直接保存成POSCAR即可。

##### 两点说明

* 第二行中的Scale factor还可以写成其他的数字，例如：写成2.0，则后面的格子以及原子坐标相关的数值都要除以2。一般来说，写成1.0即可，这样比较直观，清晰;

* 笛卡尔和分数坐标系的区别是从原子的坐标行开始的（这个例子里面是第8行），即坐标前面的都保持完全一致。 也就是说，如果想从笛卡尔转换成分数坐标，我们只需将Cartesian改成Direct，然后修改后面的原子坐标，而Cartesian行前面的部分（1-7行）保持不变。


另外，附上“史上最简单的Direct坐标转Cartesian脚本”

在VASP计算中，我们常常会遇到两种坐标表示方式：**Direct**（相对晶胞坐标）和**Cartesian**（笛卡尔坐标）。

- **Direct 坐标**：以晶胞向量为基准，使用归一化的坐标系描述原子的位置。优点是更适合周期性晶胞的操作，缺点是有时对空间感不直观。
- **Cartesian 坐标**：直接用 Ångström （埃）为单位描述原子位置，与实验数据和图像直观对应，适合与图形化工具配合使用，但在变换晶胞时需注意重新定义。

为了方便在实际计算中进行两种坐标系的转换，大师兄给你准备了一个功能极其强大的的脚本，命令一敲，立马完事。比用什么可视化软件打开另存式的转换方式强百倍千倍，尤其是结构多的时候，妥妥滴解放双手！！！


脚本如下：

```python
#!/usr/bin/env python3
#Script for converting Direct coordinates to Cartesian coordinates in VASP POSCAR files.

import sys
from ase import io

if len(sys.argv) != 2:
    print("Usage: python3 direct_to_cartesian.py input_POSCAR")
    sys.exit(1)

file_in = sys.argv[1]

try:
    # Read the POSCAR file using ASE
    model = io.read(file_in, format='vasp')

    # Convert Direct to Cartesian by re-saving the file
    io.write('POSCAR_cartesian', model, format='vasp', vasp5=True)

    print("Conversion complete! Cartesian coordinates saved in 'POSCAR_cartesian'.")
except Exception as e:
    print(f"Error: {e}")
```


使用说明

1. 确保已安装 ASE，不会安装，参考之前的公众号内容以及网站的介绍。

2. 将脚本保存为 direct_to_cartesian.py。

3. 在终端运行：

```bash
python3 direct_to_cartesian.py POSCAR
```

4. 转换后的文件将保存在当前目录下，命名为 `POSCAR_cartesian`。


通过这个简单脚本，你可以快速将 Direct坐标系转换为Cartesian 坐标系，从而提高建模和分析的效率。



### 本节重点：

* 学会写O原子在格子里面这个模型的POSCAR；
* 知道每一行所代表的含义；
* 理解O原子的模型。
* 记住这个脚本，以后用得着。
