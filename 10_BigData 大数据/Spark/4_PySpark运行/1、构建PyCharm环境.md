## 构建 PyCharm 运行环境

新建一个 PyCharm 项目，其实本地环境有没有都无所谓，只要能 SSH 远程连接到服务器，就可以使用服务器中的 Python 环境

目前我们使用 xiang@Hadoop01之前使用 Conda 构建的 `~/soft/anaconda3/envs/pyspark/bin/python` 环境。

![image-20231013150024205](images/1%E3%80%81%E6%9E%84%E5%BB%BAPyCharm%E7%8E%AF%E5%A2%83/image-20231013150024205.png)

默认使用 PyCharm 自动生成的文件路径，这个路径会在环境连接成功后，将本地脚本时时上传到 服务器中，即使在运行时，也是以 `ssh://xiang@hadoop01:22/...` 的方式运行

![image-20231013150245693](images/1%E3%80%81%E6%9E%84%E5%BB%BAPyCharm%E7%8E%AF%E5%A2%83/image-20231013150245693.png)

在创建好连接后，查看远程服务器中的模块版本信息

![image-20231013150401097](images/1%E3%80%81%E6%9E%84%E5%BB%BAPyCharm%E7%8E%AF%E5%A2%83/image-20231013150401097.png)

我们可以发现有 pyspark 环境

![image-20231013150428569](images/1%E3%80%81%E6%9E%84%E5%BB%BAPyCharm%E7%8E%AF%E5%A2%83/image-20231013150428569.png)

就可以开始写代码了，写好的代码也可以从下面的菜单中查看到时时上传到服务器的日志

![image-20231013150508053](images/1%E3%80%81%E6%9E%84%E5%BB%BAPyCharm%E7%8E%AF%E5%A2%83/image-20231013150508053-7180708.png)

如果不自动更新，我们也可以手动上传

![image-20231013150548099](images/1%E3%80%81%E6%9E%84%E5%BB%BAPyCharm%E7%8E%AF%E5%A2%83/image-20231013150548099.png)

最后点击运行，我们可以到控制台打印

```sh
ssh://xiang@hadoop01:22/home/xiang/soft/anaconda3/envs/pyspark/bin/python -u /tmp/pycharm_project_251/00_example/HelloWorld.py
```

![image-20231013150634037](images/1%E3%80%81%E6%9E%84%E5%BB%BAPyCharm%E7%8E%AF%E5%A2%83/image-20231013150634037.png)

表示计算成功！



## Client 方式提交

我们既已知道开发的脚本位置在 `/tmp/pycharm_project_251/00_example/HelloWorld.py `

就可以在服务器中执行

```sh
$SPARK_HOME/bin/spark-submit /tmp/pycharm_project_251/00_example/HelloWorld.py
```

![image-20231013150809312](images/1%E3%80%81%E6%9E%84%E5%BB%BAPyCharm%E7%8E%AF%E5%A2%83/image-20231013150809312.png)

也可以以 Spark On Yarn 形式执行

```sh
bin/spark-submit --master /tmp/pycharm_project_251/00_example/HelloWorld.py
```

