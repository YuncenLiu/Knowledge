# Service



我们已经清楚，pod 可以创建独立的 IP，但存在几个问题

1. Pod IP 仅仅集群内部可见的虚拟IP，外部无法访问
2. Pod IP 会随着 Pod 的销毁而消失，当 Deployment 对 Pod 进行动态伸缩时，Pod IP 可能随时随地变化，这样对于我们访问这个服务带来了难度
3. Service 能够提供负载均衡的能力，但是在使用上有以下限制，仅提供 4层负载均衡能力，没有 7 层功能，但有时我们可能需要更多的匹配规则来转发请求，这4层负载时不支持的

因此，k8s 中的 service 对象就是解决以上问题实现服务发现的核心关键



### Service 四种类型

+ ClusterIP，默认类型，自动分配一个仅 Cluster 内部可以访问的虚拟 IP
+ NodePort，在 ClusterIP 基础上为 Service 在每一台服务器上绑定一个端口，这样就可以通过 节点:NodePort 来访问改服务
+ LoadBalancer，在 NodePort 基础上，借助 cloud provider 创建一个外部负载均衡器，将请求转发到 NodePort，是付费服务，价格不菲
+ ExternalName：把集群外的服务引入到集群内，在集群内直接使用，没有任何类型代理被创建，只有 k8s 1.7 以上 kube-dns 才支持



