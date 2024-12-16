### Flume采集sftp服务器目录

> https://www.modb.pro/db/130344

+ [commons-net-3.3.jar](https://repo1.maven.org/maven2/commons-net/commons-net/3.3/commons-net-3.3.jar)
+ [ jsch-0.1.54.jar](https://repo.maven.apache.org/maven2/com/jcraft/jsch/0.1.54/jsch-0.1.54.jar) 



```properties
agent.sources = sftp-source
agent.sinks = k1
agent.channels = ch

agent.sources.sftp-source.type =org.keedio.flume.source.ftp.source.Source
agent.sources.sftp-source.client.source =sftp
agent.sources.sftp-source.name.server =hadoop01
agent.sources.sftp-source.user = sftp_dev
agent.sources.sftp-source.password =sftp_dev
agent.sources.sftp-source.port = 22
#sftp服务器需要采集的目录
agent.sources.sftp-source.working.directory= /home/sftp_dev
 
agent.sources.sftp-source.strictHostKeyChecking= no
agent.sources.sftp-source.knownHosts =~/.ssh/known_hosts


agent.sinks.k1.type =logger

agent.channels.ch.type = memory
agent.channels.ch.capacity = 10000
agent.channels.ch.transactionCapacity =10000
agent.channels.hbaseC.keep-alive = 20

agent.sources.sftp-source.channels = ch
agent.sinks.k1.channel = ch
```

