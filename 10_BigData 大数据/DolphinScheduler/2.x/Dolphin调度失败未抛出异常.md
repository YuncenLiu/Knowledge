## 关于 DolphinScheduler 优化方案



#### 1、解决任务失败但调度未抛出情况

时间：2024-05-08

> 例如：执行Java脚本、Shell脚本后，脚本内部发生报错，工作流任务仅仅是运行任务，并不负责脚本内部情况，所以需要将错误抛出，反馈到工作流级，告知告警系统

例如在 [Web调度中](http://10.129.24.91:12345/dolphinscheduler/ui/projects/11804802041632/workflow-definition) 基于运行 Java 脚本调用远程请求时候，不做特殊处理，极易发生因网络、接口异常导致接口调用失败，而工作流不发生告警等情况

```shell
# 执行命令并将输出保存到变量中
output=$(java -jar  /home/dev/java_script/high_sell/tmp/send.jar  type=month env=test xiang=xiang)

# 提取"Response Code"的值
response_code=$(echo "$output" | grep "Response Code" | awk '{print $NF}')

echo $output
echo $response_code

# 检查Response Code的值是否为200，并输出相应的结果
if [ "$response_code" = "200" ]; then
    echo "程序正常执行！"
else
    exit 1  
    # 退出状态为失败 (1)
fi
```

通过 `exit 1 ` 标识 Shell 脚本的异常情况。