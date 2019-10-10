myutil_pkg 常用工具包  
基于oracle里scott/tiger用户，emp、dept表编写的  

执行次序：  
myutil_pkg_related.sql  
myutil_pkg_def.sql  
myutil_pkg_body.sql  

功能说明：  
find_empinfo 查询员工信息  

-----------工具function-----------  
is_number(str varchar2) 判断是否为数字  
tab_status 获取当前数据库的表的统计数据（非空表、空表、所有表的数量）  

-----------工具procedure-----------  
p_generate_sql(crudType in varchar2, vc_table_name in varchar2) 生成java代码中的查询、新增、修改语句  