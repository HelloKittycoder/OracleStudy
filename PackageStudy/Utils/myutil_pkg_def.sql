create or replace package myutil_pkg authid current_user as

  --------------------------------------type定义---------------------------------
  -- 员工信息记录
  type emp_record is record(
    empno emp.empno%type,
    ename emp.ename%type,
    job emp.job%type,
    mgr emp.mgr%type,
    hiredate emp.hiredate%type,
    sal emp.sal%type,
    comm emp.comm%type,
    deptno emp.deptno%type
  );
  type emp_record_tab is table of emp_record;

  -- 定义通用的字符串数组参数类型（传入或返回参数）
  type tab_str is table of varchar(30);

  --------------------------------------员工信息start---------------------------------

  /**
  * 查询项目信息
  */
  -- 使用示例：select * from table(myutil_pkg.find_empinfo);
  function find_empinfo return emp_record_tab pipelined;

  --------------------------------------员工信息end---------------------------------

  --------------------------------------工具function---------------------------------
  /**
  * 判断是否为数字
  **/
  --使用示例：select myutil_pkg.is_number('a') from dual;
  function is_number(str varchar2) return varchar2;

  /**
  * 获取当前数据库的表的统计数据（非空表、空表、所有表的数量）
  **/
  --使用示例：select * from table(myutil_pkg.tab_status);
  function tab_status return tab_str pipelined;

  --------------------------------------工具procedure---------------------------------
  /**
  * 生成java代码中的查询、新增、修改语句
  * crudType 操作类型（select 查询；insert 新增；update 修改）
  * vc_table_name 表名称
  */
  -- 使用示例：
  /*
  declare
   vc_table_name varchar2(200);
  begin
    vc_table_name:='t_student';
    dbms_output.put_line('=====生成'||vc_table_name||'的语句====');
    myutil_pkg.P_GENERATE_SQL('select',vc_table_name);
    myutil_pkg.P_GENERATE_SQL('insert',vc_table_name);
    myutil_pkg.P_GENERATE_SQL('update',vc_table_name);
    dbms_output.put_line('');
  end;
   */
  procedure p_generate_sql(crudType in varchar2, vc_table_name in varchar2);

end myutil_pkg;