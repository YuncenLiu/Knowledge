> 2024-06-19 
> Windows  VMware 192.168.111.120

```sh
docker pull postgres
```



```sh
docker run --name postgres -e POSTGRES_PASSWORD=123456 -p 5432:5432 -v /root/docker/postgrep/data:/var/lib/postgresql/data -d postgres
```



登录进去

```sql
[root@localhost data]# docker exec -it postgres /bin/bash
root@d3b202d3ece5:/# su postgres
postgres@d3b202d3ece5:/$ psql
psql (14.1 (Debian 14.1-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=# 
```

