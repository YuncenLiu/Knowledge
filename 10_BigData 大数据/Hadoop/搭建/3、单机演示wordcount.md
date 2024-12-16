## 演示案例： wordcount

统计单词出现多少次

新建一个目录，存放些文本信息

```sh
[root@centos ~]# mkdir input
[root@centos ~]# cd input/
```



```sh
[root@centos input]# vi file1
```

写入下列信息

```
java python go luya shell 
windows mac linux
hadoop help hdfs mysql java jdk hadoop hdfs
```

循环写入1000次

```sh
[root@centos input]# for i in {1..1000}; do cat file1 >> file2; done
[root@centos input]# du -sh *
4.0K	file1
192K	file2
[root@centos input]# for i in {1..1000}; do cat file2 >> file3; done
[root@centos input]# du -sh *
4.0K	file1
192K	file2
128M	file3
[root@centos input]# for i in {1..10}; do cat file3 >> file4; done
[root@centos input]# du -sh *
4.0K	file1
88K	file2
85M	file3
981M	file4
```



现在我们要统计每个文件单词的次数

```
cd $HADOOP_HOME/share/hadoop/mapreduce
```

```sh
hadoop jar hadoop-mapreduce-examples-3.3.1.jar wordcount ~/input/ ~/output
```

注意 ~/output 必须要让hadoop 自己创建，如果指定已有文件夹会报错

```sh
[root@centos output]# ls
part-r-00000  _SUCCESS
[root@centos output]# cat part-r-00000 
go	11001001
hadoop	22002002
hdfs	22002002
help	11001001
java	22002002
jdk	11001001
linux	11001001
luya	11001001
mac	11001001
mysql	11001001
python	11001001
shell	11001001
windows	11001001
```

_SUCCESS 只是标记成功



## 演示案例：pi

```sh
cd $HADOOP_HOME/share/hadoop/mapreduce
```

```sh
[root@centos mapreduce]# hadoop jar hadoop-mapreduce-examples-3.3.1.jar pi 10 10
....
		Bytes Written=109
Job Finished in 1.607 seconds
Estimated value of Pi is 3.20000000000000000000
```

计算不够精确