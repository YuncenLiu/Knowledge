```sequence
Title: 自定义路由表

Note left of Gateway 网关服务 : 系统启动，初始化路由表

Gateway 网关服务->MySQL 数据库: 读取持久化数据
MySQL 数据库 -> Gateway 网关服务: 获取持久化路由信息加载到路由表

Note right of System 系统服务 : 对路由表新增、修改操作
System 系统服务 -> Gateway 网关服务: 新增、修改路由信息
Gateway 网关服务 --> System 系统服务: 返回新增、修改的路由信息(响应)
System 系统服务 -> MySQL 数据库: 持久化新增、修改路由信息

Note right of System 系统服务 : 对路由表删除操作
System 系统服务 -> MySQL 数据库: 删除1条路由配置
System 系统服务 -> Gateway 网关服务: 通知网关服务初始化路由表
Gateway 网关服务->MySQL 数据库: 读取持久化数据
MySQL 数据库 -> Gateway 网关服务: 获取持久化路由信息加载到路由表

Note right of System 系统服务 : 查询路由表
System 系统服务 -> MySQL 数据库: 查询持久化路由信息
MySQL 数据库 -> System 系统服务: 返回持久的路由信息（响应）

Note right of System 系统服务 : 刷新路由表
System 系统服务 -> Gateway 网关服务: 通知网关服务初始化路由表
Gateway 网关服务->MySQL 数据库: 读取持久化数据
MySQL 数据库 -> Gateway 网关服务: 获取持久化路由信息加载到路由表

Note right of System 系统服务 : 校验路由表
System 系统服务 -> Gateway 网关服务: 查询路由表信息
Gateway 网关服务->System 系统服务: 返回所有路由信息（响应）

System 系统服务 -> MySQL 数据库: 查询所有持久化数据
MySQL 数据库 -> System 系统服务: 返回持久化路由表便于对比
Note left of System 系统服务 : 路由表与持久化表进行对比
Note left of System 系统服务 : 将不一致的路由信息，在持久化表中标识出来 status=2

System 系统服务 -> MySQL 数据库: update不一致的路由信息，status=2


```

