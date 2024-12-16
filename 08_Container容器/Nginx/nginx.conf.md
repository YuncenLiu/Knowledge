```nginx
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>           全局块内容 Start
# 运行用户 不指定默认使用 nobody 用户运行，这里用的是什么用户  worker process 就是什么用户
# 如果非当前设定用户则:  但是依旧会运行，只是报个错而已
# nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /usr/local/nginx/conf/nginx.conf:3
# user nobody;

# workder 进程数量，通常设置为 cpu 数量相等
# 如果这里设置了很多 就会有很多个 process 进程，而且 kill 掉之后，立刻就会运行起来
# > ps -ef|grep nginx
# root      10226      1  0 17:01 ?        00:00:00 nginx: master process ./nginx
# nobody    12599  10226  0 17:34 ?        00:00:00 nginx: worker process
# nobody    12600  10226  0 17:34 ?        00:00:00 nginx: worker process
# nobody    12601  10226  0 17:34 ?        00:00:00 nginx: worker process
# nobody    12602  10226  0 17:34 ?        00:00:00 nginx: worker process

worker_processes 1;



# 全局错误日志 下面三个选一个设置就行了，后面跟的参数是日志级别 error > warn > notice > info  ,其中 info 是最详细的日志

# error_log logs/error.log;
# error_log logs/error.log notice;
error_log logs/error.log info;



# > cat nginx.pid 
# 10226
# > ps -ef|grep nginx
# root      10226      1  0 17:01 ?        00:00:00 nginx: master process ./nginx

pid logs/nginx.pid;
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>           全局块内容 End

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>           start、event （影响nginx服务器和用户的网络连接）Start
events {
    # 单个 workder 进程的最大并发连接数
    # worker_processes 进程数 * worker_connections 并发连接数 = 服务最大并发数
    worker_connections 1024;
}
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>           start、event （影响nginx服务器和用户的网络连接）End


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>           http 虚拟主机、监听端口、请求转发、反向代理、负载均衡 Start


http {
    # 引入 minme 类型定义文件
    include mime.types;
    default_type application/octet-stream;

    # 设定日志格式
    log_format main '[$time_iso8601] $remote_addr $remote_user $request '
                    '$status $body_bytes_sent $http_referer '
                    '$http_user_agent $http_x_forwarded_for';
    access_log logs/access.log main;

    # IO密集型服务器 再关掉它
    sendfile on;

    # 连接超时时间
    # keepalive_timeout 0;
    keepalive_timeout 65;

    # 开启 gzip 压缩
    # gzip on;
    
    # 负载均衡配置
    upstream tomcatServer{
        # hash分配，可以解决 session 问题
        # ip_hash;
        
        # server 127.0.0.1:8080 weight=3;
        # consistent_hash $request_uri;
        server 127.0.0.1:8080;
        server 127.0.0.1:8081;
        server 127.0.0.1:8082;
    }

    # 一个 http 里面可以有多个 server
    server {
        # 监听端口
        listen 80;

        # 定义虚拟主机
        server_name localhost;

        location / {
            root html;
            index index.html index.htm;
            proxy_set_header Host $host;
            proxy_pass http://tomcatServer/;
        }

        location /favicon.ico{
        } 

        # location /web {
        #     proxy_pass http://tomcatServer/;
        # }
    
    		# 在 /usr/share/nginx/html 路径下要有 404.html 文件
        error_page 404 /404.html;
        location = /404.html {
            root /usr/share/nginx/html;
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root html;
        }
    }
}



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>           http 虚拟主机、监听端口、请求转发、反向代理、负载均衡 End
```

