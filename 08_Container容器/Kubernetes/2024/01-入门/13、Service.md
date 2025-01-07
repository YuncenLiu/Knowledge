# Service

[toc]

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



### 代理模式

#### Userspace 代理模式

效率差，Client Pod 访问 Server Pod，需要将请求先发给内核空间 service 规则，在转发监听指定套接字 kube-proxy，处理完成后，再转发指定 server pod，将请求递交给内核

当客户端连接 VIP，iptables 规则开始起作用，会重定向到 service 代理端口，选择一个合适的 backend，将客户端流量代理到 backend 上



#### iptables 代理模式

当流量到 node 端口上，客户端 ip 是可以更改的



#### IPVS 代理模式

kube-proxy负载为 service 实现了一种 VIP（虚拟IP）形式，而不是 ExternalName



#### Type类型

+ ClusterIP：意味着一个服务只能在集群内部访问，通过集群IP。

	Port : 8080:30574/TCP

+ ExternalName：意味着一个服务只包含一个对kubedns或类似的东西将作为CNAME记录返回的外部名称，带有不暴露或代理任何涉及的舱。

+ LoadBalancer：意味着服务将通过外部负载暴露均衡器（如果云提供商支持），以及` NodePort `类型。

+ NodePort：意味着服务将暴露在每个节点的一个端口上，除了` ClusterIP `类型。

	Port : 8080/TCP



### Ingress 网络

ingress 由两部分组成，ingress controller 和 ingress 服务，其中主要分成两种，基于 Nginx 服务的 ingress controller 和基于 traefik 的 ingress controller

traefik 支持 http、https；nginx 需要 TCP 负载



官网地址：

+ Ingress-Nginx github地址： https://github.com/kubernetes/ingress-nginx 资料比较全 
+ Ingress-Nginx 官网：https://kubernetes.github.io/ingress-nginx/ 案例全
