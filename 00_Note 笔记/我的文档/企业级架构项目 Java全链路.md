> 2024 - 07 -25
>
> [BiliBili 谷粒学院](https://www.bilibili.com/video/BV1np4y1C7Yf)

项目为前后分离开发，分为内、外网部署

外网为公共用户访问，例如手机移动端、电脑等，内网为服务的整个集群

公众用户通过使用移动端来访问服务，请求不是直接访问到服务，完整链路如下

1. 用户使用任意客户端，访问Nginx集群，其中会经过防火墙、CDN、WAF等。
2. Nginx接收到请求之后，也并不是直接请求到对应服务，而是使用了 SpringCloud Gateway 网关，动态路由到对应服务，例如：鉴权、业务服务等。
3. 当某一业务服务拥有众多集群时，可以实现 负载均衡、熔断降级等场景，不仅如此，还拥有认证鉴权、令牌限流等解决方案。
4. 服务与服务之间调用，使用 Feign 组件，集成了 OAuth2.0 认证中心，实现第三方认证授权，整个安全中心由 SpringSecurity 实现。
5. 服务内缓存使用 Redis 分片+哨兵集群，数据持久化使用了 MHA高可用MySQL集群。
6. 服务之间使用 RabbitMQ 消息队列异步解耦。通过 ElasticSearch 实现全文索引。
7. 文件对象存储使用了多种存储工具，不仅限于 阿里云、腾讯云、七牛、minio等
8. 系统中涉及定时任务、调度相关，使用 XXL-JOB 和 DolphinScheduler 等调度工具完成。
9. 服务上线后，便于快速定位项目问题，使用ELK对日志进行分析，LogStash 收集主要服务日志，存储到 ES 中，在 Kibana 中可视化检索。
10. 便于服务管理，使用了常规的 Nacos 服务注册中心、服务配置中心。（动态发现、动态配置）
11. 服务调用期间，使用Sleuth、Zipkin、Metrice服务链路追踪，将采集信息交由 Prometheus，同时自身也支持监控服务器状态CPU、内存、IO等信息，通过 Grafana 可视化监控，和 Altermanager 实现告警。邮件、短信、钉钉信息。
12. 整个系统提供 CI/CD ，开发人员将修改内容提交到私人的 gitlab 代码版本管理工具
13. 运维工作使用 Jenkins，拉取变更代码，通过 Neuxs 提供的 Maven 仓库管理器，最终构建成可运行服务。
14. 通过 Docker component 构建成 Docker 镜像，最终使用 Kubernaters 集成整个 Docker 服务。
15. 最终以 Docker 服务的方式运行。



![image-20240725233712667](images/企业级架构项目%20Java全链路/image-20240725233712667.png)