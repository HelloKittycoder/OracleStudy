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

end myutil_pkg;