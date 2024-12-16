
> [!NOTE]
> 当前版本：V1.0   、创建时间：2024-07-08



### 主要功能

1. 满足根据文件名自动创建日志
2. 所有输出日志携带时间标识
3. 判定HQL执行成功、失败
	1. 执行成功 -> 不打印详细日志
	2. 执行失败 -> 自定义重试次数 、自定义重试时间 -> 中间任意重试成功，返回成功，否则返回失败
4. 最终返回 成功状态码、失败状态码，便于后续脚本的执行

### 测试案例


测试案例一：第一次立即成功 [dolphin测试环境](http://dolphinscheduler_dev.com/dolphinscheduler/ui/projects/11741875462240/workflow/instances/8363?code=14204722747616)

![第一次立即成功](images/Pasted%20image%2020240708103510.png)



测试案例二：第一次失败后，后续再成功：[dolphin测试环境](http://dolphinscheduler_dev.com/dolphinscheduler/ui/projects/11741875462240/workflow/instances/8362?code=14204722747616)
![第一次失败后，后续再成功](images/Pasted%20image%2020240708103710.png)


测试案例三：所有重试均失败，返回失败状态，打印最后一次失败日志：[dolphin测试环境](http://dolphinscheduler_dev.com/dolphinscheduler/ui/projects/11741875462240/workflow/instances/8361?code=14204722747616)
![所有重试均失败，返回失败状态，打印最后一次失败日志](images/Pasted%20image%2020240708103842.png)

### 样例代码



这里贴出测试脚本案例：
```
/Users/xiang/Documents/work/project/bigdata/dolphinscheduler-test/temp/succAndFail.sh
```



```sh
#!/bin/bash
source /etc/profile
# 日志

# 获取脚本文件名
script_name=$(basename "$0")
# 获取脚本所在目录的绝对路径
log_dir=$(cd "$(dirname "$0")" && pwd)/logs
# 拼接得到脚本的绝对路径
script_path="$log_dir/$script_name"
# 系统当前时间
current_time=$(date +'%Y-%m-%d %H:%M:%S')


# 定义重试次数
max_retries=3
retry_count=0
exit_code=1
retry_sleep_time=30

# 检查 logs 文件夹是否存在，如果不存在则创建
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
    echo "$current_time 创建日志文件夹: $log_dir"
fi


echo "$current_time===============$script_path开始更新====================日志路径为$log_dir/$script_name.log=============="

## 注意： 第一行SQL一定不能携带注释，除了第一行其他地方可以 --
## 如果在第一行使用了注释，会跳过整个脚本的执行
sql="
create temporary table example as
select * from test1;
-- 创建临时表 来自 default.test1 表
"


# 循环重试
while [ $retry_count -lt $max_retries ] && [ $exit_code -ne 0 ]; do
    # 执行 Hive 查询
    hive -e "$sql" > "$log_dir/$script_name.log" 2>&1

    # 获取上一条命令的退出码
    exit_code=$?

    if [ $exit_code -ne 0 ]; then
        echo "当前时间：$current_time, HQL 执行失败 等待一段时间再重试 等待时间："   $retry_sleep_time  " 单位：秒, 当前重试次数:  "  $retry_count
        retry_count=$((retry_count + 1))
        sleep $retry_sleep_time  # 等待一段时间再重试，可以根据需要调整
    fi
done

echo "$current_time ===============$script_path表更新完成====================日志路径为$log_dir/$script_name.log=============="

if [ $exit_code -ne 0 ]; then
    echo "$current_time HQL 最终执行失败，已重试 $retry_count 次，达到最大重试次数 ====> 打印最后一次执行失败的错误日志："
    cat "$log_dir/$script_name.log"
    exit 1  # 失败状态码
else
    echo "$current_time HQL 执行成功"
    exit 0  # 成功状态码
fi
```

