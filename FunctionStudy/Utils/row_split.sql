--创建需要用于返回的类型
create or replace type t_ret_table  
    as table of varchar2(1000);

create or replace function row_split(var_str varchar2, var_split in varchar2)
--将字符串分割为多条记录
/* 使用示例
select * from table(row_split('|111|222|', '|');
  
select * from table(row_split(' 111 222 ', ' '));
  
select * from table(row_split(',111,222,', ','));

更多请参见 https://blog.csdn.net/u010999809/article/details/79825731
*/
return t_ret_table pipelined  
as  
var_tmp varchar2(1000);  
var_element varchar2(1000);  
n_length number:=length(var_split);
begin  
  /*  
    对输入的字符串做预处理，去掉两端的分隔符  
  （参考https://jingyan.baidu.com/article/3a2f7c2e72324e26afd6119a.html）  
  */  
  var_tmp := trim(both var_split from var_str);  
  --只要字符串中存在分隔符，则继续执行将分隔出来的字符取出的操作  
  while instr(var_tmp, var_split) > 0 loop  
    var_element := substr(var_tmp, 1, instr(var_tmp, var_split)-1);  
    -- 每取完字符串里的分隔的字符，该字符将从原始字符串中剔除  
    var_tmp := substr(var_tmp,  
                      instr(var_tmp, var_split)+n_length,  
                      length(var_tmp));  
    pipe row(var_element);  
  end loop;  
  pipe row(var_tmp);  
  return;  
end row_split;