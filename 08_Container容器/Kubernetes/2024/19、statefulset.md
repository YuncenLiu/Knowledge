# statefulset

用 dolpoyment 管理的pod ，在 pod 重启后，集群 ID 是会变动的，使用 statefulset 解决

稳定、唯一网络标识、持久存储、有序部署和伸缩、有序删除和停止、有序自动滚动更新





## statefulset 和 deployment 区别

| 特性                                 | Deployment                                                   | StatefulSet                                                  |
| ------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 是否暴露到外网                       | 可以                                                         | 一般不                                                       |
| 请求面向的对象                       | serviceName                                                  | 指定pod的域名                                                |
| 灵活性                               | 只能通过service/serviceIp访问到k8s自动转发的pod              | 可以访问任意一个自定义的pod                                  |
| 易用性                               | 只需要关心Service的信息即可                                  | 需要知道要访问的pod启动的名称、headlessService名称           |
| PV/PVC绑定关系的稳定性（多replicas） | （pod挂掉后重启）无法保证初始的绑定关系                      | 可以保证                                                     |
| pod名称稳定性                        | 不稳定，因为是通过template创建，每次为了避免重复都会后缀一个随机数 | 稳定，每次都一样                                             |
| 启动顺序（多replicas）               | 随机启动，如果pod宕掉重启，会自动分配一个node重新启动        | pod按 app-0、app-1...app-（n-1），如果pod宕掉重启，还会在之前的node上重新启动 |
| 停止顺序（多replicas）               | 随机停止                                                     | 倒序停止                                                     |
| 集群内部服务发现                     | 只能通过service访问到随机的pod                               | 可以打通pod之间的通信（主要是被发现）                        |
| 性能开销                             | 无需维护pod与node、pod与PVC 等关系                           | 比deployment类型需要维护额外的关系信息                       |





k8s 部署分为两部分

1. Headless Service，其实和 service 差不多，是无头服务，不会帮你配置IP

> spec.clusterIP 必须设置为 None

2. StatefuleSet ，需要在 pod 中定义 servicename。spec.serviceName



