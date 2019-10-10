### 基础函数学习

#### 时间相关
季度（quarter）q、月（month）m、周（week）iw、日（day）d
查询字段为date
本季度
```sql
select * from 表名 where to_char(字段名,'q')=to_char(sysdate,'q')
```
本月
```sql
select * from 表名 where to_char(字段名,'mm')=to_char(sysdate,'m')
```
本周
```sql
select * from 表名 where to_char(字段名,'iw')=to_char(sysdate,'iw')
```
今日
```sql
select * from 表名 where to_char(字段名,'dd')=to_char(sysdate,'dd')
```
昨日
```sql
select * from 表名 where to_char(字段名,'dd')=to_char(sysdate-1,'dd')
```

字段类型为varchar2，里面存的日期格式要与转换后的格式匹配（比如：该字段本来为2019-10-10，格式就用yyyy-mm-dd）
本季度
```sql
select * from 表名 where to_char(to_date(字段名,'yyyy-mm-dd'),'q')=to_char(sysdate,'q')
```
本月
```sql
select * from 表名 where to_char(to_date(字段名,'yyyy-mm-dd'),'mm')=to_char(sysdate,'mm')
```
其他的都类似  

另外再补充下：  
```sql
select to_char(to_date('2019-10-10','yyyy-mm-dd'),'dd') from dual; -- 10
select to_char(date'2019-10-10','dd') from dual; -- 10
select to_char(to_date('2019-10-10','yyyy-mm-dd')-1,'dd') from dual; -- 09
select to_char(date'2019-10-10'-1,'dd') from dual; -- 09
```
参考链接：https://blog.csdn.net/ZhaoChengWeiCSDN/article/details/81324050