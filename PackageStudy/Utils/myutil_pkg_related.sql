-- 学生信息表
create table t_student(
       l_id number,
       vc_name varchar2(100),
       d_birthday date,
       vc_insert_user varchar2(100),
       vc_update_user varchar2(100),
       d_insert_time date,
       d_update_time date,
       vc_remark varchar2(200)
);

comment on table t_student
  is '学生信息表';
comment on column t_student.l_id is 'id';
comment on column t_student.vc_name is '姓名';
comment on column t_student.d_birthday is '出生日期';
comment on column t_student.vc_insert_user is '录入人';
comment on column t_student.vc_update_user is '更新人';
comment on column t_student.d_insert_time is '录入时间';
comment on column t_student.d_update_time is '更新时间';
comment on column t_student.vc_remark is '备注';

-- 数据字典表
create table t_dict
(
  vc_cde       VARCHAR2(50),
  vc_nme       VARCHAR2(100),
  vc_ord       VARCHAR2(10),
  vc_type      VARCHAR2(50),
  vc_type_name VARCHAR2(100),
  vc_remark    VARCHAR2(200)
);
comment on table t_dict
  is '数据字典表';
comment on column t_dict.vc_cde
  is '编码';
comment on column t_dict.vc_nme
  is '名称';
comment on column t_dict.vc_ord
  is '排序';
comment on column t_dict.vc_type
  is '类型';
comment on column t_dict.vc_type_name
  is '类型对应的中文意思';
comment on column t_dict.vc_remark
  is '备注';

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('1', '外部文档', '1', 'docType', '文档类型', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('2', '内部文档', '2', 'docType', '文档类型', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('1', '男', '1', 'sex', '性别', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('2', '女', '2', 'sex', '性别', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('1', '日报', '1', 'reportType', '报告类型', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('2', '月报', '2', 'reportType', '报告类型', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('3', '季报', '3', 'reportType', '报告类型', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('4', '年报', '4', 'reportType', '报告类型', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('1', '人民币', '1', 'currency', '币种', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('2', '美元', '2', 'currency', '币种', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('1', '30岁以下', '1', 'ageSituation', '年龄情况', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('2', '30-45岁以下', '2', 'ageSituation', '年龄情况', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('3', '45-65岁以下', '3', 'ageSituation', '年龄情况', null);

insert into t_dict (VC_CDE, VC_NME, VC_ORD, VC_TYPE, VC_TYPE_NAME, VC_REMARK)
values ('4', '65岁及以上', '4', 'ageSituation', '年龄情况', null);