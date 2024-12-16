## Prometheus 集成 Flink

前提是有 Flink

```sh
cp /usr/local/flink/plugins/metrics-prometheus/flink-metrics-prometheus-1.13.0.jar /usr/local/flink/lib/
```

修改 Flink 的 conf 目录，修改 flink-conf.yaml 添加如下配置

```yaml
##### 与 Prometheus 集成配置 #####
metrics.reporter.promgateway.class: org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter
# PushGateway 的主机名与端口号
metrics.reporter.promgateway.host: hadoop03
metrics.reporter.promgateway.port: 9091
# Flink metric 在前端展示的标签（前缀）与随机后缀
metrics.reporter.promgateway.jobName: flink-metrics-ppg
metrics.reporter.promgateway.randomJobNameSuffix: true
metrics.reporter.promgateway.deleteOnShutdown: false
metrics.reporter.promgateway.interval: 30 SECONDS
```

注意：PushGateway 是 Prometheus 组件中的 Pushgateway组件位置，我安装在 hadoop03 节点上

