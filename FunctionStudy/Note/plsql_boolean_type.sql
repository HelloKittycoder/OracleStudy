declare
  /*
  * 测试PL/SQL的布尔类型
  *
  * 说明：布尔类型是PL/SQL数据类型的一种，能存储true，false。只有逻辑运算符才允许应用在布尔变量上
  * 数据库SQL类型并不支持布尔类型，只有plsql才支持
  *
  * 参考链接：https://zhidao.baidu.com/question/204246340877092605.html
  * https://bbs.csdn.net/topics/380135194
  */
  v_boolean boolean; -- 声明一个布尔类型变量
  function bool2char(bool in boolean)
    return varchar2 is
  begin
    if bool then
      return 'true';
    elsif not bool then
      return 'false';
    else
      return 'null';
    end if;
  end;
begin
  -- 获取默认值
  dbms_output.put_line('布尔型的默认值为');
  if v_boolean then
    dbms_output.put_line('true');
  else
    dbms_output.put_line('false');
  end if;
  dbms_output.put_line('');

  -- 修改v_boolean的值（dbms_output没有提供对布尔类型的支持，无法直接打印）
  v_boolean:=true;
  if v_boolean then
    dbms_output.put_line('v_boolean的值被改成'||bool2char(v_boolean)||'了');
  end if;

  -- 配合逻辑运算符来组合出复杂表达式，在赋值的时候会事先把表达式的结果计算出来
  v_boolean:=(2>1) and (3>2) and (4>3);
  dbms_output.put_line('(2>1) and (3>2) and (4>3)的计算结果为：'||bool2char(v_boolean));
end;