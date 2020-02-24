create or replace package body myutil_pkg as

  /**
  * 用于返回列表数据的通用cursor
   */
  type ref_type is ref cursor;

  --------------------------------------初始化操作---------------------------------
  --package中如何进行初始化操作？ http://www.dba-oracle.com/plsql/t_plsql_global_data.htm
  procedure initialize as
  begin
    --初始化类型数组
    --dictTypeArr v_dict_type_arr:=v_dict_type_arr(null);
    dictTypeArr.extend(4,1); --初始化3个元素 http://blog.itpub.net/17013648/viewspace-1116033/
    dictTypeArr(1):='docType';
    dictTypeArr(2):='sex';
    dictTypeArr(3):='reportType';
    dictTypeArr(4):='currency';
    dictTypeArr(5):='ageSituation';
  end initialize;

  --------------------------------------dict相关操作start---------------------------------
  /**
  * 根据类型查询对应的下拉选项值
  **/
  function find_dict(vc_dict_type varchar2) return dict_tab pipelined
    as
      dict_ref ref_type;
      v_ret t_dict%rowtype;
      temp_dict_type varchar2(100);
      --v_ret edim_tab;
  begin
    --尝试进行类型转换
    if is_number(vc_dict_type)='Y' then
      temp_dict_type:=dictTypeArr(vc_dict_type);
    else
      temp_dict_type:=vc_dict_type;
    end if;

    open dict_ref for 'select * from t_dict where vc_type = :1'
      || ' order by to_number(vc_ord)'
      using temp_dict_type;
    /*loop
      fetch dict_ref into v_ret;
      pipe row(v_ret);
      exit when dict_ref%notfound;
    end loop;*/

    fetch dict_ref into v_ret;
    loop
      exit when dict_ref%notfound;
      pipe row(v_ret);
      fetch dict_ref into v_ret;
    end loop;

    --fetch dict_ref bulk collect into v_ret;
    --pipe row(v_ret);
    close dict_ref;
  end find_dict;

  function find_sdict(vc_dict_type varchar2) return simple_dict_tab pipelined
    as
      dict_ref ref_type;
      v_ret simple_dict_record;
      temp_dict_type varchar2(100);
  begin
    --尝试进行类型转换
    if is_number(vc_dict_type)='Y' then
      temp_dict_type:=dictTypeArr(vc_dict_type);
    else
      temp_dict_type:=vc_dict_type;
    end if;

    open dict_ref for 'select vc_cde,vc_nme,vc_type,vc_type_name from t_dict where vc_type = :1'
      || ' order by to_number(vc_ord)'
      using temp_dict_type;
    /*loop
      fetch dict_ref into v_ret;
      pipe row(v_ret);
      exit when dict_ref%notfound;
    end loop;*/

    fetch dict_ref into v_ret;
    loop
      exit when dict_ref%notfound;
      pipe row(v_ret);
      fetch dict_ref into v_ret;
    end loop;

    close dict_ref;
  end find_sdict;
  --------------------------------------dict相关操作end---------------------------------

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

  /**
  * 返回指定字符串的md5加密结果
  **/
  function md5(input_str in varchar2) return varchar2
    as
      raw_input raw(128):=UTL_RAW.cast_to_raw(input_str);
      decryted_raw raw(2048);
      error_in_input_buffer_length exception;
  begin
    DBMS_OBFUSCATION_TOOLKIT.md5(input=>raw_input,
        checksum=>decryted_raw);
    return LOWER(RAWTOHEX(decryted_raw));
    -- return input_string;
  end md5;

  --------------------------------------工具procedure---------------------------------
  /**
  * 将序列的当前值恢复至指定数字
  * seqName 序列名称
  * num 需要恢复到哪个数字
  **/
  procedure updateSeqToNum(seqName varchar2, num number) as
    n number;
    comm_exception exception;
  begin
    if num < 1 then
      raise comm_exception;
    else
      --https://blog.csdn.net/u010999809/article/details/79943924
      --https://blog.csdn.net/pete_emperor/article/details/82853277
      --获取序列的下一个值
      execute immediate 'select '||seqName||'.nextval from dual' into n;

      --修改序列的minvalue参数
      execute immediate 'alter sequence '||seqName||' minvalue 1';

      if n>1 then
        n:=-(n-num); --这里是要恢复到num（num>=1）
        --修改increment参数
        execute immediate 'alter sequence '||seqName||' increment by '||n;
        execute immediate 'select '||seqName||'.nextval from dual' into n;

        --恢复increment参数值
        execute immediate 'alter sequence '||seqName||' increment by 1';
      end if;
    end if;
  exception
    when comm_exception then
      raise_application_error(-20001,'序列数字不能小于1');

  end updateSeqToNum;

  /**
  * 批量创建序列
  * seqNames 序列名称数组
  **/
  procedure createSeqs(seqNames tab_str) as
  begin
    --https://blog.csdn.net/zzkongfu/article/details/7480958
    --https://blog.csdn.net/wonder4/article/details/649869
    --提示权限不足
    --https://blog.csdn.net/jerryitgo/article/details/79220598
    --http://www.cnblogs.com/yhoralce/p/6817010.html?utm_source=itdadao&utm_medium=referral
    --循环table中的数据
    for i in 1 .. seqNames.count loop
      --如果存放的不是空字符串，则拼接语句执行创建序列
      if seqNames(i) is not null then
        --dbms_output.put_line('++++++'||seqNames(i));
        execute immediate 'create sequence '||seqNames(i)||' '||
        'minvalue 1 start with 1 '||
        'increment by 1 cache 20';
      end if;
    end loop;
  end createSeqs;

  /**
  * 批量删除序列
  * seqNames 序列名称数组
  **/
  procedure dropSeqs(seqNames tab_str) as
  begin
    for i in 1 .. seqNames.count loop
      if seqNames(i) is not null then
        execute immediate 'drop sequence '||seqNames(i);
      end if;
    end loop;
  end dropSeqs;

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
  * 给需要做导出操作的数据库，其中的空表分配空间（如果空表没有分配空间的话）
  * https://www.cnblogs.com/ningvsban/p/3603678.html
  **/
  procedure distribExtent as
  begin
    for rs in (select ut.table_name from user_tables ut) loop
      execute immediate 'alter table '||rs.table_name||' allocate extent';
    end loop;
  exception
    when others then
      dbms_output.put_line('errm distribExtent:'||sqlerrm);
  end distribExtent;

  /** 将某张表中指定字段更改为特定数据类型
  * 参数：
  * tableName 需要操作的表
  * primKeyName 需要操作的表的主键名
  * changeFieldName 需要操作的字段
  * toType 操作的字段需要转换成的数据类型
  **/
  procedure changeDataType(tableName varchar2,
    primKeyName varchar2,
    changeFieldName varchar2,
    toType varchar2
  ) as
    bakFieldSelectStr varchar2(300); --需要转换的字段在插入临时表时的查询字符串
  begin
    --创建临时表
    execute immediate
    'create table temp_table(
       '||primKeyName||' number,'
       ||changeFieldName||' '||toType
    ||')';

    --把数据插到临时表中
    if toType = 'date' then --日期类型
      bakFieldSelectStr:='to_date(pe.'||changeFieldName||',''yyyy-mm-dd'')';
    else --普通类型
      bakFieldSelectStr:='pe.'||changeFieldName;
    end if;

    execute immediate
    'insert into temp_table('||primKeyName||', '||changeFieldName||')
    select pe.'||primKeyName||','||bakFieldSelectStr||' from '||tableName||' pe';

    --删除原有表的数据
    execute immediate
    'update '||tableName||' set '||changeFieldName||' = null';

    --修改原有表的数据类型
    execute immediate 'alter table '||tableName||' modify '||changeFieldName||' '||toType;

    --修改原有表的数据
    execute immediate
    'update '||tableName||' pe set (pe.'||changeFieldName||') =
    (select tt.'||changeFieldName||' from temp_table tt where tt.'||primKeyName||' = pe.'||primKeyName||')';

    commit;

    --删除临时表
    execute immediate 'drop table temp_table';
  end changeDataType;

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

---初始化操作
begin
  initialize;
end myutil_pkg;