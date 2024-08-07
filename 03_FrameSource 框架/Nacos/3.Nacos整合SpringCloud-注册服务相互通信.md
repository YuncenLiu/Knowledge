> 创建于2021年12月17日
> 		作者：想想

[toc]

# Nacos 整合 Springcloud 注册服务并相互通信

## 1、创建父亲pom工程

创建模块 `nacos-spring-cloud-discovery-example`

```xml
    <modules>
        <module>nacos-spring-cloud-provider-example</module>
        <module>nacos-spring-cloud-consumer-example</module>
    </modules>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
                <version>0.2.2.RELEASE</version>
            </dependency>
            <dependency>
                <groupId>com.alibaba.nacos</groupId>
                <artifactId>nacos-client</artifactId>
                <version>1.1.0</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
```

### 1.1、创建 consumer 模块

创建 `nacos-spring-cloud-consumer-example`

`bootstrap.properites`

```properties
server.port=8080
spring.application.name=service-consumer
spring.cloud.nacos.discovery.server-addr=127.0.0.1:8840
```

### 1.2、创建  provider 模块

创建 `nacos-spring-cloud-provider-example`

`bootstrap.properites`

```properties
server.port=8090
spring.application.name=service-provider
spring.cloud.nacos.discovery.server-addr=localhost:8840
```

均创建pom文件

```xml
<dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
                <version>0.2.2.RELEASE</version>
            </dependency>
            <dependency>
                <groupId>com.alibaba.nacos</groupId>
                <artifactId>nacos-client</artifactId>
                <version>1.1.0</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
```

## 2、创建启动类

### 2.1、consumer 启动类

```java
package com.alibaba.nacos.example.spring.cloud;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

/**
 * @author xiaojing
 */
@SpringBootApplication
@EnableDiscoveryClient
public class NacosConsumerApplication {

    @LoadBalanced
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    public static void main(String[] args) {
        SpringApplication.run(NacosConsumerApplication.class, args);
    }

    @RestController
    public class TestController {

        private final RestTemplate restTemplate;

        @Autowired
        public TestController(RestTemplate restTemplate) {this.restTemplate = restTemplate;}

        @RequestMapping(value = "/echo/{str}", method = RequestMethod.GET)
        public String echo(@PathVariable String str) {
            return restTemplate.getForObject("http://service-provider/echo/" + str, String.class);
        }

        @RequestMapping(value = "/say/{str}", method = RequestMethod.GET)
        public String say(@PathVariable String str) {
            System.out.println(str);
            return str;
        }
    }
}
```

使用 RestTemplate 调用 `service-provider` 服务

### 2.2、provider 启动类

```java
package com.alibaba.nacos.example.spring.cloud;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

/**
 * @author xiaojing
 */
@SpringBootApplication
@EnableDiscoveryClient
public class NacosProviderApplication {


	@LoadBalanced
	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();
	}


	public static void main(String[] args) {
		SpringApplication.run(NacosProviderApplication.class, args);
	}

	@RestController
	public class EchoController {
		private final RestTemplate restTemplate;

		@Autowired
		public EchoController(RestTemplate restTemplate) {
			this.restTemplate = restTemplate;
		}

		@RequestMapping(value = "/echo/{string}", method = RequestMethod.GET)
		public String echo(@PathVariable String string) {
			String forObject = restTemplate.getForObject("http://service-consumer/say/" + string, String.class);
			System.out.println("forObject = " + forObject);
			return "Hello Nacos Discovery " + string;
		}
	}
}
```

和 consumer 一致，也适用 RestTemplate 进行通讯

测试方法，先调用 consumer 的8080端口

```
# 顺序
localhost:8080/echo/123
# 程序进入到 consumer 中，通过 restTemplate 调用
http://service-provider/echo/123
# 程序进入到 profiver 中，在通过 restTemplate 调用
          http://service-consumer/say/123
          # consumer 的say接口，打印了123后
          #provier 继续返回 Hello Nacos Discovery 123
# consumer 接收到 provier 的 Hello Nacos Discovery 123 ，输出在浏览器上

          
```

