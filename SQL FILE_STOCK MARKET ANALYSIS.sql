-- QUESTION 1
--  Create a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. 
-- (This has to be done for all 6 stocks)

-- BAJAJ
create view  v1 as select Date,Close_Price,avg(Close_price) 
over(rows between 19 preceding and current row) as 20DayMa from bajaj order by date asc limit 870 offset 19  ;

create view  v2 as select Date,Close_Price,avg(Close_price) 
over(rows between 49 preceding and current row) as 50DayMa from bajaj order by date asc limit 840 offset 49  ;

create table bajaj1 as select bajaj.Date,bajaj.Close_Price, 20DayMa,50DayMa from bajaj 
left join v1 on bajaj.Date=v1.Date
left join v2 on bajaj.Date=v2.Date order by date asc;


-- EICHER MOTORS
create view  EICHER_v1 as select Date,Close_Price,avg(Close_price) 
over(rows between 19 preceding and current row) as 20DayMa from EICHER order by date asc limit 870 offset 19  ;

create view  EICHER_v2 as select Date,Close_Price,avg(Close_price) 
over(rows between 49 preceding and current row) as 50DayMa from EICHER order by date asc limit 840 offset 49  ;

create table EICHER1 as select EICHER.Date,EICHER.Close_Price, 20DayMa,50DayMa from EICHER 
left join EICHER_v1 on EICHER.Date=EICHER_v1.Date
left join EICHER_v2 on EICHER.Date=EICHER_v2.Date order by date asc;


-- HERO MOTOCORP
create view  HERO_v1 as select Date,Close_Price,avg(Close_price) 
over(rows between 19 preceding and current row) as 20DayMa from HERO order by date asc limit 870 offset 19  ;

create view  HERO_v2 as select Date,Close_Price,avg(Close_price) 
over(rows between 49 preceding and current row) as 50DayMa from HERO order by date asc limit 840 offset 49  ;

create table HERO1 as select HERO.Date,HERO.Close_Price, 20DayMa,50DayMa from HERO
left join HERO_v1 on HERO.Date=HERO_v1.Date
left join HERO_v2 on HERO.Date=HERO_v2.Date order by date asc;


-- INFOSYS
create view  INFOSYS_v1 as select Date,Close_Price,avg(Close_price) 
over(rows between 19 preceding and current row) as 20DayMa from INFOSYS order by date asc limit 870 offset 19  ;

create view  INFOSYS_v2 as select Date,Close_Price,avg(Close_price) 
over(rows between 49 preceding and current row) as 50DayMa from INFOSYS order by date asc limit 840 offset 49  ;

create table INFOSYS1 as select INFOSYS.Date,INFOSYS.Close_Price, 20DayMa,50DayMa from INFOSYS
left join INFOSYS_v1 on INFOSYS.Date=INFOSYS_v1.Date
left join INFOSYS_v2 on INFOSYS.Date=INFOSYS_v2.Date order by date asc;


-- TCS
create view  TCS_v1 as select Date,Close_Price,avg(Close_price) 
over(rows between 19 preceding and current row) as 20DayMa from TCS order by date asc limit 870 offset 19  ;

create view  TCS_v2 as select Date,Close_Price,avg(Close_price) 
over(rows between 49 preceding and current row) as 50DayMa from TCS order by date asc limit 840 offset 49  ;

create table TCS1 as select TCS.Date,TCS.Close_Price, 20DayMa,50DayMa from TCS
left join TCS_v1 on TCS.Date=TCS_v1.Date
left join TCS_v2 on TCS.Date=TCS_v2.Date order by date asc;


-- TVS MOTORS
create view  TVS_v1 as select Date,Close_Price,avg(Close_price) 
over(rows between 19 preceding and current row) as 20DayMa from TVS order by date asc limit 870 offset 19  ;

create view  TVS_v2 as select Date,Close_Price,avg(Close_price) 
over(rows between 49 preceding and current row) as 50DayMa from TVS order by date asc limit 840 offset 49  ;

create table TVS1 as select TVS.Date,TVS.Close_Price, 20DayMa,50DayMa from TVS
left join TVS_v1 on TVS.Date=TVS_v1.Date
left join TVS_v2 on TVS.Date=TVS_v2.Date order by date asc;







-- QUESTION2 
-- Create a master table containing the date and close price of all the six stocks.
-- (Column header for the price is the name of the stock)

Create table MASTER_TABLE as select bajaj.date as date,bajaj.close_price as bajaj, tcs.close_price as tcs,tvs.close_price as tvs,
infosys.close_price as infosys,eicher.close_price as eicher,hero.close_price as hero from bajaj
join tcs on bajaj.date=tcs.date
join tvs on bajaj.date=tvs.date
join infosys on bajaj.date=infosys.date
join eicher on bajaj.date=eicher.date
join hero on bajaj.date=hero.date order by date asc ;







-- QUESTION3
-- Use the table created in Part(1) to generate buy and sell signal.
 -- Store this in another table named 'bajaj2'. Perform this operation for all stocks


-- BAJAJ AUTO
-- create a temporary table named bv1 for the difference b/w 20DatMA and 50DayMA 
-- with a column added named srno for srial number
CREATE table bv1 AS 
SELECT DATE,CLOSE_PRICE,IF(50DAYMA IS NOT NULL,20dayma-50dayma,'null')AS difference FROM bajaj1;
alter table bv1 add column srno integer auto_increment primary key first;
-- view pre_final_bajaj2 is created for self join
create view pre_final_bajaj2 as select curr.srno, curr.date,curr.difference as current,prv.difference as previous 
from bv1 curr inner join bv1 prv on curr.srno=prv.srno+1;
-- required table named bajaj2 
create table bajaj2 as select bv1.Date,close_price,
if(pre_final_bajaj2.srno>50,if(current>0 and previous<0,'BUY',if(previous>0 and current<0,'SELL','HOLD')),NULL ) AS 'SIGNAL'
from pre_final_bajaj2 inner join bv1 on bv1.date=pre_final_bajaj2.date;
select * from bajaj2;


-- EICHER MOTORS
-- create a temporary table named ev1 for the difference b/w 20DatMA and 50DayMA 
-- with a column added named srno for srial number
CREATE table ev1 AS 
SELECT DATE,CLOSE_PRICE,IF(50DAYMA IS NOT NULL,20dayma-50dayma,'null')AS difference FROM eicher1;
alter table ev1 add column srno integer auto_increment primary key first;
-- view pre_final_eicher2 is created for self join
create view pre_final_eicher2 as select curr.srno, curr.date,curr.difference as current,prv.difference as previous 
from ev1 curr inner join ev1 prv on curr.srno=prv.srno+1;
-- required table named eicher2 
create table eicher2 as select ev1.Date,close_price,
if(pre_final_eicher2.srno>50,if(current>0 and previous<0,'BUY',if(previous>0 and current<0,'SELL','HOLD')),NULL ) AS 'SIGNAL'
from pre_final_eicher2 inner join ev1 on ev1.date=pre_final_eicher2.date;
select * from eicher2;


-- HERO MOTOCORP
-- create a temporary table named hv1 for the difference b/w 20DatMA and 50DayMA 
-- with a column added named srno for srial number
CREATE table hv1 AS 
SELECT DATE,CLOSE_PRICE,IF(50DAYMA IS NOT NULL,20dayma-50dayma,'null')AS difference FROM hero1;
alter table hv1 add column srno integer auto_increment primary key first;
-- view pre_final_hero2 is created for self join
create view pre_final_hero2 as select curr.srno, curr.date,curr.difference as current,prv.difference as previous 
from hv1 curr inner join hv1 prv on curr.srno=prv.srno+1;
-- required table named hero2 
create table hero2 as select hv1.Date,close_price,
if(pre_final_hero2.srno>50,if(current>0 and previous<0,'BUY',if(previous>0 and current<0,'SELL','HOLD')),NULL ) AS 'SIGNAL'
from pre_final_hero2 inner join hv1 on hv1.date=pre_final_hero2.date;
select * from hero2;


-- INFOSYS
-- create a temporary table named iv1 for the difference b/w 20DatMA and 50DayMA 
-- with a column added named srno for srial number
CREATE table iv1 AS 
SELECT DATE,CLOSE_PRICE,IF(50DAYMA IS NOT NULL,20dayma-50dayma,'null')AS difference FROM infosys1;
alter table iv1 add column srno integer auto_increment primary key first;
-- view pre_final_infosys2 is created for self join
create view pre_final_infosys2 as select curr.srno, curr.date,curr.difference as current,prv.difference as previous 
from iv1 curr inner join iv1 prv on curr.srno=prv.srno+1;
-- required table named infosys2 
create table infosys2 as select iv1.Date,close_price,
if(pre_final_infosys2.srno>50,if(current>0 and previous<0,'BUY',if(previous>0 and current<0,'SELL','HOLD')),NULL ) AS 'SIGNAL'
from pre_final_infosys2 inner join iv1 on iv1.date=pre_final_infosys2.date;
select * from infosys2;


-- TCS
-- create a temporary table named tcsv1 for the difference b/w 20DatMA and 50DayMA 
-- with a column added named srno for srial number
CREATE table tcsv1 AS 
SELECT DATE,CLOSE_PRICE,IF(50DAYMA IS NOT NULL,20dayma-50dayma,'null')AS difference FROM tcs1;
alter table tcsv1 add column srno integer auto_increment primary key first;
-- view pre_final_tcs2 is created for self join
create view pre_final_tcs2 as select curr.srno, curr.date,curr.difference as current,prv.difference as previous 
from tcsv1 curr inner join tcsv1 prv on curr.srno=prv.srno+1;
-- required table named tcs2 
create table tcs2 as select tcsv1.Date,close_price,
if(pre_final_tcs2.srno>50,if(current>0 and previous<0,'BUY',if(previous>0 and current<0,'SELL','HOLD')),NULL ) AS 'SIGNAL'
from pre_final_tcs2 inner join tcsv1 on tcsv1.date=pre_final_tcs2.date;
select * from tcs2;


-- TVS MOTORS
-- create a temporary table named tvsv1 for the difference b/w 20DatMA and 50DayMA 
-- with a column added named srno for srial number
CREATE table tvsv1 AS 
SELECT DATE,CLOSE_PRICE,IF(50DAYMA IS NOT NULL,20dayma-50dayma,'null')AS difference FROM tvs1;
alter table tvsv1 add column srno integer auto_increment primary key first;
-- view pre_final_tvs2 is created for self join
create view pre_final_tvs2 as select curr.srno, curr.date,curr.difference as current,prv.difference as previous 
from tvsv1 curr inner join tvsv1 prv on curr.srno=prv.srno+1;
-- required table named tvs2 
create table tvs2 as select tvsv1.Date,close_price,
if(pre_final_tvs2.srno>50,if(current>0 and previous<0,'BUY',if(previous>0 and current<0,'SELL','HOLD')),NULL ) AS 'SIGNAL'
from pre_final_tvs2 inner join tvsv1 on tvsv1.date=pre_final_tvs2.date;
select * from tvs2;







-- QUESTION 4
--  Create a User defined function, that takes the date as input and returns the signal for that particular day 
-- (Buy/Sell/Hold) for the Bajaj stock.

SELECT * FROM BAJAJ2;
-- THE REQUIRED FUNCTION

DELIMITER //
CREATE FUNCTION SIGNAL_OF_DATE (INDATE DATE)
RETURNS VARCHAR(5) deterministic
BEGIN
RETURN (SELECT BAJAJ2.SIGNAL FROM BAJAJ2 WHERE DATE=INDATE);
END;
//

SELECT SIGNAL_OF_DATE('2015-10-19');






























