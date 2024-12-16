### 1. 查询所有表空间的大小和使用情况

```sql
sqlCopy CodeSELECT 
    tablespace_name,
    SUM(bytes) / (1024 * 1024) AS total_size_mb,
    SUM(CASE WHEN file_id IS NOT NULL THEN bytes ELSE 0 END) / (1024 * 1024) AS used_size_mb,
    (SUM(bytes) - SUM(CASE WHEN file_id IS NOT NULL THEN bytes ELSE 0 END)) / (1024 * 1024) AS free_size_mb
FROM 
    dba_data_files
GROUP BY 
    tablespace_name;
```

### 2. 查询特定表空间的大小和使用情况

如果你只想查询某个特定表空间，比如 `YOUR_TABLESPACE`，可以这样修改上面的查询：

```sql
sqlCopy CodeSELECT 
    tablespace_name,
    SUM(bytes) / (1024 * 1024) AS total_size_mb,
    SUM(CASE WHEN file_id IS NOT NULL THEN bytes ELSE 0 END) / (1024 * 1024) AS used_size_mb,
    (SUM(bytes) - SUM(CASE WHEN file_id IS NOT NULL THEN bytes ELSE 0 END)) / (1024 * 1024) AS free_size_mb
FROM 
    dba_data_files
WHERE 
    tablespace_name = 'YOUR_TABLESPACE'
GROUP BY 
    tablespace_name;
```

### 3. 查询临时表空间的大小

对于临时表空间，可以通过以下查询获得信息：

```sql
sqlCopy CodeSELECT 
    tablespace_name,
    SUM(bytes) / (1024 * 1024) AS total_size_mb
FROM 
    dba_temp_files
GROUP BY 
    tablespace_name;
```

### 4. 查看表空间的详细信息

如果你需要更详细的信息，比如每个数据文件的使用情况，可以使用以下查询：

```sql
sqlCopy CodeSELECT 
    df.tablespace_name,
    df.file_name,
    df.bytes / (1024 * 1024) AS total_size_mb,
    (df.bytes - NVL(fs.bytes, 0)) / (1024 * 1024) AS used_size_mb,
    NVL(fs.bytes, 0) / (1024 * 1024) AS free_size_mb
FROM 
    dba_data_files df
LEFT JOIN 
    (SELECT 
         tablespace_name,
         file_id,
         SUM(bytes) AS bytes 
     FROM 
         dba_free_space 
     GROUP BY 
         tablespace_name, file_id) fs 
ON 
    df.tablespace_name = fs.tablespace_name AND df.file_id = fs.file_id;
```