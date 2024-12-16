### 1、Activiti的表说明

使用25张表，ACT_开头

+ RE：资源表
+ RU：运行时 包括流程实例、任务、变量
+ HI：历史表
+ GE：通用数据表

### 2、Activiti的架构、类关系图

获取流程引擎的工具类：ProcessEngines 使用默认方式获取配置文件，构建流程引擎。配置文件名`activiti.cfg.xml`，放在 classpath 下。

ProcessEngineConfiguration 可以自定义配置文件名

使用上面两个工具类，都可以获得流程引擎

ProcessEngine：流程引擎。获取各种服务的接口，服务接口：用于流程的部署、管理、使用这些接口就是操作对应的表

+ RepositoryService：资源管理类
+ RuntimeService：运行时管理类
+ TaskSerice：任务管理类
+ HistoryService：历史数据管理类
+ ManagementService：流程引擎管理类

### 3、BPMN插件

IDEA安装 actiBPM 插件

### 4、流程符号、画流程图

流程符号：事件Event、活动Activity、网关Gateway，流向

使用流程设计器画出流程图，创建 bpmn 文件，在流程设计器内，使用流程符号来表达流程。指定流程Key，指定任务的负责人，生成PNG文件，BPMN文件本质是XML文件，因为安装了插件，才能看到图，但是在程序里给别人看，最好是生成一个PNG文件，才方便给别人看。

### 5、部署流程

使用Acitiviti提供的API把流程图的内容写入数据库中

属于资源类操作，使用 RepositoryService 

+ 单文件部署
+ 压缩包部署，把bpmn文件和png打压缩来处理

```java
        Deployment deploy = repositoryService.createDeployment()
                .name("出差申请流程")
                .addClasspathResource("bpmn/evection.bpmn20.png")
                .addClasspathResource("bpmn/evection.bpmn20.xml")
                .deploy();
```

> 部署操作表：
>
> + act_re_deployment
> + act_re_procdet
> + act_ge_bytearray

### 6、启动流程实例

核心代码

```java
runtimeService.startProcessInstanceByKey("submitBug");
    /**
     * 操作的表：
     * ACT_HI_TASKINST          历史的任务实例
     * ACT_HI_PROCINST          历史的流程实例
     * ACT_HI_ACTINST           历史的流程实例
     * ACT_HI_IDENTITYLINK      历史的流程运行过程中用户关系
     * ACT_RU_EXECUTION         运行时流程执行实例
     * ACT_RU_TASK              运行时任务
     * ACT_RU_IDENTITYLINK      运行时用户关系信息，存储任务节点与参与者的相关信息
     */
```

### 7、任务查询

使用 TaskService ，根据流程定义的key，人物的负责人来进行查询

核心代码

```java
        List<Task> list = taskService.createTaskQuery()
                .processDefinitionKey("submitBug")  // 流程key
                .taskAssignee("admin")           //  要查询的负责人
                .list();
```

### 8、任务完成

使用 TaskService ，用任务Id完成任务

核心代码

```java
taskService.complete("10005");
```



