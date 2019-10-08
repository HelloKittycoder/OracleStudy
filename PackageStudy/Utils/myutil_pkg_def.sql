create or replace package myutil_pkg authid current_user as

  --------------------------------------type定义---------------------------------
  -- 员工信息
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

  --------------------------------------员工信息start---------------------------------

  /**
  * 查询项目信息
  */
  -- 使用示例：select * from table(myutil_pkg.find_empinfo);
  function find_empinfo return emp_record_tab pipelined;

  --------------------------------------员工信息end---------------------------------

end myutil_pkg;