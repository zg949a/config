CREATE DATABASE StudScore_DB;

SELECT * FROM studscoreinfo;
SELECT * FROM studinfo;
SELECT * FROM courseinfo;
SELECT * FROM classinfo;

#清空数据
#DELETE FROM studinfo;
#DELETE FROM studscoreinfo;
#DELETE FROM classinfo;
#DELETE FROM courseinfo;
#删除表
DROP TABLE chinesestudinfo;

Drop Table studinfo
CREATE TABLE StudInfo(
	StudNo VARCHAR(15) PRIMARY KEY COMMENT '学号',
	StudName VARCHAR(20) NOT NULL COMMENT '姓名',
	StudGender CHAR(2) NOT NULL COMMENT '性别' DEFAULT '男'
		CHECK (StudGender IN ('男','女')) DEFAULT '男',
	StudBirthday DATE NULL COMMENT '生日',
	ClassID VARCHAR(10) NOT NULL COMMENT '班级编号',
		CONSTRAINT FOREIGN KEY(ClassID)
		REFERENCES ClassInfo(ClassID)
);
ENGINE=INNODB DEFAULT CHARSET=utf8;

drop table classinfo
CREATE TABLE ClassInfo(
	ClassID VARCHAR(10) PRIMARY KEY COMMENT '班级编号',
	ClassName VARCHAR(50) NOT NULL COMMENT '班级名称',
	ClassDesc VARCHAR(100) NULL COMMENT '班级描述'

);
ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE CourseInfo(
	CourseID VARCHAR(15) PRIMARY KEY COMMENT '课程编号',
	CourseName VARCHAR(50) NOT NULL COMMENT '课程名称',
	CourseType VARCHAR(10) NOT NULL COMMENT '课程类别',
	CourseCredit DECIMAL(3,1) NOT NULL COMMENT '课程学分',
	CourseDesc VARCHAR(100) NULL COMMENT '课程评价'
	);
ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE STUDSCOREINFO
CREATE TABLE StudScoreInfo(
	StudNo VARCHAR(15) COMMENT '学号',
	CourseID VARCHAR(15)  COMMENT '课程编号',
	StudScore DECIMAL(4,1) NOT NULL CHECK (StudScore>=0 and StudScore<=100) COMMENT '学生成绩',
		#CHECK (StudScore IN(StudScore>=0 and StudScore<=100)),
		PRIMARY KEY (STUDNO,COURSEID)
		#CONSTRAINT PRIMARY KEY(StudNo,CourseID)
	);
ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO studinfo VALUES('20191152001','黄华','男','2000-01-01','20191152');
INSERT INTO studinfo VALUES('20191152002','朱江','男','1999-08-19','20191152');
INSERT INTO studinfo VALUES('20191152003','李四','女','2000-02-20','20191152');
INSERT INTO studinfo VALUES('20191152004','刘强','男','2000-03-04','20191152');
INSERT INTO studinfo VALUES('20191152005','张三','女','2000-04-07','20191152');

INSERT INTO classinfo VALUES('20191152','computer2019','very good');
INSERT INTO classinfo VALUES('20201152','computer2020','that’s right');

INSERT INTO studscoreinfo VALUES('20191152001','A000004','75.0');
INSERT INTO studscoreinfo VALUES('20191152001','A010001','66.0');
INSERT INTO studscoreinfo VALUES('20191152001','A010012','71.0');
INSERT INTO studscoreinfo VALUES('20191152002','A000001','80.0');
INSERT INTO studscoreinfo VALUES('20191152002','A000004','85.0');

UPDATE studscoreinfo 
SET StudScore='82'
WHERE StudNo='20191152001' AND CourseID='A010001';

UPDATE studinfo 
SET StudName='刘刚',StudGender='女',ClassID='20201152'
WHERE StudNo='20191152004';

DELETE FROM studinfo 
WHERE StudNo='20191152005';

SELECT * 
FROM studinfo 
WHERE StudNo='20191152003';

###############################################

SELECT *
FROM studinfo LIMIT 0,10;


SELECT *
FROM studscoreinfo
ORDER BY StudScore DESC 
LIMIT 0,100;

#查询重名方法1：
SELECT * ,
	COUNT(*) StudName
FROM studinfo
GROUP BY StudName;
#查询重名方法2：
SELECT DISTINCT *
FROM studinfo
GROUP BY StudName;

CREATE TABLE chinesestudinfo
AS
SELECT StudName AS 姓名,
			 StudNo AS 学号,
			 StudGender AS 性别,
			 ClassID AS 班级编号
FROM studinfo;

SELECT *
FROM studscoreinfo
WHERE StudNo='20191152001';

SELECT *
FROM studscoreinfo
WHERE studno='20191152001' AND studscore>80;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE
BETWEEN 80 AND 90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE>=80 AND STUDSCORE<=90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE
NOT BETWEEN 80 AND 90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE<80 OR STUDSCORE>90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE
BETWEEN 60 AND 70
OR STUDSCORE
BETWEEN 80 AND 90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE>=80 AND STUDSCORE<=90
OR STUDSCORE>=60 AND STUDSCORE<=70;

SELECT *
FROM COURSEINFO
WHERE COURSENAME
LIKE '计算机%';

SELECT *
FROM studinfo
WHERE StudName
LIKE '%丽%';

SELECT *
FROM studinfo
WHERE StudName
LIKE '__丽';

#不及格人数
SELECT StudNo,
			 COUNT(*) countscore
FROM studscoreinfo
WHERE StudScore<60
GROUP BY StudNo
HAVING COUNT(*)>20;

#计算平均分
SELECT  StudNo, 
			  AVG(StudScore) AS 平均分
FROM studscoreinfo
GROUP BY StudNo;

#总分加课程门数
SELECT StudNo,
			 AVG(StudScore),
			 SUM(StudScore),
		   COUNT(*) count
FROM studscoreinfo
GROUP BY StudNo;

#多表查询
SELECT studinfo.StudNo,
			 StudName,
			 StudScore,
			 ClassID
FROM studinfo,
		 studscoreinfo;

SELECT studinfo.StudNo,
			 studinfo.StudName,
			 classinfo.ClassID,
			 classinfo.ClassName,
			 courseinfo.CourseID,
			 courseinfo.CourseName,
			 studscoreinfo.StudScore
FROM studinfo,
		 studscoreinfo,
		 classinfo,
		 courseinfo;
		 
SELECT studinfo.StudNo,
			 studinfo.StudName,
			 studinfo.StudGender,
			 studscoreinfo.StudScore
FROM studinfo,
		 studscoreinfo
WHERE studinfo.StudGender='女';

#单条筛选
SELECT StudNo,
		   SUM(StudScore),
			 AVG(StudScore),
			 COUNT(*) CourseID
FROM studscoreinfo
WHERE StudNo = '20180712001';

SELECT studinfo.*,
			 studscoreinfo.*,
			 AVG(studscoreinfo.StudScore) 平均分,
		   COUNT(*) 课程门数
FROM studscoreinfo,
		 studinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
GROUP BY studscoreinfo.StudNo,studinfo.StudName
HAVING 课程门数>10 AND AVG(studscoreinfo.StudScore)>=75 AND AVG(studscoreinfo.StudScore)<=80
#IN子句查询
SELECT *
FROM studinfo
WHERE StudNo IN(SELECT StudNo
						 FROM studscoreinfo
						 GROUP BY StudNo
			       HAVING COUNT(*)>10 AND AVG(StudScore)>=75 AND AVG(StudScore)<=80);

#选择平均分最高的前10人：
SELECT studinfo.*,
			 AVG(studscoreinfo.StudScore) 平均分,
			 COUNT(*) 课程门数,
			 MAX(studscoreinfo.StudScore) 最高分,
			 MIN(studscoreinfo.StudScore) 最低分
FROM classinfo,
		 studinfo,
		 studscoreinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
AND studinfo.ClassID=classinfo.ClassID
GROUP BY studinfo.StudNo
ORDER BY 平均分 DESC
LIMIT 0,10;

SELECT studinfo.StudNo 学号,
			 studinfo.StudName 姓名,
			 AVG(studscoreinfo.StudScore) 平均分,
			 COUNT(*) 课程门数,
			 MAX(studscoreinfo.StudScore) 最高分,
			 MIN(studscoreinfo.StudScore) 最低分
FROM studinfo,
		 studscoreinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
GROUP BY studscoreinfo.StudNo
ORDER BY 平均分 DESC;

SELECT studscoreinfo.StudNo,
			 courseinfo.CourseName 课程名称, 
			 AVG(studscoreinfo.StudScore) 平均分,
			 MAX(studscoreinfo.StudScore) 最高分,
			 MIN(studscoreinfo.StudScore) 最低分,
			 COUNT(*) 所修人数
FROM courseinfo,
		 studscoreinfo
WHERE courseinfo.CourseID=studscoreinfo.CourseID
GROUP BY studscoreinfo.CourseID
ORDER BY 平均分 DESC;

CREATE TABLE StudCourseScoreInfo
AS
SELECT studscoreinfo.StudNo,
			 courseinfo.CourseName 课程名称, 
			 AVG(studscoreinfo.StudScore) 平均分,
			 MAX(studscoreinfo.StudScore) 最高分,
			 MIN(studscoreinfo.StudScore) 最低分,
			 COUNT(*) 所修人数
FROM courseinfo,
		 studscoreinfo
WHERE courseinfo.CourseID=studscoreinfo.CourseID
GROUP BY studscoreinfo.CourseID
ORDER BY 平均分 DESC;

SELECT *
FROM studinfo 
WHERE StudNo IN(SELECT StudNo
						 FROM studinfo
						 GROUP BY StudName
						 HAVING COUNT(*)>1);
					
#####################################
SELECT *
FROM studscoreinfo
WHERE StudScore BETWEEN 80 AND 90
UNION ALL
SELECT *
FROM studscoreinfo
WHERE StudScore BETWEEN 60 AND 70;

SELECT StudNo,
			 AVG(StudScore),
			 SUM(StudScore),
			 COUNT(*),
			 MAX(StudScore),
			 MIN(StudScore)
FROM studscoreinfo
GROUP BY StudNo;

SELECT StudNo,
			 AVG(StudScore),
			 SUM(StudScore),
			 COUNT(*),
			 MAX(StudScore),
			 MIN(StudScore)
FROM studscoreinfo
GROUP BY StudNo
HAVING AVG(StudScore) BETWEEN 60 AND 70;

SELECT studinfo.StudNo,
			 studinfo.StudName,
  		 AVG(StudScore),
			 SUM(StudScore),
			 COUNT(*),
			 MAX(StudScore),
			 MIN(StudScore)
FROM studscoreinfo,
		 studinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
GROUP BY studscoreinfo.StudNo
HAVING AVG(StudScore) BETWEEN 90 AND 100
OR AVG(StudScore) BETWEEN 60 AND 70;

#关联表查询
SELECT studinfo.*,
  		 AVG(StudScore)
FROM studscoreinfo,
		 studinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
GROUP BY studscoreinfo.StudNo
HAVING AVG(StudScore)>=80 AND StudGender='女';
#IN子句查询
SELECT *
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore)>=80)
HAVING StudGender='女';

#统计个分数段的人数
SELECT '优秀' 等级, COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore) BETWEEN 90 AND 100)
UNION
SELECT '良好',COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore) BETWEEN 80 AND 90)
UNION
SELECT '一般',COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore) BETWEEN 70 AND 80)
UNION
SELECT '及格',COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore) BETWEEN 60 AND 70)
UNION
SELECT '不及格',COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore)<60);

SELECT STUDNO,STUDNAME,STUDGENDER,CLASSINFO.ClassName
FROM studinfo,Classinfo
WHERE STUDINFO.ClassID=CLASSINFO.ClassID
AND StudNo IN(
			SELECT studno
			FROM studscoreinfo
			WHERE studscore<60
			GROUP BY studno
			HAVING count(*)>10
			);

/*课程类别为 A、B、C、D11、D12 为基础课和专业课，即统称为学位课，请统计
“计科 2019”班的各学生学位课的平均分、总分、所修课程的数目、最高分、最低分*/
SELECT StudNo,
			 AVG(StudScore),
			 SUM(StudScore),
			 COUNT(*),
			 MAX(StudScore),
			 MIN(StudScore)
FROM studscoreinfo
WHERE courseid IN (
			SELECT courseid
			FROM courseinfo
			WHERE coursetype='A' OR coursetype='B'OR coursetype='C'OR coursetype='D11'OR coursetype='C12')
GROUP BY studno
HAVING studno IN (
			SELECT studno
			FROM studinfo,classinfo
			WHERE studinfo.ClassID=classinfo.ClassID AND classname='计科2019');


SELECT studscoreinfo.courseid,coursename,AVG(studscore),COUNT(*) 参考人数
FROM studscoreinfo,courseinfo
WHERE studscoreinfo.CourseID=courseinfo.CourseID
GROUP BY courseid
HAVING AVG(studscore)>80 AND COUNT(*)>30;

#统计课程成绩在 80 分以上的各学生平均分的 SQL 语句
SELECT studscoreinfo.studno,studinfo.StudName,courseid AS 80分以上课程,AVG(studscore) 80分以上课程学生平均分
FROM studscoreinfo,studinfo
WHERE studscoreinfo.StudNo=studinfo.StudNo
AND courseid IN (
			SELECT studscoreinfo.courseid
			FROM studscoreinfo,courseinfo
			WHERE studscoreinfo.CourseID=courseinfo.CourseID
			GROUP BY courseid
			HAVING AVG(studscore)>80)
GROUP BY studscoreinfo.studNo;

##################################
SELECT s.studno,
		   studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo AS s INNER JOIN studscoreinfo si 
ON s.studno=si.studno;
#左连接
SELECT s.studno,
			 studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo s LEFT JOIN studscoreinfo si 
ON s.studno=si.studno;
#右连接
SELECT s.studno,
			 studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo s RIGHT JOIN studscoreinfo si 
ON s.studno=si.studno;
#全连接
SELECT s.studno,
			 studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo s LEFT JOIN studscoreinfo si 
ON s.studno=si.studno;
UNION 
SELECT s.studno,
			 studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo s RIGHT JOIN studscoreinfo si 
ON s.studno=si.studno;


SELECT c.courseid,
			 c.coursename,
			 sum(studscore),
			 round(avg(studscore),2),
			 max(studscore),
			 min(studscore),
			 count(*)
FROM courseinfo c INNER JOIN studscoreinfo si 
ON c.courseid=si.courseid
GROUP BY courseid;


SHOW CREATE VIEW V_GetCourseScore
AS
SELECT c.courseid,
			 c.coursename,
			 sum(studscore),
			 round(avg(studscore),2),
			 max(studscore),
			 min(studscore),
			 count(*) 
FROM courseinfo c INNER JOIN studscoreinfo si 
ON c.courseid=si.courseid
GROUP BY courseid;
SELECT *
FROM v_getcoursescore
WHERE coursescore>=30 AND coursescore<=50;
#DESC V_GETCOURSESCORE


CREATE VIEW V_GetAllStudInfo
AS
SELECT s.studno,
			 studname,
			 s.studgender,
			 s.classid,
			 c.classname,
			 ci.coursename,
			 ci.courseid,
			 si.studscore
FROM studinfo s INNER JOIN studscoreinfo si 
ON s.studno=si.studno
INNER JOIN classinfo c 
ON s.classid=c.classid 
INNER JOIN courseinfo ci
ON ci.courseid=si.courseid 
GROUP BY studno,
				 courseid,
				 classid;

SELECT *
FROM v_getallstudinfo


SELECT s.studno,
			 studname,
			 studgender,
			 sum(si.studscore),
			 max(si.studscore),
			 min(si.studscore),
			 avg(si.studscore),
			 count(*)
FROM studinfo s INNER JOIN studscoreinfo si 
ON s.studno=si.studno 
GROUP BY studno;


CREATE VIEW V_StudAvgScore
AS
SELECT s.studno,
			 studname,
			 avg(studscore),
			 sum(studscore),
			 max(studscore),
			 min(studscore),
			 count(*)
FROM studinfo s INNER JOIN studscoreinfo si 
ON s.studno=si.studno 
GROUP BY studno;


SELECT s.studno,
			 s.studname,
			 s.`avg(studscore)`,
			 count(*),
			 a.classname
FROM v_studavgscore s INNER JOIN v_getallstudinfo a
ON s.studno=a.studno
WHERE (s.`avg(studscore)` BETWEEN 60 AND 70) OR (s.`avg(studscore)` BETWEEN 80 AND 85)
GROUP BY s.studno;


SELECT s.studno,
			 s.studname,
			 avg(studscore),
       a.studgender,
			 si.studbirthday,
       a.classname
FROM v_studavgscore s  INNER JOIN v_getallstudinfo a
ON s.studno=a.studno
INNER JOIN studinfo si ON si.studno=s.studno
WHERE S.`avg(studscore)` > 80
GROUP BY S.studno

#############################################
CREATE PROCEDURE proc_IF()
BEGIN
	Declare I int;
	Set I=5;
	If I>5 then
		set I=I*2;
	else
		set I=I mod 2;
	END if;
	select I;
end;
call proc_if;


create procedure proc_while()
BEGIN
		Declare I int;
		declare Result Int;
		Set I=3;
		Set Result=10;
		While I<Result do
				Set I=I+Result mod 3;
				Set Result=Result-I mod 4;
		End while;
		Set I=I+Result;
		select I;
end;
call proc_while;


create procedure proc_while2()
BEGIN
	  Declare I int;
    Declare Result Int;
		Set I=0;
		Set Result=2;
		While i<3 do
				Set Result=Result+Power(i,i);
				set i=i+1;
		end while;
		select Result;
end;
call proc_while2;

create procedure proc_while3()
BEGIN
		Declare I int;
		Declare Result Int;
		Set I=3;
		Set Result=2;
		While i>0 do
				Set Result=Result+Power(2,i)-1;
				set i=i-1;
		end while;
		select Result;
end;
call proc_while3;

create procedure proc_case()
BEGIN
		Declare I int;
		declare Result int;
		declare MyStr varchar(10);
		set I=LOCATE('BC','ABCCBBCDA',3);
		Set Result=I mod 4;
		Case Result
				When 1 then set MyStr= Substring('ABCD',2,Result);
				When 2 then set MyStr= Substring('ABCD',Result,2);
				When 3 then set MyStr= Substring('ABCD',Result-1,2);
				else
						set mystr= 'No';
		End case;
		select Result ;
		select MyStr;
end;
call proc_case;

#7.2
DELIMITER&&
DROP PROCEDURE IF EXISTS PROC_PRINTF;
CREATE PROCEDURE proc_printf()
BEGIN
		DECLARE I INT DEFAULT 65;
		DECLARE R VARCHAR(100);
		WHILE I < 65+26 DO
				IF R IS NULL THEN
						SET R=CHAR(I);
				ELSE
						SET R=CONCAT_WS(',',R,CHAR(I));
				END IF;
				SET I=I+1;
		END WHILE;
		SELECT R;
END&&
CALL PROC_PRINTF;

#7.3
DROP PROCEDURE IF EXISTS PROC_NJ; 
CREATE PROCEDURE proc_nj(IN M INT)
BEGIN
		DECLARE i INT DEFAULT 1;
		DECLARE n INT DEFAULT 1;
		WHILE i<=M DO
						SET n=n*i;
						SET i=i+1;					
		END WHILE;
		SELECT i;
		SELECT n;
END;
CALL proc_nj(5)

#7.4
DROP PROCEDURE IF EXISTS PROC_SUMJ;
CREATE PROCEDURE PROC_SUMJ()
BEGIN
		DECLARE n INT DEFAULT 1;
		DECLARE s INT DEFAULT 1;
		DECLARE i INT DEFAULT 1;
		DECLARE k BIGINT DEFAULT 1;
		WHILE s < 10000 DO
				SET n=2*n+1;
				WHILE i<n DO
						SET @k = @k * @i;
						SET i=i+1;
				SET s=s+i;
				END WHILE;
		END WHILE;
		SELECT s;
		SELECT n;
END;
CALL PROC_SUMJ;

#7.5
DROP PROCEDURE IF EXISTS PROC_2J;
CREATE PROCEDURE PROC_2J(IN m INT)
BEGIN
		DECLARE i INT DEFAULT 1;
		DECLARE s BIGINT DEFAULT 0;
		DECLARE n BIGINT DEFAULT 2;
		WHILE i<=10 DO
				SET s=s+n;
				SET n=n*10+2;
				SET i=i+1;
		END WHILE;
		SELECT s;
END;
CALL PROC_2J(10);

#7.6
DROP PROCEDURE IF EXISTS PROC_FEN;
CREATE PROCEDURE PROC_FEN()
BEGIN
		DECLARE z INT DEFAULT 1;
		DECLARE m INT DEFAULT 1;
		DECLARE s FLOAT DEFAULT 0;
		DECLARE i INT DEFAULT 1;
		DECLARE T FLOAT;
		WHILE i<=20 DO
				SET T=z/m;
#				SELECT T;
				SET s=s+T;
				SET m=z+m;
				SET z=m-z;
				SET i=i+1;
		END WHILE;
		SELECT s;
END;
CALL PROC_FEN;

#7.7
DROP PROCEDURE IF EXISTS PROC_SSUM;
CREATE PROCEDURE PROC_SSUM(IN n INT)
BEGIN
		DECLARE i,j INT;
		DECLARE s1,s2 BIGINT;
		SET i=1,j=1,s1=0,s2=0;
		WHILE i<=n DO
				WHILE j<=i DO
						SET s2=s2+j;
						SET j=j+1;
				END WHILE;
#				SELECT s2;
				SET j=1;
				SET s1=s1+s2;
				SET i=i+1;
				SET s2=0;
		END WHILE;
		SELECT s1;
END;
CALL PROC_SSUM(20)

#7.8
DROP PROCEDURE IF EXISTS PROC_Fj;
CREATE PROCEDURE PROC_FJ(IN n INT)
BEGIN
		DECLARE i,j,k INT;
		DECLARE s1,T FLOAT;
		DECLARE z,m BIGINT;
		SET i=1,j=1,k=1,s1=0,z=1,m=1;
		WHILE i<=n DO
				SET z=2*i-1;
				SET m=2*i+1;
				WHILE j<=z DO
						SET @z=@z*@j;
						SET j=j+1;
				END WHILE;
				SET j=1;
				WHILE k<=m DO
						SET @m=@m*@k;
						SET k=k+1;
				END WHILE;
				SET k=1;
				SET T=z/m;
				SET s1=s1+T;
		END WHILE;
		SELECT s1;
END;
CALL PROC_FJ(10);

#############################################
#8.1-1
SELECT *
FROM studinfo
WHERE StudName LIKE '丽';

#8.1-2
SELECT *
FROM studinfo
WHERE RIGHT(StudName,1) = '丽' AND CHAR_LENGTH(studname)=3;

#8.2
SELECT CONCAT('牛',SUBSTRING(studname,2,10))
FROM studinfo
WHERE LEFT(StudName,1) = '刘';

#8.3
SELECT *
FROM studinfo
WHERE StudName IN (
		SELECT StudName
		FROM studinfo
		GROUP BY StudName,StudGender
		HAVING count(*)>1
		); 

#8.4
SELECT year(StudBirthDay),month(StudBirthDay),count(*) 
FROM studinfo
WHERE StudBirthDay IS NOT NULL
GROUP BY year(StudBirthDay),month(StudBirthDay)
HAVING count(*)>1;

#8.5
SELECT *
FROM studinfo
WHERE CONCAT(StudBirthDay,StudGender) IN (			
		SELECT concat(StudBirthDay,StudGender) 
		FROM studinfo
		WHERE StudBirthDay IS NOT	NULL
		GROUP BY StudGender,StudBirthDay
		HAVING count(*)>1
		);

#8.6
SELECT studinfo.StudNo,StudName,studscore
FROM studinfo INNER JOIN studscoreinfo
ON studinfo.StudNo=studscoreinfo.StudNo
WHERE StudBirthDay IS NULL ;

#8.7
SELECT studscoreinfo.StudNo,avg(studscore)
FROM studscoreinfo INNER JOIN studinfo
ON studscoreinfo.StudNo=studinfo.StudNo
WHERE LEFT(StudName,1) = '王' 
GROUP BY StudNo
HAVING 	avg(studscore)>	(
		SELECT avg(studscore)
		FROM studscoreinfo INNER JOIN studinfo
		ON studscoreinfo.StudNo=studinfo.StudNo
		WHERE LEFT(StudName,1) = '李'
		GROUP BY studinfo.StudNo
		ORDER BY avg(studscore) DESC
		LIMIT 1
		);

#8.8
SELECT StudNo,StudGender,StudName,
		CASE StudGender
	WHEN '男' THEN 'Male'
	WHEN '女' THEN 'Fsmale'
	  ELSE 'NOt'
END AS 学生性别
FROM studinfo;

#8.9
SELECT StudNo,sum(studscore),max(studscore),min(studscore),count(*),
	CASE WHEN(count(*)>20) 
		THEN (sum(Studscore)-max(studscore)-min(studscore))/(count(*)-2)
		ELSE avg(studscore)
END AS 'avgscore'
FROM studscoreinfo
GROUP BY StudNo;

#8.10
SELECT StudNo,AVG(StudScore),
	CASE WHEN AVG(StudScore) BETWEEN 90 and 100 THEN '优秀'
		WHEN AVG(StudScore) BETWEEN 80 and 90 THEN '良好'
		WHEN AVG(StudScore) BETWEEN 70 and 80 THEN '一般'
		WHEN AVG(StudScore) BETWEEN 60 and 70 THEN '及格'
		ELSE '不及格'
END AS 成绩等级
FROM studscoreinfo
GROUP BY studno;

#8.11
#SET GLOBAL log_bin_trust_function_creators=1
#DROP FUNCTION GetItemScore
CREATE FUNCTION GetItemScore(Stand_Ans VARCHAR(10),Custor_Ans VARCHAR(10))
RETURNS INT
BEGIN
		DECLARE i INT DEFAULT 1;
		IF CHAR_LENGTH(Custor_Ans)>CHAR_LENGTH(Stand_Ans)
			OR Custor_Ans IS NULL THEN
			RETURN 0;
		END IF;
		WHILE i<=CHAR_LENGTH(Custor_Ans) DO
			IF locate(SubString(Custor_Ans,i,1),Stand_Ans)<1
				THEN RETURN i-1;
			END IF;
			SET i=i+1;
		END WHILE;
		RETURN CHAR_LENGTH(Custor_ans);
END;
#SELECT GetItemScore('AB','AC')

#8.12
SELECT StudNo,
CAST(SUM(GetItemScore(Stand_Ans,Custor_Ans))*100/SUM(CHAR_LENGTH
(Stand_Ans))
as Decimal(3,1)) As StudScore
FROM TestAnswer
GROUP BY StudNo ORDER BY StudScore DESC

#8.13
CREATE VIEW V_GetStudScore
AS
SELECT StudNo,
     CAST(SUM(GetItemScore(Stand_Ans,Custor_Ans))*100/SUM(CHAR_LENGTH(Stand_Ans))
as Decimal(3,1)) As StudScore
FROM TestAnswer
GROUP BY StudNo 
ORDER BY StudScore DESC;
SELECT *
from V_GetStudScore;

#8.14
UPDATE v_GetStudScore JOIN studscore
ON v_GetStudScore.StudNo=studscore.StudNo
SET studscore.StudScore=v_GetStudScore.StudScore;
SELECT * FROM StudScore;

#8.15
CREATE TABLE Top20StudScore
AS
SELECT v_GetStudScore.StudNo,StudName,v_GetStudScore.StudScore
FROM v_GetStudScore INNER JOIN studscore
ON v_GetStudScore.StudNo=StudScore.StudNo
ORDER BY studscore desc
LIMIT 20;
SELECT * FROM Top20StudScore;

#############################################
#9.1
DELIMITER //
DROP PROCEDURE IF EXISTS PROGETA_Z;
CREATE PROCEDURE PROGETA_Z()
BEGIN 
		DECLARE I INT DEFAULT 65;
		DECLARE K VARCHAR(100);
		WHILE I<65+26 DO 
			IF K IS NULL THEN 
				SET K=CHAR(I);
			ELSE 
				SET K=CONCAT_WS(',',K,CHAR(I));
			END IF;
			SET I=I+1;
		END WHILE;
		SELECT K;
END //;
DELIMITER;
CALL PROGETA_Z;

#9.2
delimiter $$
DROP PROCEDURE IF EXISTS procSJ;
CREATE PROCEDURE  procSJ()
BEGIN
		DECLARE n INT DEFAULT 1;
		DECLARE s INT DEFAULT 1;
		DECLARE i INT DEFAULT 1;
		DECLARE k bigint default 1;
    WHILE s < 10000 do
        SET n=2*n+1;
				WHILE i<n do
						SET @k = @k * @i;
						SET i=i+1;
						SET s=s+i;
				END WHILE;
		END WHILE;
		SELECT s;
		SELECT n;
END $$;
delimiter;
call procSJ;

#9.3
DELIMITER $$
DROP PROCEDURE IF EXISTS CS;
CREATE PROCEDURE CS(IN n INT,IN m INT)
BEGIN 
		SELECT studinfo.StudNo,studinfo.StudName,AVG(studscore),count(*)
		FROM studinfo INNER JOIN studscoreinfo
		ON studinfo.StudNo = studscoreinfo.StudNo
		GROUP BY StudNo
		HAVING AVG(studscore) BETWEEN n AND m;		
END $$;
DELIMITER;
CALL CS(75,80);

#9.4
DELIMITER $$
DROP PROCEDURE IF EXISTS InDOut;
CREATE PROCEDURE InDout(IN N INT,IN M INT,OUT R INT)
BEGIN
		SELECT COUNT(*)
		FROM (
		SELECT studinfo.studno
		FROM studinfo INNER JOIN studscoreinfo
		ON studinfo.StudNo = studscoreinfo.StudNo
		GROUP BY studscoreinfo.StudNo
		HAVING AVG(studscore) BETWEEN n AND m)  as a;
		SET R=count(*);
END $$;
delimiter;
CALL indout(75,80,@R);
		
#9.5
delimiter //
DROP PROCEDURE IF EXISTS gkc_xs_tg;
CREATE PROCEDURE gkc_xs_tg()
BEGIN
		SELECT s.StudNo,c.CourseType,s.StudName,COUNT(*),SUM(CourseCredit)
		FROM courseinfo c,studinfo s,studscoreinfo sc
		WHERE sc.StudNo=s.StudNo AND c.CourseID=sc.CourseID AND s.StudNo IN(
				SELECT StudNo
				FROM studinfo) 
				AND c.CourseType in ('A','B','C','D11','D12') AND sc.StudScore>60
				GROUP BY s.StudNo
				ORDER BY s.StudName,c.CourseType;
END //;
delimiter;
call gkc_xs_tg();

#9.6 
CREATE TRIGGER TrigStudInfo_DELETE
AFTER DELETE ON StudInfo
FOR EACH ROW
BEGIN 
		UPDATE STUDSCOREINFO SI 
		SET SI.STUDNO=STUDNO-1
		WHERE SI.COURSEID=old.COURSEID 
		AND SI.STUDSCORE=OLD.STUDSCORE;
END;

#9.7
CREATE TRIGGER TrigStudInfo_UPDATE 
AFTER INSERT ON StudInfo
FOR EACH ROW
BEGIN 
UPDATE STUDSCOREINFO SI 
SET SI.STUDNO=STUDNO+1
WHERE SI.COURSEID=NEW.COURSEID 
AND SI.STUDSCORE=NEW.STUDSCORE;
END;

#9.8
#DROP TRIGGER TrigCourseInfo_UPDATE
CREATE TRIGGER TrigCourseInfo_UPDATE
BEFORE UPDATE ON CourseInfo
FOR EACH ROW
BEGIN
		DECLARE msg varchar(200);
		IF((SELECT s.StudNo 
				FROM studscoreinfo s,courseinfo c 
				WHERE c.CourseID=s.CourseID AND c.CourseID=old.CourseID) is not NULL)
				THEN SET msg='error:该课程下有学生成绩信息';
				SIGNAL SQLSTATE 'HY000' SET message_text=msg;
		END IF;
END;

#9.9
delimiter //
DROP PROCEDURE IF EXISTS P_GetStud_same_Quene;
CREATE PROCEDURE P_GetStud_same_Quene() 
BEGIN 
		DECLARE SNo VARCHAR(20); 
		DECLARE SName VARCHAR(20); 
		DECLARE i INT DEFAULT 1; 
		DECLARE j INT DEFAULT 1; 
		DECLARE Avg_Score DECIMAL(4,1); 
		DECLARE prev_j INT DEFAULT 1; 
		DECLARE prev_score DECIMAL(4,1); 
		DECLARE have INT DEFAULT 1; 
		DECLARE Cur_StudQuene Cursor For Select StudNo,StudName,AvgScore From V_StudAvgScore Order By AvgScore DESC; 
		DECLARE exit handler for NOT FOUND SET have:= 0;
		OPEN Cur_StudQuene; 
		REPEAT 
		Fetch Cur_StudQuene INTO SNO,SName,Avg_Score; 
		IF avg_score=prev_score THEN 
				SET j=prev_j; 
		ELSE 
				SET j=i; 
		END IF; 
		SELECT SNO,SName,Avg_Score,j; 
		SET prev_j=j; 
		prev_score=avg_score; 
		SET i=i+1; 
		UNTIL have = 0 end repeat; 
		CLOSE Cur_StudQuene; 
END;
call P_GetStud_same_Quene;

#9.10 导出学生平均分成绩（保留 1 位小数），使用 Excel
 ################################
 #14.1
Drop Table studinfo2
CREATE TABLE StudInfo2(
	StudNo VARCHAR(15) PRIMARY KEY COMMENT '学号',
	StudName VARCHAR(20) NOT NULL COMMENT '姓名',
	StudSex CHAR(2) NOT NULL COMMENT '性别',
		CHECK (StudSex IN ('男','女')),
	StudBirthDay DATE NULL COMMENT '生日',
	ClassName VARCHAR(50) NOT NULL COMMENT '班级名称'
);
 
CREATE TABLE TypeInfo(
	TypeID VARCHAR(10) PRIMARY KEY COMMENT '打字类型号',
	TypeName VARCHAR(50) NOT NULL COMMENT '打字类型名称',
	TypeDesc VARCHAR(100) NULL COMMENT '打字描述'
);

CREATE TABLE StudScore2(
	StudNo VARCHAR(15) PRIMARY KEY COMMENT '学号',
	TypeID VARCHAR(10) NOT NULL COMMENT '打字类型号',
	StudScore DECIMAL(4,1) NULL 	CHECK(studScore >= 0 AND studscore <=100) COMMENT '学生成绩',
	CONSTRAINT FOREIGN KEY(StudNo)
		REFERENCES studinfo2(StudNo),
	CONSTRAINT FOREIGN KEY(TypeID)
		REFERENCES TypeInfo(TypeID)
);

#14.2

#14.3
CREATE VIEW viewStudCourseScore
AS
SELECT studinfo2.studno,studinfo2.studname,studinfo2.studsex,studinfo2.ClassName,typeinfo.TypeID,typeinfo.TypeName,StudScore
FROM studinfo2 INNER JOIN typeinfo INNER JOIN studscore2
ON studinfo2.studNo = studscore2.studNo AND typeinfo.TypeID = studscore2.TypeID;
SELECT * FROM viewStudCourseScore;

#14.4
INSERT INTO studinfo2 VALUES('20190704070','李明','男','2001-10-3','Computer');
INSERT INTO typeinfo VALUES('C0101','中文','中文输入');
INSERT INTO studscore2 VALUES('20190704070','C0101','70.5');

#14.5
UPDATE studscore2
SET studscore = '75'
WHERE StudNo = '20190704070';

#14.6
DELETE FROM typeinfo
WHERE typeID='C0101'; 

#14.7
SELECT *
FROM studscore2 
WHERE typeID='C0101'
GROUP BY STUDNO
ORDER BY STUDSCORE DESC;

#14.8
SELECT SUM(studscore)
FROM studscore2
GROUP BY studNo;

#14.9
SELECT AVG(studscore)
FROM studscore2
GROUP BY StudNo
HAVING AVG(studscore) >= 85;

#14.10
DROP TABLE StudInfoBack
CREATE TABLE StudInfoBack
AS
SELECT studinfo2.StudNo,studinfo2.StudName,studinfo2.ClassName,AVG(studscore)
FROM studscore2 INNER JOIN studinfo2
ON studinfo2.StudNo = studscore2.StudNo
GROUP BY StudNo
ORDER BY AVG(StudScore) DESC
LIMIT 1,30;

#14.11
SELECT typeinfo.TypeID,TypeName,AVG(studscore),COUNT(*),MAX(studscore),MIN(studscore)
FROM studscore2 INNER JOIN typeinfo
ON typeinfo.TypeID = studscore2.TypeID
GROUP BY StudNo;

#14.12-1
SELECT studinfo2.StudNo,studinfo2.StudName,studinfo2.ClassName,studinfo2.StudSex,AVG(studscore)
FROM studinfo2 INNER JOIN studscore2
ON studinfo2.StudNo = studscore2.StudNo
GROUP BY studscore2.StudNo
HAVING AVG(StudScore) >= 85;
#14.12-2
SELECT studno,studname,studsex,classname
FROM studinfo2
WHERE StudNo IN(
		SELECT StudNo
		FROM studscore2
		GROUP BY StudNo
		HAVING AVG(StudScore) >= 85
		);

#14.13
SELECT COUNT(*),AVG(studscore)
FROM studscore2 INNER JOIN studinfo2
ON studinfo2.StudNo = studscore2.StudNo
GROUP BY StudSex;

#14.14
CREATE VIEW V_STUDAVGSCORE 
AS
SELECT S.STUDNO,STUDNAME,
CAST(AVG(STUDSCORE) AS DECIMAL(4,1)) AS AVGSCORE
FROM studinfo2 S,studscore2 SI 
WHERE S.STUDNO=SI.STUDNO
GROUP BY S.studno;

CREATE PROCEDURE P_CY()
BEGIN
DECLARE SNO VARCHAR(15);
DECLARE SNAM VARCHAR(20);
DECLARE AVG_SCORE DECIMAL(4,1);
DECLARE HAVE INT DEFAULT 1;
DECLARE CY CURSOR FOR SELECT STUDNO,STUDNAME,AVGSCORE FROM V_STUDAVGSCORE
ORDER BY AVGSCORE DESC;
DECLARE EXIT HANDLER FOR NOT FOUND SET HAVE:=0;
OPEN CY; 
REPEAT 
FETCH CY INTO SNO,SNAM,AVG_SCORE;
UNTIL HAVE = 0 END REPEAT;
CLOSE CY;
END;