#Linux扩容 #VMware扩容 #虚拟机扩容

> 1. https://blog.csdn.net/qq_44297579/article/details/107318096

1. 在 vmware 里面设置虚拟机大小
2. 重启服务器之前，删除所有快照（提示这样）
3. 查看当前可用 `df -h`


查看现在最大分区 `ls | grep sda`

![](./images/Pasted%20image%2020240630231207.png)

最大为 sda3，所以新添加的应该是 sda4

管理 sda 磁盘，输入 fdisk /dev/sda

1. m 提示
2. n 添加分区
3. p 创建主分区
4. w 保存

输入顺序：`m > n > p > 回车 > 回车 > w`
详细看如下日志：

```sh
[root@centos dev]# fdisk /dev/sda
欢迎使用 fdisk (util-linux 2.23.2)。

更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。


命令(输入 m 获取帮助)：m
命令操作
   a   toggle a bootable flag
   b   edit bsd disklabel
   c   toggle the dos compatibility flag
   d   delete a partition
   g   create a new empty GPT partition table
   G   create an IRIX (SGI) partition table
   l   list known partition types
   m   print this menu
   n   add a new partition
   o   create a new empty DOS partition table
   p   print the partition table
   q   quit without saving changes
   s   create a new empty Sun disklabel
   t   change a partition's system id
   u   change display/entry units
   v   verify the partition table
   w   write table to disk and exit
   x   extra functionality (experts only)

命令(输入 m 获取帮助)：n
Partition type:
   p   primary (2 primary, 0 extended, 2 free)
   e   extended
Select (default p): p
分区号 (3,4，默认 3)：
起始 扇区 (41943040-104857599，默认为 41943040)：
将使用默认值 41943040
Last 扇区, +扇区 or +size{K,M,G} (41943040-104857599，默认为 104857599)：
将使用默认值 104857599
分区 3 已设置为 Linux 类型，大小设为 30 GiB

命令(输入 m 获取帮助)：w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 16: 设备或资源忙.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
正在同步磁盘。
```

**重启 `reboot`**  必须重启，否则无法格式化分区 sda3

重启后，此时，就有 /dev/sda3 文件了， 执行 

```sh
mkfs.ext4 /dev/sda3
```

```sh
mkfs.ext4 /dev/sda3
mke2fs 1.42.9 (28-Dec-2013)
文件系统标签=
OS type: Linux
块大小=4096 (log=2)
分块大小=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
1966080 inodes, 7864320 blocks
393216 blocks (5.00%) reserved for the super user
第一个数据块=0
Maximum filesystem blocks=2155872256
240 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000

Allocating group tables: 完成                            
正在写入inode表: 完成                            
Creating journal (32768 blocks): 完成
Writing superblocks and filesystem accounting information: 完成   

```

使用 lvm 工具 , 执行 `lvm` 进入

```sh
# 这里是 lvm 里面，嵌满的 lvm>


# 这是初始化刚才的分区4
lvm>pvcreate /dev/sda3 

# 将初始化过的分区加入到虚拟卷组centos (卷和卷组的命令可以通过 vgdisplay )
vgextend centos /dev/sda3

# 查看free PE /Site
vgdisplay -v
```

这里查看 `free PE /Site` 很重要

![](./images/Pasted%20image%2020240630232527.png)

这里的 `6400` 就是可新增的内容

```sh

# 扩展已有卷的容量（6400 是通过vgdisplay查看free PE /Site的大小）
lvextend -l+6400 /dev/mapper/centos-root

# 退出
quit
```

以上只是卷扩容，文件系统并没有真正扩容

**centos7**执行  
`xfs_growfs /dev/mapper/centos-root`  
**centos6**执行  
`resize2fs /dev/mapper/centos-root`

然后再 `df -h` 查看，显示扩容成功！