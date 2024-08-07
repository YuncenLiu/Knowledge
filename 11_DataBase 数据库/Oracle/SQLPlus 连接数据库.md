> 2024-06-26 昆仑
> 从 10.5.3.149 服务器连接 10.5.3.102

1. **打开终端**：打开你的终端或命令行界面。
    
2. **使用 `sqlplus` 命令**：输入以下命令来启动 `sqlplus`：
    
    Copy Code
    
    `sqlplus username/password@//hostname:port/service_name`
    
    - `username`: 数据库用户名。
    - `password`: 数据库用户的密码。
    - `hostname`: 数据库服务器的主机名或 IP 地址。
    - `port`: 数据库监听的端口号（默认通常是 1521）。
    - `service_name`: Oracle 数据库的服务名或 SID（系统标识符）。
3. **示例**： 假设我们要连接到远程主机上的 Oracle 数据库，用户名为 `myuser`，密码为 `mypass`，数据库主机名为 `example.com`，端口为默认的 1521，服务名为 `orcl`，那么连接命令如下：
    
    Copy Code
    
    `sqlplus myuser/mypass@//example.com:1521/orcl`


案例

```sh
sqlplus fktest01/fktestabc@10.5.3.102:1521/fktestdb
```