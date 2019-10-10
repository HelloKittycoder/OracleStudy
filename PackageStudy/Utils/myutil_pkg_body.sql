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

  --------------------------------------工具function---------------------------------
  /**
  * 判断是否为数字
  **/
  function is_number(str varchar2) return varchar2
    as
      num_ number;
  begin
    num_:=to_number(str);
    return 'Y';
  exception
    when others then
      return 'N';
  end is_number;

  /**
  * 获取当前数据库的表的统计数据（非空表、空表、所有表的数量）
  **/
  function tab_status return tab_str pipelined
    as
      v_ret varchar2(500);
      tmp_num number;
  begin
    select count(*) into tmp_num from user_tables where num_rows != 0; -- 非空表
    v_ret:='非空表：'||tmp_num;
    pipe row(v_ret);

    select count(*) into tmp_num from user_tables where num_rows = 0; -- 空表
    v_ret:='空表：'||tmp_num;
    pipe row(v_ret);

    select count(*) into tmp_num from user_tables; -- 表的总数
    v_ret:='总数：'||tmp_num;
    pipe row(v_ret);
  end tab_status;

  --------------------------------------工具procedure---------------------------------
  /**
  * 刷新user_tables中的统计数据
  * https://blog.csdn.net/chfyljt/article/details/80623078
  **/
  procedure statistics_all_tab as
  begin
    for rs in (select ut.table_name from user_tables ut) loop
      execute immediate 'analyze table'||rs.table_name||' compute statistics';
    end loop;
  exception
    when others then
      dbms_output.put_line('errm statistics_all_tab:'||sqlerrm);
  end statistics_all_tab;

  /**
  * 生成java代码中的查询、新增、修改语句
  * crudType 操作类型（select 查询；insert 新增；update 修改）
  * vc_table_name 表名称
  */
  procedure p_generate_sql(crudType in varchar2, vc_table_name in varchar2) is
    v_output_sql varchar2(2000); --输出的sql语句
    v_temp_sql varchar2(2000);
    vc_field_name varchar2(200); --字段在实体类中的名称
    result_cur sys_refcursor;--存放动态sql的执行结果
    --vc_table_name varchar2(200):='f_sfundgp_info';
  begin
    if crudType='select' then
      --获取表里的所有字段
      v_temp_sql:='select lower(ut.COLUMN_NAME)||'' as ''||lower(regexp_substr(regexp_replace(initcap(ut.COLUMN_NAME), ''Vc_|D_'', ''''),''^.'')) ||'||
           'regexp_replace(regexp_replace(regexp_replace(initcap(ut.COLUMN_NAME), ''Vc_|D_'', ''''),''^(.)'',''''),''_'','''')'||
        'from user_tab_cols ut'||
        ' left join user_col_comments ucc'||
          ' on (ut.TABLE_NAME = ucc.table_name and ut.COLUMN_NAME = ucc.column_name)'||
       'where ut.TABLE_NAME = upper('''||vc_table_name||''')'||
      'order by ut.COLUMN_ID';
      v_output_sql:='select ';
      open result_cur for v_temp_sql;
      fetch result_cur into vc_field_name;
      loop
        exit when not result_cur%found;
        --dbms_output.put_line(vc_field_name);
        v_output_sql:=v_output_sql||vc_field_name||',';
        fetch result_cur into vc_field_name;
      end loop;
      close result_cur;
      v_output_sql:=rtrim(v_output_sql,',')||' from '||vc_table_name;
    elsif crudType='insert' then
      --获取表里的所有字段（数据库字段名称）
      v_temp_sql:='select lower(ut.COLUMN_NAME)'||
        ' from user_tab_cols ut'||
       ' where ut.TABLE_NAME = upper('''||vc_table_name||''')'||
      'order by ut.COLUMN_ID';
      --dbms_output.put_line(v_temp_sql);
      v_output_sql:='insert into '||vc_table_name||'(';
      open result_cur for v_temp_sql;
      fetch result_cur into vc_field_name;
      loop
        exit when not result_cur%found;
        --dbms_output.put_line(vc_field_name);
        v_output_sql:=v_output_sql||vc_field_name||',';
        fetch result_cur into vc_field_name;
      end loop;
      close result_cur;
      v_output_sql:=rtrim(v_output_sql,',')||') values (';

      --获取表里的所有字段（字段在实体类中的名称）
      v_temp_sql:='select lower(regexp_substr(regexp_replace(initcap(ut.COLUMN_NAME), ''Vc_|D_'', ''''),''^.'')) ||'||
           'regexp_replace(regexp_replace(regexp_replace(initcap(ut.COLUMN_NAME), ''Vc_|D_'', ''''),''^(.)'',''''),''_'','''')'||
        'from user_tab_cols ut'||
       ' where ut.TABLE_NAME = upper('''||vc_table_name||''')'||
      'order by ut.COLUMN_ID';
      open result_cur for v_temp_sql;
      fetch result_cur into vc_field_name;
      loop
        exit when not result_cur%found;
        v_output_sql:=v_output_sql||'#'||vc_field_name||'#,';
        fetch result_cur into vc_field_name;
      end loop;
      close result_cur;
      v_output_sql:=rtrim(v_output_sql,',')||')';
    elsif crudType='update' then
      --获取表里的所有字段
      v_temp_sql:='select lower(ut.COLUMN_NAME)||'' = #''||lower(regexp_substr(regexp_replace(initcap(ut.COLUMN_NAME), ''Vc_|D_'', ''''),''^.'')) ||'||
           'regexp_replace(regexp_replace(regexp_replace(initcap(ut.COLUMN_NAME), ''Vc_|D_'', ''''),''^(.)'',''''),''_'','''')||''#'''||
        'from user_tab_cols ut'||
        ' left join user_col_comments ucc'||
          ' on (ut.TABLE_NAME = ucc.table_name and ut.COLUMN_NAME = ucc.column_name)'||
       'where ut.TABLE_NAME = upper('''||vc_table_name||''')'||
      'order by ut.COLUMN_ID';
      --dbms_output.put_line(v_temp_sql);
      v_output_sql:='update '||vc_table_name||' set ';
      open result_cur for v_temp_sql;
      fetch result_cur into vc_field_name;
      loop
        exit when not result_cur%found;
        --dbms_output.put_line(vc_field_name);
        v_output_sql:=v_output_sql||vc_field_name||',';
        fetch result_cur into vc_field_name;
      end loop;
      close result_cur;
      v_output_sql:=rtrim(v_output_sql,',')||' where 1=1';
    end if;
    dbms_output.put_line(v_output_sql);
  end;

end myutil_pkg;