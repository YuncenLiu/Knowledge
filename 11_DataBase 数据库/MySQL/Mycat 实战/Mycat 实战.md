

MyCat 官网：[http://www.mycat.org.cn/](http://www.mycat.org.cn/)

> 提示：需要拥有JDK环境

下载 Mycat-server 工具包、解压、进入 bin 目录，启动 start 、停止 stop 、 重启 restart、查看状态 status

访问  `mysql -uroot -proot -h127.0.0.1 -p8066` 



安装就可简单了，主要是配置

## 系统配置 server.xml

### 登录用户

```xml
	<user name="root" defaultAccount="true">
		<property name="password">root</property>
		<property name="schemas">xiang</property>
		<property name="defaultSchema">xiang</property>
	</user>
	<user name="test">
		<property name="password">test</property>
		<property name="schemas">xiang</property>
		<property name="readOnly">true</property>
		<property name="defaultSchema">xiang</property>
	</user>
```

设置了两个账户登录 mycat，逻辑库和 mycat库都是 `xiang` 。`root` 用户可读可写、`test` 用户只能读不能写

### 自增序列

```xml
<property name="sequenceHandlerType">0</property>
```

+ 0 记录到本地文件
+ 1 数据库方式生成
+ 2 本地时间戳
+ ZK + 本地配置分布式生成
+ ZK 自增

## 逻辑表、分片 schema.xml

### 配置分片表

```xml
	<schema name="xiang" checkSQLschema="true" sqlMaxLimit="100" randomDataNode="dn1">
		<table name="position" primaryKey="id" dataNode="dn1,dn2" rule="mod-long" autoIncrement="true"></table>
	</schema>
```

分片表库：`xiang`、分片表：`postion`、主键 `id`、节点：`dn1、dn2`

### 配置节点

```xml
	<dataNode name="dn1" dataHost="localhost1" database="xiang1" />
	<dataNode name="dn2" dataHost="localhost1" database="xiang2" />
```

节点：`dn1、dn2` 对应真实数据库 `xiang1、xiang2`

### 配置主机

```xml
	<dataHost name="localhost1" maxCon="1000" minCon="10" balance="0"
			  writeType="0" dbType="mysql" dbDriver="jdbc" switchType="1"  slaveThreshold="100">
		<heartbeat>select user()</heartbeat>
		<!-- hostM1 就是别名 -->
		<writeHost host="hostM1" url="jdbc:mysql://localhost:3388" user="root"
				   password="123456">
		</writeHost>
	</dataHost>
```

`writeHost` 真正连接数据库参数、`heartbeat` 检测数据库心跳的sql

## 规则配置 rule.xml

```xml
	<tableRule name="mod-long">
		<rule>
			<columns>id</columns>
			<algorithm>mod-long</algorithm>
		</rule>
	</tableRule>

	<function name="mod-long" class="io.mycat.route.function.PartitionByMod">
		<property name="count">2</property>
	</function>
```

因为只有2个节点，步长为2。`mod-long` 名称对应 schema.xml 中的 schema 标签 `rule="mod-long"` 对应