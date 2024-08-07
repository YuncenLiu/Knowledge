> 创建于2022年2月4日
> 作者：想想

[toc]



### 一、流程定义部署

1、使用流程设计器，使用流程符号，画出流程图，bpmn、png 图都是流程资源文件，用来描述流程，流程中需要的节点，节点的负责人、

2、把流程的资源文件，进行部署，上传到数据库中，使用java代码来进行流程部署，一次部署操作 ACT_RE_DEPORYMENT 会生成一条记录，ACT_RE_PROCDEF 会生成流程定义信息

3、deployment 和 procdef表一对多关系，在procdef表中可以有多条记录，每条记录对应一个流程的定义信息

创建Activiti所有的表

```java
    /**
     * 使用 activiti 提供的默认方式来创建 mysql 表
     */
    @Test
    public void testCreateTable(){
        // 需要使用 activiti 提供的工具类 ProcessEnginess，使用方法 getDefaultProcessEngine
        // getDefaultProcessEngine 会默认从 resources 下读取 activiti.cfg.xml 的文件
        // 创建 processEngine 时，就会创建 mysql 表

// 默认方式创建
//        ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
//        RepositoryService repositoryService = processEngine.getRepositoryService();
//        repositoryService.createDeployment();

        // 使用自定义方式
        // 配置文件名字可以自定义
        ProcessEngineConfiguration processEngineConfiguration = ProcessEngineConfiguration
                .createProcessEngineConfigurationFromResource("activiti.cfg.xml",
                        "processEngineConfiguration");
        // 获取流程引擎对象
        ProcessEngine processEngine = processEngineConfiguration.buildProcessEngine();
//        RepositoryService repositoryService = processEngine.getRepositoryService();
//        repositoryService.createDeployment();



    }

```



### 二、启动流程实例

对已经部署的流程进行启动，key可以从 ACT_RE_PROCDEF 字段 KEY_ 中查到

```java
    @Test
    public void testStartProcess(){
        // 1、创建 ProcessEngine
        ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
        // 2、获取 RuntimeService
        RuntimeService runtimeService = processEngine.getRuntimeService();
        // 3、根据流程定义的id来启动流程
        ProcessInstance instance = runtimeService.startProcessInstanceByKey("submitBug");
        // 4、输出内容
        System.out.println("流程定义ID："+instance.getProcessDefinitionId());
        System.out.println("流程实例ID："+instance.getId());
        System.out.println("当前活动ID："+instance.getActivityId());
    }
```

操作的表：

+ ACT_HI_TASKINST          历史的任务实例
+ ACT_HI_PROCINST          历史的流程实例
+ ACT_HI_ACTINST           历史的流程实例
+ ACT_HI_IDENTITYLINK      历史的流程运行过程中用户关系
+ ACT_RU_EXECUTION         运行时流程执行实例
+ ACT_RU_TASK              运行时任务
+ ACT_RU_IDENTITYLINK      运行时用户关系信息，存储任务节点与参与者的相关信息



### 三、查询个人待执行的任务

```java
 @Test
    public void testFindPersonalTaskList(){
        // 1、获取流程引擎
        ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
        // 2、获取 TaskService
        TaskService taskService = processEngine.getTaskService();
        // 3、根据流程key 和 任务的负责人 查询任务
        List<Task> list = taskService.createTaskQuery()
                .processDefinitionKey("submitBug")  // 流程key
                .taskAssignee("zhangsan")           //  要查询的负责人
                .list();
        // 4、输出
        for (Task task : list) {
            System.out.println("task.getProcessInstanceId() = " + task.getProcessInstanceId());
            System.out.println("task.getId() = " + task.getId());
            System.out.println("task.getAssignee() = " + task.getAssignee());
            System.out.println("task.getName() = " + task.getName());
        }
        
    }
```

操作和查询的表

```sql
-- 查询个人相关
select * from ACT_GE_PROPERTY

select * from ACT_GE_PROPERTY where name_ = 'cfg.execution-related-entities-count'

-- 对流程和负责人进行查询		ACT_RU_TASK 为当前正在运行的任务 ACT_RE_PROCDEF 流程实例表 
-- getProcessInstanceId 为 PROC_DEF_ID_
-- getId 为 ID_
-- getAssignee 为 ASSIGNEE_
-- getName 为 NAME_
SELECT DISTINCT
	RES.* 
FROM
	ACT_RU_TASK RES
	INNER JOIN ACT_RE_PROCDEF D ON RES.PROC_DEF_ID_ = D.ID_ 
WHERE
	RES.ASSIGNEE_ = 'zhangsan'
	AND D.KEY_ = 'submitBug'
ORDER BY
	RES.ID_ ASC 
```

### 四、完成个人任务

```java
@Test
public void completTask(){
    // 1、获取流程引擎
    ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
    // 2、获取 Service
    TaskService taskService = processEngine.getTaskService();
    // 3、根据任务id完成任务
    taskService.complete("10005");
}
```

操作的表

```sql
-- 执行任务进入下一个环节 参数为 ID_ 10005
UPDATE ACT_GE_PROPERTY  -- 系统相关属性
insert ACT_HI_TASKINST  -- 历史的任务实例
insert ACT_HI_ACTINST 	-- 历史的流程实例
insert ACT_HI_IDENTITYLINK 	-- 历史的流程运行过程中用户关系
insert ACT_RU_TASK			-- 运行时任务

update ACT_HI_TASKINST		-- 更新了结束时间 id = 10005
update ACT_HI_ACTINST			
update ACT_RU_EXECUTION		-- 运行时流程执行实例 id = 10002 rev = 1 
-- 删除  运行时任务 
 delete from ACT_RU_TASK where ID_ = '10005' and REV_ = '1'
```

### 五、压缩包形式部署

```java
@Test
    public void deployProcessByZio(){
        // 1、获取流程引擎
        ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
        // 2、获取 Services
        RepositoryService repositoryService = processEngine.getRepositoryService();
        // 3、部署流程
        // 3.1、读取资源包文件，构造 InputStream
        InputStream inputStream = this.getClass().getClassLoader()
                .getResourceAsStream("bpmn/submitBug.zip");
        // 3.2、用 inputStream 构造 ZipInputStream
        ZipInputStream zipInputStream = new ZipInputStream(Objects.requireNonNull(inputStream));
        // 3.3、使用压缩包的流进行部署
        Deployment deploy = repositoryService.createDeployment()
                .addZipInputStream(zipInputStream)
                .deploy();
        System.out.println("deploy.getId() = " + deploy.getId());
        System.out.println("deploy.getName() = " + deploy.getName());
    }
```

