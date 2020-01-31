--Data Definition Language (DDL) Statement to create a simple table containing the date a stock is traded, the broker/dealer(firm) who traded (bought or sold), the ticker symbol of the stock, the quantity & the price in dollars. 

CREATE TABLE TRADES  ( Date DATE NOT NULL ,Firm VARCHAR(255) ,Symbol VARCHAR(10) ,Side VARCHAR(1) ,Quantity BIGINT ,Price DECIMAL(18,8) );

--Insert a sample of 10 values into the table. 
INSERT INTO TRADES VALUES('08/05/2019','ABC','123','B',200,41);
INSERT INTO TRADES VALUES('08/05/2019','CDE','456','B',601,60);
INSERT INTO TRADES VALUES('08/05/2019','ABC','789','S',600,70);
INSERT INTO TRADES VALUES('08/05/2019','CDE','789','S',600,70);
INSERT INTO TRADES VALUES('08/05/2019','FGH','456','B',200,62);
INSERT INTO TRADES VALUES('08/06/2019','CDE','456','B',300,61);
INSERT INTO TRADES VALUES('08/08/2019','ABC','123','B',300,40);
INSERT INTO TRADES VALUES('08/09/2019','ABC','123','S',300,30);
INSERT INTO TRADES VALUES('08/09/2019','FGH','789','B',2100,71);
INSERT INTO TRADES VALUES('08/10/2019','CDE','456','S',1100,63);

--Since all the prices are intetegers, cast as integers when displaying the data. 
select cast (price as integer) from TRADES;

--Retrieve all the unique broker/dealers who executed the trades
select distinct firm from TRADES;

--Retrieve all the unique ticker symbols that were traded 
select distinct symbol from TRADES;

--select each row displaying the total value in dollas exchanged as part of the trade (multiply quantity by price)
select firm, symbol, side,  (quantity * price) from TRADES order by firm, side;

--select total amounts for each row, sorted by type of trade (buy or sell)
select side, (quantity * price) from TRADES order by side;

--select total amount for all rows aggretaged by type of trade
select side, sum(quantity * price) from TRADES group by side;

--select data from table excluding the date, and data sorted by ticker symbol
select symbol, date, side, quantity, price from trades order by symbol;

--Add a column called TIER to the TRADES table. 
alter table trades add TIER varchar(32);


--There is an employee that could use a case statement based on employee id (trial run)
SELECT EMP_ID, L_NAME,
   CASE EMP_ID
     WHEN 'E1001' THEN 'Administration'
     WHEN 'E1002' THEN 'Human Resources'
     WHEN 'E1003' THEN 'Accounting'
     WHEN 'E1004' THEN 'Design'
     WHEN 'E1005' THEN 'Operations'
   END
FROM EMPLOYEES;

--select data from table & dynamically evaluating the quantity & displaying the category of trade
--categories of trade are (small, medium, large & very large)
SELECT * ,
   CASE 
     WHEN QUANTITY  < 251  THEN  'Small'
     WHEN QUANTITY  > 250 AND QUANTITY < 501  THEN 'Medium'
     WHEN QUANTITY  > 500 AND QUANTITY < 751  THEN 'Large'
     ELSE 'Very Large'
   END
FROM TRADES;

--Update statement failed & so some kind souls on developer.ibm.com suggested to reorg table
CALL ADMIN_CMD('REORG TABLE TRADES');

--Finally updated the Tier in the Trades table based on the quantity sold 
UPDATE TRADES 
SET TIER =
     CASE 
       WHEN QUANTITY  < 251  THEN  'Small'
       WHEN QUANTITY  > 250 AND QUANTITY < 501  THEN 'Medium'
       WHEN QUANTITY  > 500 AND QUANTITY < 751  THEN 'Large'
       ELSE 'Very Large'
     END;
     

--Display to make sure that we have all the Tiers as categories
SELECT * FROM TRADES;

--Next Part is to group data by weeks.  
--IBM provides SysIBM.SysDummy1 with a dummy record to make quick calculations & here i'm calculating the week number using a date. 
SELECT WEEK('2019-08-01') FROM SYSIBM.SYSDUMMY1;
SELECT WEEK('2019-08-31') FROM SYSIBM.SYSDUMMY1;

--Warmup exercise: Sample SELECT statement casting a date column & return it as a week number 
SELECT  WEEK(DATE) AS WEEK_NUM, SIDE AS TRADE_TYPE,  (PRICE*QUANTITY) AS 
   TRADE_VALUE FROM TRADES;

--Warmup exercise: Sample statement to group Trades by type of Trades    
SELECT  SIDE AS TRADE_TYPE,  SUM(PRICE*QUANTITY) AS 
   TRADE_VALUE FROM TRADES GROUP BY SIDE;

--Here's a somewhat complex SQL statement that aggregates rows by week number & trade type for the weeks in the month of August 2019 (sub selects are more complex)
SELECT WEEK(DATE) AS WEEK_NUM, SIDE AS TRADE_TYPE, SUM(PRICE*QUANTITY) AS TRADE_VALUE FROM TRADES
    WHERE WEEK(DATE) IN (31, 32, 33, 34, 35)
    GROUP BY WEEK(DATE), SIDE
    ORDER BY WEEK_NUM;
