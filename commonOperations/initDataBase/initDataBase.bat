rem 连接本地数据库（用户名--jbit 密码--jbit  sid--orcl  主机名--localhost 端口号--1521），并执行sql
rem 完整写法  sqlplus "jbit/jbit@localhost:1521/orcl" @initDataBase.sql  下面是简便写法
sqlplus "jbit/jbit@orcl" @initDataBase.sql

rem 连接远程数据库（用户名--invest_jbit 密码--invest_jbit  sid--orcl  主机名--192.168.1.200 端口号--1521），并执行sql
rem sqlplus "invest_jbit/invest_jbit@192.168.1.200:1521/orcl" @initDataBase.sql
pause
