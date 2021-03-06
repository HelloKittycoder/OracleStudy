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

  -- 下拉类型记录
  type dict_tab is table of t_dict%rowtype;
  type simple_dict_record is record(vc_cde t_dict.vc_cde%type,
                                   vc_nme t_dict.vc_nme%type,
                                   vc_type t_dict.vc_type%type,
                                   vc_type_name t_dict.vc_type_name%type);
  type simple_dict_tab is table of simple_dict_record;

  type v_dict_type_arr is varray(100) of varchar2(20);
  dictTypeArr v_dict_type_arr:=v_dict_type_arr(null);

  -- 定义通用的字符串数组参数类型（传入或返回参数）
  type tab_str is table of varchar(30);

  --------------------------------------初始化方法---------------------------------
  procedure initialize;

  --------------------------------------edim相关操作start---------------------------------
  /**
  * 根据类型查询对应的下拉选项值
  **/
  --使用示例：
  /*
  select * from table(myutil_pkg.find_dict('sex'));
  select * from table(myutil_pkg.find_dict('2'));
  */
  function find_dict(vc_dict_type varchar2) return dict_tab pipelined;

  --使用示例：
  /*
  select * from table(myutil_pkg.find_sdict('sex'));
  select * from table(myutil_pkg.find_sdict('2'));
  */
  function find_sdict(vc_dict_type varchar2) return simple_dict_tab pipelined;

  --------------------------------------edim相关操作end---------------------------------

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

  /**
  * 返回指定字符串的md5加密结果
  * 使用示例：select myutil_pkg.md5('888888') from dual; -- 21218cca77804d2ba1922c33e0151105
  * select myutil_pkg.md5('zhangsan') from dual; -- 01d7f40760960e7bd9443513f22ab9af
  **/
  function md5(input_str in varchar2) return varchar2;

  /**
  * 计算时间差（年y，月M，日d，时h，分m，秒s）
  **/
  /*
  使用示例：计算当前时间距离2018年4月1日的天数差
  select myutil_pkg.time_diff(sysdate, to_date('2018-04-01','yyyy-MM-dd'), 'd') from dual;
  */
  function time_diff(param_date1 in date, param_date2 in date, var_options in varchar2) return number;

  --------------------------------------工具procedure---------------------------------
  /**
  * 将序列的当前值恢复至指定数字
  * seqName 序列名称
  * num 需要恢复到哪个数字
  **/
  --使用示例：
  /**
  * begin
  *   myutil_pkg.updateSeqToNum('seq_mytest',1);
  * end;
  *
  * 运行select seq_mytest.currval from dual;可以进行验证
  */
  procedure updateSeqToNum(seqName varchar2, num number);

  /**
  * 批量创建序列
  * seqNames 序列名称数组
  **/
  --使用示例：
  /*
  declare
    seqNames myutil_pkg.tab_str:=myutil_pkg.tab_str(null);
  begin
    seqNames.extend(2,1);
    seqNames(1):='seq_mytest1';
    seqNames(2):='seq_mytest2';
    seqNames(3):='seq_mytest3';
    myutil_pkg.createSeqs(seqNames);
  end;
  */
  procedure createSeqs(seqNames tab_str);

  /**
  * 批量删除序列
  * seqNames 序列名称数组
  **/
  --使用示例：
  /*
  declare
    seqNames myutil_pkg.tab_str:=myutil_pkg.tab_str(null);
  begin
    seqNames.extend(2,1);
    seqNames(1):='seq_mytest1';
    seqNames(2):='seq_mytest2';
    seqNames(3):='seq_mytest3';
    myutil_pkg.dropSeqs(seqNames);
  end;
  */
  procedure dropSeqs(seqNames tab_str);

  /**
  * 刷新user_tables中的统计数据
  * 解决user_tables中num_rows查不出来的问题
  **/
  --使用示例：
  /**
  * begin
  *   myutil_pkg.statistics_all_tab;
  * end;
  *
  * 可以用 select * from table(myutil_pkg.tab_status);
  * 验证刷新统计数据操作是否成功
  */
  procedure statistics_all_tab;

  /**
  * 给需要做导出操作的数据库，其中的空表分配空间（如果空表没有分配空间的话）
  **/
  /**
  * begin
  *   myutil_pkg.distribExtent;
  * end;
  */
  procedure distribExtent;

  /** 将某张表中指定字段更改为特定数据类型
  * 参数：
  * tableName 需要操作的表
  * primKeyName 需要操作的表的主键名
  * changeFieldName 需要操作的字段
  * toType 操作的字段需要转换成的数据类型
  **/
  /**
  * 把mytest表中的sbirthday字段改成date类型，smoney字段改成number类型
  * begin
  *   myutil_pkg.changeDataType('mytest','sid','sbirthday','date');
  *   myutil_pkg.changeDataType('mytest','sid','smoney','number');
  * end;
  */
  procedure changeDataType(tableName varchar2,
    primKeyName varchar2,
    changeFieldName varchar2,
    toType varchar2
  );

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