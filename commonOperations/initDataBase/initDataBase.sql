--student
-- create table
create table student
(
  sid   number,
  sname varchar2(40),
  sage  number,
  ssex  varchar2(10)
);

-- add comments to the table 
comment on table student
  is '学生表';
-- add comments to the columns 
comment on column student.sid
  is '学生编号';
comment on column student.sname
  is '学生姓名';
comment on column student.sage
  is '学生年龄';
comment on column student.ssex
  is '学生性别';

insert into student (sid, sname, sage, ssex)
values (1, '张三', 10, '男');

insert into student (sid, sname, sage, ssex)
values (2, '李四', 20, '男');

insert into student (sid, sname, sage, ssex)
values (3, '王五', 30, '男');

insert into student (sid, sname, sage, ssex)
values (4, '小红', 5, '女');

insert into student (sid, sname, sage, ssex)
values (5, '小花', 15, '女');

insert into student (sid, sname, sage, ssex)
values (6, '小凤', 22, '女');


--course
-- create table
create table course
(
  cid   number,
  cname varchar2(40),
  tid   number
);

-- add comments to the table 
comment on table course
  is '课程表';
-- add comments to the columns 
comment on column course.cid
  is '课程编号';
comment on column course.cname
  is '课程名称';
comment on column course.tid
  is '教师编号';

insert into course (cid, cname, tid)
values (301, '高等数学', 701);

insert into course (cid, cname, tid)
values (302, '线性代数', 701);

insert into course (cid, cname, tid)
values (303, '概率论', 701);

insert into course (cid, cname, tid)
values (304, '降龙十八掌', 702);

insert into course (cid, cname, tid)
values (305, '打狗棒法', 702);

insert into course (cid, cname, tid)
values (306, '降魔掌', 702);

insert into course (cid, cname, tid)
values (307, '蛙泳', 703);

insert into course (cid, cname, tid)
values (308, '仰泳', 703);

insert into course (cid, cname, tid)
values (309, '自由泳', 703);

insert into course (cid, cname, tid)
values (310, '蝶泳', 703);

--score
-- create table
create table score
(
  sid   number,
  cid   number,
  score number
);
-- add comments to the table 
comment on table score
  is '成绩表';
-- add comments to the columns 
comment on column score.sid
  is '学生编号';
comment on column score.cid
  is '课程编号';
comment on column score.score
  is '学生成绩';

insert into score (sid, cid, score)
values (1, 301, 60);

insert into score (sid, cid, score)
values (1, 302, 65);

insert into score (sid, cid, score)
values (1, 303, 70);

insert into score (sid, cid, score)
values (1, 304, 75);

insert into score (sid, cid, score)
values (2, 302, 50);

insert into score (sid, cid, score)
values (2, 303, 65);

insert into score (sid, cid, score)
values (2, 304, 70);

insert into score (sid, cid, score)
values (2, 305, 75);

insert into score (sid, cid, score)
values (3, 304, 70);

insert into score (sid, cid, score)
values (3, 305, 73);

insert into score (sid, cid, score)
values (3, 306, 80);

insert into score (sid, cid, score)
values (3, 307, 85);

insert into score (sid, cid, score)
values (3, 308, 86);

insert into score (sid, cid, score)
values (4, 307, 80);

insert into score (sid, cid, score)
values (4, 308, 85);

insert into score (sid, cid, score)
values (4, 309, 90);

insert into score (sid, cid, score)
values (4, 310, 95);

insert into score (sid, cid, score)
values (5, 301, 72);

insert into score (sid, cid, score)
values (5, 302, 75);

insert into score (sid, cid, score)
values (5, 303, 78);

insert into score (sid, cid, score)
values (5, 304, 79);

insert into score (sid, cid, score)
values (5, 305, 80);

insert into score (sid, cid, score)
values (5, 306, 84);

insert into score (sid, cid, score)
values (5, 307, 88);

insert into score (sid, cid, score)
values (5, 308, 89);

insert into score (sid, cid, score)
values (5, 309, 90);

insert into score (sid, cid, score)
values (5, 310, 97);

insert into score (sid, cid, score)
values (6, 301, 70);

insert into score (sid, cid, score)
values (6, 302, 75);

insert into score (sid, cid, score)
values (6, 303, 65);

insert into score (sid, cid, score)
values (6, 304, 60);

--teacher
-- create table
create table teacher
(
  tid   number,
  tname varchar2(40)
);

-- add comments to the table 
comment on table teacher
  is '教师表';
-- add comments to the columns 
comment on column teacher.tid
  is '教师编号';
comment on column teacher.tname
  is '教师姓名';
insert into teacher (tid, tname)
values (701, '祖冲之');

insert into teacher (tid, tname)
values (702, '乔峰');

insert into teacher (tid, tname)
values (703, '孙杨');

commit;