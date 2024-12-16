## MySQL JSON 查询

```sql
select JSON_EXTRACT(column, '$.CPU') from 1;
```



### 当查询 json 串中多个值时，可以使用如下方式，只适合 5.7 以上版本

```sql
SELECT 
    jt.name
FROM 
    data_set_config,
    JSON_TABLE(table_config, '$[0].columnConfig[*]'
    COLUMNS (
        name VARCHAR(255) PATH '$.name'
    )) AS jt
WHERE 
    data_set_name LIKE '%06%';
```



```sql
SELECT 
    jt.queryField,jt.name,jt.typeName,jt.queryFilter,jt.comment,jt.asField,jt.returnField,jt.tableName
FROM 
    data_set_config,
    JSON_TABLE(table_config, '$[*].columnConfig[*]'
    COLUMNS (
        queryField VARCHAR(255) PATH '$.queryField',
        name VARCHAR(255) PATH '$.name',
        typeName VARCHAR(255) PATH '$.typeName',
        queryFilter VARCHAR(255) PATH '$.queryFilter',
        comment VARCHAR(255) PATH '$.comment',
        asField VARCHAR(255) PATH '$.asField',
        returnField VARCHAR(255) PATH '$.returnField',
        tableName VARCHAR(255) PATH '$.tableName'
    )) AS jt
WHERE 
    data_set_name LIKE '%01-投承保数据-V2.6%';
```

