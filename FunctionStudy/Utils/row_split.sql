--������Ҫ���ڷ��ص�����
create or replace type t_ret_table  
    as table of varchar2(1000);

create or replace function row_split(var_str varchar2, var_split in varchar2)
--���ַ����ָ�Ϊ������¼
/* ʹ��ʾ��
select * from table(row_split('|111|222|', '|');
  
select * from table(row_split(' 111 222 ', ' '));
  
select * from table(row_split(',111,222,', ','));

������μ� https://blog.csdn.net/u010999809/article/details/79825731
*/
return t_ret_table pipelined  
as  
var_tmp varchar2(1000);  
var_element varchar2(1000);  
n_length number:=length(var_split);
begin  
  /*  
    ��������ַ�����Ԥ����ȥ�����˵ķָ���  
  ���ο�https://jingyan.baidu.com/article/3a2f7c2e72324e26afd6119a.html��  
  */  
  var_tmp := trim(both var_split from var_str);  
  --ֻҪ�ַ����д��ڷָ����������ִ�н��ָ��������ַ�ȡ���Ĳ���  
  while instr(var_tmp, var_split) > 0 loop  
    var_element := substr(var_tmp, 1, instr(var_tmp, var_split)-1);  
    -- ÿȡ���ַ�����ķָ����ַ������ַ�����ԭʼ�ַ������޳�  
    var_tmp := substr(var_tmp,  
                      instr(var_tmp, var_split)+n_length,  
                      length(var_tmp));  
    pipe row(var_element);  
  end loop;  
  pipe row(var_tmp);  
  return;  
end row_split;