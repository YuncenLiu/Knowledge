# Prometheus

Git 官网：https://github.com/prometheus/prometheus

官方文档：https://prometheus.io/docs/introduction/overview/

网友笔记：https://blog.csdn.net/hancoder/article/details/121703904



下载地址

```sh
https://github.com/prometheus/prometheus/releases/download/v2.29.2/prometheus-2.29.2.linux-amd64.tar.gz
https://github.com/prometheus/pushgateway/releases/download/v1.4.1/pushgateway-1.4.1.linux-amd64.tar.gz
https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
https://github.com/prometheus/alertmanager/releases/download/v0.23.0/alertmanager-0.23.0.linux-amd64.tar.gz
```



解压安装

```sh
tar -zxvf prometheus-2.29.2.linux-amd64.tar.gz -C /home/xiang/soft/
tar -zxvf pushgateway-1.4.1.linux-amd64.tar.gz -C /home/xiang/soft/
tar -zxvf alertmanager-0.23.0.linux-amd64.tar.gz -C /home/xiang/soft/
tar -zxvf node_exporter-1.2.2.linux-amd64.tar.gz -C /home/xiang/soft/
```

```sh
[xiang@hadoop03 soft]$ pwd
/home/xiang/soft
[xiang@hadoop03 soft]$ ll
总用量 0
drwxr-xr-x 2 xiang xiang  93 8月  25 2021 alertmanager-0.23.0
drwxr-xr-x 2 xiang xiang  56 8月   6 2021 node_exporter-1.2.2
drwxr-xr-x 4 xiang xiang 132 8月  27 2021 prometheus-2.29.2
drwxr-xr-x 2 xiang xiang  54 5月  28 2021 pushgateway-1.4.1
```



## 启动Prometheus

`vim /home/xiang/soft/prometheus-2.29.2/prometheus.yml`

```yaml
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
alerting:
  alertmanagers:
    - static_configs:
        - targets:
rule_files:
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["hadoop03:9090"]
  - job_name: "pushgateway"
    static_configs:
      - targets: ["hadoop03:9091"]
        labels:
          instance: pushgateway
  - job_name: 'node exporter'
    static_configs:
      - targets: ['hadoop01:9100', 'hadoop02:9100', 'hadoop03:9100']
```

启动

```sh
# 在 Prometheus Server 目录下执行启动命令 # 后台运行 输出log
nohup ./prometheus --config.file=prometheus.yml > ./prometheus.log 2>&1 &

# 在 Pushgateway 目录下执行启动命令
nohup ./pushgateway --web.listen-address :9091 > ./pushgateway.log 2>&1 &

# 在 Alertmanager 目录下启动
nohup ./alertmanager --config.file=alertmanager.yml > ./alertmanager.log 2>&1 &
```

访问 Prometheus

```sh
http://hadoop03:9090/service-discovery
```

![image-20230921173535563](images/1%E3%80%81Prometheus%20%E5%AE%89%E8%A3%85/image-20230921173535563.png)





## 启动Node_exporter

将 `node_exporter-1.2.2` 分发到 Hadoop01、Hadoop02 其他需要监控到服务节点上

因为我们添加过如上配置

```yaml
  - job_name: 'node exporter'
    static_configs:
      - targets: ['hadoop01:9100', 'hadoop02:9100', 'hadoop03:9100']
```

设置 NodeExporter 开机自启

```sh
# 创建service 文件
[xiang@hadoop03 ~] sudo vim /usr/lib/systemd/system/node_exporter.service
[Unit]
Description=node_export
Documentation=https://github.com/prometheus/node_exporter
After=network.target
[Service]
Type=simple
User=xiang
ExecStart= /home/xiang/soft/node_exporter-1.2.2/node_exporter
Restart=on-failure
[Install]
WantedBy=multi-user.target
```

分发到其他服务器

```sh
sudo scp /usr/lib/systemd/system/node_exporter.service hadoop02:/usr/lib/systemd/system/node_exporter.service
```

查看状态、自启 （所有节点都执行）

```sh
# 查看状态
systemctl status node_exporter.service
# 启动
sudo systemctl start node_exporter.service
# 停止
sudo systemctl stop node_exporter.service
# 开机自启 （所有节点都执行）
sudo systemctl enable node_exporter.service
```

查看是否启动

```sh
[xiang@hadoop01 node_exporter-1.2.2]$ lsof -i:9100
COMMAND    PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
node_expo 3750 xiang    3u  IPv6  37875      0t0  TCP *:jetdirect (LISTEN)
```



