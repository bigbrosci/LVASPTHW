

### POTCAR 的生成以及脚本



首先声明以下几点：

**POTCAR** 是 VASP 计算的重要输入文件之一，不能缺；

**POTCAR** 的生成原理**很简单**；

**POTCAR** 的生成过程也**很Easy**，以用手动（参考上一节Ex2.5），Python 或者 Bash脚本。



#### 1. 生成前的准备工作：

1.1 从哪里写下载：为了生成计算的POTCAR文件，首先我们要从VASP官网<https://www.vasp.at/vasp-portal/>去下载元素周期表中不同元素的POTCAR文件。

1.2 解压：

```bash
(ase) qli@bigbro:~/sw/vasp_pot$ pwd
/home/qli/sw/vasp_pot
(ase) qli@bigbro:~/sw/vasp_pot$ mv /mnt/c/Users/bigbro/Desktop/potpaw_PBE.64.tgz  .
(ase) qli@bigbro:~/sw/vasp_pot$ tar -zxvf potpaw_PBE.64.tgz
(ase) qli@bigbro:~/sw/vasp_pot$ ls Ru*
Ru:
POTCAR  PSCTR

Ru_pv:
POTCAR  PSCTR

Ru_sv:
POTCAR  PSCTR

Ru_sv_GW:
POTCAR  PSCTR
```

1.3  敲一下 `ls` 命令，就可以看到所有的POTCAR文件了。

#### 2. POTCAR 准备的基本思路

2.1怎么选POTCAR，比如上面的Ru，有好几个，用哪个呢？这个参考上一章节的介绍；

2.2 选好之后，如果你的体系中只有一种元素，直接把文件夹中的POTCAR拿来用即可。

2.3 如果你的体系有好几种元素，那么就需要把这些POTCAR合并，拼接成一个新的POTCAR文件。

2.4 拼接后的POTCAR中包含了不同金属的原子的POTCAR，而且它们的顺序要和POSCAR中的顺序一致。



#### 3. POTCAR生成的步骤。

- 确定计算中涉及的元素类型以及如何选取（通常从 `POSCAR` 文件中读取）。

- 找到这些元素对应的赝势文件路径。比如前面1中大师兄把POTCAR解压到下面的目录。

  ```
  /home/bigbro/sw/vasp_pot
  ```

- 依次合并这些赝势文件，生成最终的 `POTCAR` 文件。依次合并的意思是按照POSCAR中元素顺序进行。

- Python的操作就是读写，Bash则是通过`cat` 命名进行。

------

#### 4.  读取 POSCAR 获取元素列表

`POSCAR` 文件包含了系统的晶格参数和原子信息。元素列表通常在文件的第 6 行，格式类似：

```
(base) qli@bigbro:~/test/example$ head -n 7 POSCAR |cat -n
     1  Ru  S  H
     2     1.00000000000000
     3      20.0000000000000000    0.0000000000000000    0.0000000000000000
     4       0.0000000000000000   20.0000000000000000    0.0000000000000000
     5       0.0000000000000000    0.0000000000000000   20.0000000000000000
     6     Ru   S    H
     7      64     1     2
```



下面是 Python 代码读取 `POSCAR` 中的元素列表：

```
def get_elements_from_poscar(poscar_file='POSCAR'):
    with open(poscar_file, 'r') as f:
        lines = f.readlines()
    elements = lines[5].strip().split()  # 第 6 行是元素列表
    return elements

# 测试代码
elements = get_elements_from_poscar('POSCAR')
print("元素列表:", elements)
```

**注意**：`lines[5]` 是第6行，因为Python 计数从 0 开始。

下面是 **Bash** 读取 `POSCAR` 中的元素列表的操作（sed， head + tail）：

```
(base) qli@bigbro:~/test/example$ sed -n 6p POSCAR
   Ru   S    H
(base) qli@bigbro:~/test/example$ head -n 6 POSCAR |tail -n 1
   Ru   S    H
```

**注意**：Bash 计数从1开始，这里就是第6行。



#### 5. Python 脚本生成 POTCAR

以下是一个简单的 Python 脚本，从 `POSCAR` 中获取元素列表，然后生成 `POTCAR`：

```
import os

def get_elements_from_poscar(poscar_file='POSCAR'):
    """从 POSCAR 文件中读取元素列表"""
    with open(poscar_file, 'r') as f:
        lines = f.readlines()
    elements = lines[5].strip().split()
    elements = ["Ru_pv" if element == "Ru" else element for element in elements] #注意
	return elements

def generate_potcar(elements, potcar_dir='/home/bigbro/sw/vasp_pot', output_file='POTCAR'):
    """根据元素列表生成 POTCAR 文件"""
    with open(output_file, 'w') as potcar:
        for element in elements:
            potcar_path = os.path.join(potcar_dir, element, 'POTCAR')
            if not os.path.exists(potcar_path):
                raise FileNotFoundError(f"{potcar_path} 不存在！")
            with open(potcar_path, 'r') as potcar_part:
                potcar.write(potcar_part.read())
    print(f"POTCAR 文件已生成: {output_file}")

# 执行流程
if __name__ == '__main__':
    poscar_file = 'POSCAR'
    potcar_dir = '/home/bigbro/sw/vasp_pot'  # 修改为赝势库路径
    output_file = 'POTCAR'

    elements = get_elements_from_poscar(poscar_file)
    print("读取到的元素:", elements)

    generate_potcar(elements, potcar_dir, output_file)
```

------

需要注意的是： 我们要用到VASP推荐的Ru_pv，但是读取POSCAR，得到的是Ru, 所以我们又加了一行，主动把Ru换成Ru_pv。

#### 6. Bash 脚本生成 POTCAR

对于更熟悉 Bash 的用户，可以使用以下脚本：

```bash
#!/bin/bash

# 定义路径
POSCAR="POSCAR"
POTCAR_DIR="/home/bigbro/sw/vasp_pot"  # 修改为赝势库路径
OUTPUT="POTCAR"

# 读取元素列表
ELEMENTS=$(sed -n '6p' $POSCAR)  # POSCAR 第 6 行是元素
ELEMENTS=$(echo $ELEMENTS | sed 's/\bRu\b/Ru_pv/g') # 注意！！

# 清空 POTCAR 文件
> $OUTPUT

# 生成 POTCAR
for ELEMENT in $ELEMENTS; do
    POTCAR_PATH="$POTCAR_DIR/$ELEMENT/POTCAR"
    if [[ ! -f $POTCAR_PATH ]]; then
        echo "错误: 找不到 $POTCAR_PATH"
        exit 1
    fi
    cat $POTCAR_PATH >> $OUTPUT
done

echo "POTCAR 文件生成成功: $OUTPUT"
```

注意的是：这里也加了一行，主动把Ru换成Ru_pv。



7 Python 和 bash 脚本 的使用。

```
(base) qli@bigbro:~/test/example$ python3 potcar.py
读取到的元素: ['Ru_pv', 'S', 'H']
POTCAR 文件已生成: POTCAR
(base) qli@bigbro:~/test/example$ grep TIT POTCAR
   TITEL  = PAW_PBE Ru_pv 28Jan2005
   TITEL  = PAW_PBE S 06Sep2000
   TITEL  = PAW_PBE H 15Jun2001
(base) qli@bigbro:~/test/example$ rm POTCAR
(base) qli@bigbro:~/test/example$ bash potcar.sh
读取到的元素: Ru_pv S H
POTCAR 文件已生成: POTCAR
(base) qli@bigbro:~/test/example$ grep TIT POTCAR
   TITEL  = PAW_PBE Ru_pv 28Jan2005
   TITEL  = PAW_PBE S 06Sep2000
   TITEL  = PAW_PBE H 15Jun2001
```



### 小结

1. 知道怎么下载POTCAR，解压。
2. 通过读取 `POSCAR` 获取模型中的元素列表。
3. 知道怎么选取POTCAR。
4. 根据元素列表找到对应赝势文件路径，并合并生成 `POTCAR`。
5. 使用 Python 或 Bash 脚本自动化整个流程，方便快捷。
6. 熟悉并学习`bash`中`cat`, `sed` , `head`, `tail`, `for` 循环，以及Python脚本的写法。
7. VASP 官方教程：<https://www.vasp.at/wiki/index.php/Preparing_a_POTCAR>
8. 脚本内容已经在文章里面了，自己复制粘贴写一个就能直接运行。出现问题可以找我要脚本(微信BigBroSci)，但是要收费20块钱。
