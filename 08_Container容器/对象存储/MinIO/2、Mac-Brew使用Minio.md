# Mac 使用 Brew 工具中的 Minio

> 2025-01-20

查看是否安装 minio

```sh
brew list

# 查看是否提示
minio
```

![image-20250120114241482](images/2%E3%80%81Mac-Brew%E4%BD%BF%E7%94%A8Minio/image-20250120114241482.png)





本地运行

1. 选择本地存储位置

	```
	/Users/xiang/xiang/data/minio
	```

2. 启动

	```sh
	minio server /Users/xiang/xiang/data/minio --console-address: 9000
	```

	