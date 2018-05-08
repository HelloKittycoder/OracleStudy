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
  is 'ѧ����';
-- add comments to the columns 
comment on column student.sid
  is 'ѧ�����';
comment on column student.sname
  is 'ѧ������';
comment on column student.sage
  is 'ѧ������';
comment on column student.ssex
  is 'ѧ���Ա�';

insert into student (sid, sname, sage, ssex)
values (1, '����', 10, '��');

insert into student (sid, sname, sage, ssex)
values (2, '����', 20, '��');

insert into student (sid, sname, sage, ssex)
values (3, '����', 30, '��');

insert into student (sid, sname, sage, ssex)
values (4, 'С��', 5, 'Ů');

insert into student (sid, sname, sage, ssex)
values (5, 'С��', 15, 'Ů');

insert into student (sid, sname, sage, ssex)
values (6, 'С��', 22, 'Ů');


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
  is '�γ̱�';
-- add comments to the columns 
comment on column course.cid
  is '�γ̱��';
comment on column course.cname
  is '�γ�����';
comment on column course.tid
  is '��ʦ���';

insert into course (cid, cname, tid)
values (301, '�ߵ���ѧ', 701);

insert into course (cid, cname, tid)
values (302, '���Դ���', 701);

insert into course (cid, cname, tid)
values (303, '������', 701);

insert into course (cid, cname, tid)
values (304, '����ʮ����', 702);

insert into course (cid, cname, tid)
values (305, '�򹷰���', 702);

insert into course (cid, cname, tid)
values (306, '��ħ��', 702);

insert into course (cid, cname, tid)
values (307, '��Ӿ', 703);

insert into course (cid, cname, tid)
values (308, '��Ӿ', 703);

insert into course (cid, cname, tid)
values (309, '����Ӿ', 703);

insert into course (cid, cname, tid)
values (310, '��Ӿ', 703);

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
  is '�ɼ���';
-- add comments to the columns 
comment on column score.sid
  is 'ѧ�����';
comment on column score.cid
  is '�γ̱��';
comment on column score.score
  is 'ѧ���ɼ�';

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
  is '��ʦ��';
-- add comments to the columns 
comment on column teacher.tid
  is '��ʦ���';
comment on column teacher.tname
  is '��ʦ����';
insert into teacher (tid, tname)
values (701, '���֮');

insert into teacher (tid, tname)
values (702, '�Ƿ�');

insert into teacher (tid, tname)
values (703, '����');

commit;