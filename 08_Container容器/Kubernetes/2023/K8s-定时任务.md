[toc]

#### 使用kubectl创建CronJob

CronJob的配置参数如下所示：

- .spec.schedule指定任务运行时间与周期，参数格式请参见[Cron](https://en.wikipedia.org/wiki/Cron)，例如“0 * * * * ”或“@hourly”。
- .spec.jobTemplate指定需要运行的任务，格式与[使用kubectl创建Job](https://support.huaweicloud.com/intl/zh-cn/usermanual-cce/cce_01_0150.html#cce_01_0150__section450152719412)相同。
- .spec.startingDeadlineSeconds指定任务开始的截止期限。
- .spec.concurrencyPolicy指定任务的并发策略，支持Allow、Forbid和Replace三个选项。
  - Allow（默认）：允许并发运行 Job。
  - Forbid：禁止并发运行，如果前一个还没有完成，则直接跳过下一个。
  - Replace：取消当前正在运行的Job，用一个新的来替换。

下面是一个CronJob的示例，保存在cronjob.yaml文件中。

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```



**运行该任务，如下：**

1. 创建CronJob。

   

   **kubectl create -f cronjob.yaml**

   命令行终端显示如下信息：

   ```
   cronjob.batch/hello created
   ```

   

   

2. 执行如下命令，查看执行情况。

   

   **kubectl get cronjob**

   ```
   NAME      SCHEDULE      SUSPEND   ACTIVE    LAST SCHEDULE   AGE
   hello     */1 * * * *   False     0         <none>          9s
   ```

   

   **kubectl get jobs**

   ```
   NAME               COMPLETIONS   DURATION   AGE
   hello-1597387980   1/1           27s        45s
   ```

   

   **kubectl get pod**

   ```
   NAME                           READY     STATUS      RESTARTS   AGE
   hello-1597387980-tjv8f         0/1       Completed   0          114s
   hello-1597388040-lckg9         0/1       Completed   0          39s
   ```

   

   **kubectl logs** **hello-1597387980-tjv8f**

   ```
   Fri Aug 14 06:56:31 UTC 2020
   Hello from the Kubernetes cluster
   ```

   

   **kubectl delete cronjob hello**

   ```
   cronjob.batch "hello" deleted
   ```

   

   **![img](images/K8s-定时任务/support-doc-new-notice.svg)须知：**

   删除CronJob时，对应的普通任务及相关的Pod都会被删除。