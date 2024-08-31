Conda 常用命令：https://blog.csdn.net/ungoing/article/details/125145279

### 查看当前已有的Conda环境

```python
conda info --env
conda info -e
conda env list

# 创建虚拟环境 pyspark, 基于Python 3.8
conda create -n pyspark python=3.8

# 切换到虚拟环境内
conda activate pyspark

# 使用PyPI安装PySpark如下：也可以指定版本安装
pip install pyspark

# 或者指定清华镜像(对于网络较差的情况)：
pip install pyhive pyspark jieba -i https://pypi.tuna.tsinghua.edu.cn/simple 

# 开启 bash
conda config --set auto_activate_base true

# 隐藏 bash
conda config --set auto_activate_base false
```