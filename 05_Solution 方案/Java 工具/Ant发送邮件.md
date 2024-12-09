

## Apache-ant  实现携带附件邮件发送

```sh
klapp/apache-ant-1.9.15/bin/ant -v -buildfile  mail.xml
```




```xml

<?xml version="1.0" ?>
<project name="mailReport" default="sendMail" >
    <target name="sendMail" >
        <mail   mailhost="mail.kunlunhealth.com" mailport="25" subject="宽末继续率清单" user="data_alarm@kunlunhealth.com" password="8QE84EZVngSJXNhL"   tolist= "zhangchangsheng@anycreate.com.cn" cclist="data_alarm@kunlunhealth.com" messageMimeType="text/html" >
            <from address="data_alarm@kunlunhealth.com" />
            <!-- 邮件内容 -->
            <message>
           <![CDATA[
         您好:
      <p>附件是本月宽末继续率应收清单，请查收！</p>
      <p>如有疑问，请联系信息技术部数据管理组。</p>
       ]]>

        </message>
            <!-- 附件 -->
            <attachments>
                <fileset dir="liscron" >
                    <include name="宽末继续率清单.zip" />
                </fileset>
            </attachments>
        </mail>
    </target>
</project>

```

