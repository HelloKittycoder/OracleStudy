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