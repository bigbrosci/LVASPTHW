# Ex3.8 VASP 输出文件：WAVECAR



这节咱们来聊聊 VASP 输出中一个“看起来很高深，最接近量子计算本源的”的一个文件：`WAVECAR`。做计算，当然听过无数遍波函数，它用来完整描述一个粒子或体系在某一时刻的**量子态**。 搞清楚波函数是什么，怎么用，在计算里能帮你省时省力，有时候还能救命。

---

#### 1. WAVECAR 究竟是什么？ [WAVECAR - VASP Wiki](https://www.vasp.at/wiki/WAVECAR)  

`WAVECAR` 首先是VASP的一个二进制的输出文件，里面存储了 Kohn–Sham 波函数的详细信息，如：

- 能带数量（NBAND）  
- 初始截断能（ENCUTI）  
- 初始基组定义（AX）  
- 初始解的本征值（CELEN）  
- 费米权重（FERWE）  
- 波函数本身（CPTWFP）

也就是说，这是保存了一套“初步的、非常完整”的波函数数据的文件。

---

## 2. 为什么 WAVECAR 很关键？

- **连续计算的起点**  
  WAVECAR和CONTCAR一一对应，是在分子动力学（MD）模拟中（`IBRION = 0`），`WAVECAR` 通常包含了“下一个时间步”的预测波函数，与你的 `CONTCAR`（几何结构）是一致的。这种衔接让计算更顺利，也更有效率。当然，这是VASP官网的说法，大师兄觉得这个功能有些鸡肋，毕竟WAVECAR很大，读写很浪费时间，若体系不复杂，直接从CONTCAR 开始续算就OK，没必要非要读取WAVECAR。 此外，VASP意外终止，WAVECAR没有更新，也是个残废品没什么价值。 本人虽然不是什么MD的行家，但在使用的过程中，就没有保存过WAVECAR的习惯。

- **静态或结构优化**  
  如果你做的是结构优化、能带扫描等（`IBRION = -1, 1, 2`），`WAVECAR` 保存的是最后一步 Kohn–Sham 波函数的解。
  
- **复现自己的结果**

  如果你的体系电子结构很复杂，用同一个输入文件计算两次可能会得到两个不同的结果，这时候WAVECAR就比较重要， 你可以把准确的计算对应的WAVECAR保存下来，这样下次计算的时候读取一下，体系的性质就可以快速得到了。比如我生成WAVECAR的时候没有考虑要计算功函数，因为课题需要分析下，就可以读取WAVECAR来快速获取对应的LOCPOT文件： 该怎么操作呢： 

  

  - 把 `CONTCAR` 改名为 `POSCAR`；

  - 在 `INCAR` 中设置，其他文件如POTCAR， KPOINTS等跟WAVECAR生成时的计算保持一致，然后运行VASP即可。 
    ```
    ISTART = 1       # 从 WAVECAR 读取波函数
    NSW = 0          # 不进行结构更新，只跑电子收敛
    LVHAR = .TRUE.   # 计算功函数的参数
    ```

  - 类似的，你也可以添加其他的参数，通过WAVECAR来快速实现相应输出文件的获得。




## 3. 不想生成 WAVECAR？也可以控制！

默认情况下，VASP 会写出 WAVECAR。WAVECAR虽然很好用，可以帮助我们快速获取一些重要的信息。 但是这个针对一些难收敛或者复杂的体系效果明显，如果你的体系收敛很轻松，计算能力又强大，算个单点重现结果很快的时候，WAVECAR的作用就不是很明显了。相反，由于它占用的硬盘太大，导致存储吃紧，这时候我们就可以直接删掉或者避免写入WAVECAR 文件， 从而节省空间磁盘及 IO 时间。 只需要在INCAR中加入这个参数即可。

```text
LWAVE = .FALSE.
```



---

## 4. 快速总结

| 项目         | 内容说明 |
|--------------|----------|
| **文件类型** | 二进制文件，保存 Kohn–Sham 波函数和相关参数 |
| **作用**     | 可用于续算，重现结果，节省时间；保存最后波函数结果用于后续分析 |
| **启动计算** | 设置 `ISTART=1`, `ICHARG=1`, `NSW=0`，将 `CONTCAR` → `POSCAR` |
| **控制输出** | 添加 `LWAVE = .FALSE.` 可禁止生成 WAVECAR |

---



# 5  `WAVECAR` 的高级用处



前面我们提到的是WAVECAR在实际计算中的一些情况，我们说它接近计算的本源，当然，直接分析WAVECAR也可以给我们一些关于体系的描述。许多后处理工具可基于它进行物理性质计算、态可视化与能带处理等工作。以下是常用程序和功能汇总：



| 程序名称 / 项目链接                                          | 用途 / 功能            | 输出或分析性质                     | 说明                                                         |
| ------------------------------------------------------------ | ---------------------- | ---------------------------------- | ------------------------------------------------------------ |
| [Vasperry](https://github.com/linzhibo/Vasperry)             | 贝里曲率计算           | Berry curvature 分布、Chern 数     | 读取 WAVECAR，使用现代 Berry 相位公式计算晶体动量空间的贝里曲率 |
| [WaveTrans](https://www.andrew.cmu.edu/user/feenstra/wavetrans/) | 波函数传输分析         | STM / STS 波函数投影图像           | 读取 WAVECAR，导出横截面、投影波函数图像，用于表面态分析或扫描隧道显微图像模拟 |
| [VaspBandUnfolding](https://github.com/QijingZheng/VaspBandUnfolding) | 能带展开               | 超胞能带 → 原胞能带                | 从 WAVECAR 提取超胞波函数，并与原胞进行展开比较，展示能带与杂化特征 |
| [pymatgen.io.vasp.Wavecar](https://pymatgen.org/pymatgen.io.vasp.html) | 波函数读取与结构化接口 | 提取波函数属性、用于自定义分析     | 可配合 NumPy 等使用，读取/处理特定 k 点、能带、spin 分量的波函数信息 |
| [Vasptools-wfc](https://zhuanlan.zhihu.com/p/638907669)      | 波函数实空间可视化     | 波函数截面图 / 等值面图            | 提取指定能带/k 点的波函数并输出为 cube 格式，供 VESTA 可视化 |
| [VaspTools](https://github.com/henniggroup/VaspTools)        | 复杂波函数分析工具集   | 等值面、轨道投影                   | 包括对 VASP WAVECAR 文件的解析，可用于态密度重建和空间分布展示 |
| [Wannier90 (via VASP2WANNIER90)](http://www.wannier.org/)    | 构建 Wannier 函数      | 局域轨道、电子传输、Berry 相关物理 | 虽非直接用 WAVECAR，而是间接配合 WAVECAR 与 PROJCAR 提取波函数信息以拟合 MLWF |

> 注：有些工具可能还需配合 CHGCAR / KPOINTS / PROCAR 等文件共同使用。

