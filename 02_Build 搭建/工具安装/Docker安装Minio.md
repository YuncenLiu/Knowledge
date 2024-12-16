> 创建于 2021年12月23日
> 		作者：想想

[toc]

### MonIO

```sh
docker run \
  -p 9000:9000 \
  -p 9001:9001 \
  --name minio \
  -e "MINIO_ROOT_USER=ROOT" \
  -e "MINIO_ROOT_PASSWORD=ROOT123456" \
  -v /mnt/data:/data/minio \
  quay.io/minio/minio server /data/minio --console-address ":9001"
```

