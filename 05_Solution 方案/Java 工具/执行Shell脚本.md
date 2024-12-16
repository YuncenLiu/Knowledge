Java 执行 Shell 脚本

```shell
ssh monitor@192.168.1.10 "touch /home/xiang/test.text"
```

```sql
 String[] queryParams = new String[] {
                "ssh"
                ,"monitor@192.168.1.10"
                ,"touch"
                ,"/home/xiang/test.text"
        };
exeCommand(queryParams);
```

```java
public static int exeCommand(String[] cmdarray) throws Exception {

        try {

            //单独的进程中执行指定命令和变量
            Process ps = Runtime.getRuntime().exec(cmdarray);

            /**
             * 1.JVM会启一个Process，所以我们可以通过调用Process类的以下方法，
             * 得知调用操作是否正确执行
             * 2.导致当前线程等待，如有必要，一直要等到由该 Process 对象表示的进程已经终止
             */
            int status = ps.waitFor();

            log.info("脚本执行状态："+status);

            if (status == 0) { //表示执行成功
                log.info("脚本执行成功！");
                return status;
            }

            //读取错误消息
            try (
                    BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream()));
            ){
                StringBuffer sb = new StringBuffer();
                String line = null;

                while ((line = br.readLine()) != null) {
                    sb.append(line).append("\n");
                }

                log.error("执行脚本失败，失败消息："+sb.toString());

                return status;
            } catch (Exception e) {
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
```



