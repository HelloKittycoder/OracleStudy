create or replace package body myutil_pkg as

  /**
  * 用于返回列表数据的通用cursor
   */
  type ref_type is ref cursor;

  --------------------------------------员工信息start---------------------------------
  /**
  * 查询员工信息
  */
  function find_empinfo return emp_record_tab pipelined
   as
   empinfo_ref ref_type;
   v_ret emp_record;
  begin
    open empinfo_ref for
      'select e.empno,
         e.ename,
         e.job,
         e.mgr,
         e.hiredate,
         e.sal,
         e.comm,
         e.deptno
      from emp e';
    fetch empinfo_ref into v_ret;
    loop
      exit when empinfo_ref%notfound;
      pipe row(v_ret);
      fetch empinfo_ref into v_ret;
    end loop;
    close empinfo_ref;
  end find_empinfo;
  --------------------------------------员工信息end---------------------------------

end myutil_pkg;