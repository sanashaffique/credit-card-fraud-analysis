
                            --Data Import and Data Cleaning--

USE creditCardDB;
/*
There is 555719 rows and 23 columns.

id column is our primary key and by default an index column.

All field name are in lower case.

Convert DATATYPE:
id column tingint to int
amt column float to decimal
gender column nvarchar(50) to nchar(2)

Alter dtype column:
'dob' to date

Rename col :
'dob' to 'birth_date'

-Standadize Column Values (merchant,job,gender):
Convert  inconsistance values to lower case and trim gender

Null Values:
lat,long,merch_lat,merch_long (These col have null values but could not replace with 0.0 bcz presence of
positive and negative values on all these col show  location on earth,changing with 0 mean incorrect location) 

drop column:
unix_time column drops (represnt 2013 year data) bcz  different from trans_date_trans_time column
(which show 2020 year data).Because dataset is synthetic.

Duplicate entries:
There is no duplicate entries by id(primary key) column.
There is no duplicate found by id,cc_num,trans_date_trans_time,merchant,category,amt,first,
last,gender, job,dob,trans_num,is_fraud.

 Add new column:
 full_name  dtype nvarchar(70) .
 This column represent customer full name.

 --create unique index 'trans_index' on trans_num column:
Bcz all dateset depends upon unique transaction number. It will helps us to quickly run sql queries.

Check uniuqe entries and updating outliar:

trans_date_trans_time column have 226976 unique values and have record of 2020 year.
It have range values from 2020-06-25 to 2020-12-30.

gender have 2 unique values.

category have 14 unique values.

merchant have 693 unique values.

cc_num have 924 unique values but full_name have 917 unique values.(both number should same bcz one credit card should 
map with 1 person).
cc_num column have unique values without error bcz its int type make sure only intergers add (no text or special character).

amt have 37256 unique values.min 1 and max 22768.11 seems normal values. Avg value is 69.39 mean data is right skewed.

city have 849 unique values.
state have 50 unique values.

job have 478 unique values.
(land,make,sub) replace with unknown
barista with barrister incorrect values.

*/

--Check total entries
select * from dbo.fraudTest ;
/*There is 555719 entries and 23 columns.*/

--Alter dtype column 'dob' to date
alter table dbo.fraudTest
alter column dob date  ;

--rename col dob to birth_date (by table design).

--Standadize Column Values (merchant,job,gender)
update dbo.fraudTest
set merchant = lower(merchant),
job =  lower(job),
gender = trim(gender);

/* Convert  inconsistance values to lower case and trim gender*/

--drop unix_time col
select DATEADD(s,1371816865,'1970-01-01') as universal_time;
/*unix_time show 2013 year which is different from transaction datetime bcz dataset is synthetic not origional,
drop this column*/
alter table dbo.fraudTest
drop column unix_time;

--Check Null values
select count(*)as total,count(merch_long) as m_long,count(merch_lat) as m_lat,count(lat) as lat,count(long) as long , 
count(merchant) as m,count(trans_date_trans_time) as t_date_time,count(cc_num) as cc_num,count(category) as category, 
count(amt) as amt,count(first) as f_name ,count(last) as _name,count(gender) as gender,count(street) as street, 
count(city) as city,count(state) as s,count(zip) as zip,count(city_pop) as city_pop,count(dob) as birthdate,
count(trans_num) as num, count(is_fraud) as fraud from dbo.fraudTest;
/* 
Null Values lat,long,merch_lat,merch_long have null values and cannot replace
them bcz these have positive and negative values both,replace it with 0.0 show incorrect location on earth. */

--Check duplicate by id column(primary key)
select id,count_row 
from (select id ,row_number() over( partition by id order by id) as count_row from dbo.fraudTest) as table_count 
where count_row >1;
/*There is no duplicate by id column*/

--Check duplicate by id,cc_num,trans_date_trans_time,merchant,category,amt,first,last,gender,job,dob,trans_num,is_fraud 
select *,count_row from (select * ,row_number() over( partition by id,cc_num,trans_date_trans_time,merchant,category,amt,
first,last,gender,job, dob,trans_num,is_fraud order by id) as count_row from dbo.fraudTest) as table_count 
where count_row >1;
/* 
Check duplicate by columns( id,cc_num,trans_date_trans_time,merchant,category,amt,first,last,gender, 
job,dob,trans_num,is_fraud).No duplicate found 
*/

-- create full_name col
alter table dbo.fraudTest
add full_name nvarchar(70);

/*full_name col created.*/

--Add values to 'full_name' column
update dbo.fraudTest
set full_name = CONCAT(first,' ', last);
/*This column represent customer full name*/

--create unique index 'trans_index'
create unique index trans_index  on dbo.fraudTest (trans_num);
/*Bcz all dateset depends upon unique transaction number. It will helps us to quickly run sql queries.*/

--Check unique values
select count(distinct(trans_date_trans_time))as trans_date,count(distinct(merchant))as business,count(distinct(cc_num))as cc,
count(distinct(full_name))as name,count(distinct(category)) as category,count(distinct(amt)) as amt,
count(distinct(gender)) as gender,count(distinct(city)) as city,count(distinct(state)) as state,count(distinct(job)) as job
from dbo.fraudTest;

/* 
trans_date_trans_time column have 226976 unique values and have record of 2020 year.
It have range values from 2020-06-25 to 2020-12-30.

gender have 2 unique values.

category have 14 unique values.

merchant have 693 unique values.

cc_num have 924 unique values but full_name have 917 unique values.(both 7 customer hold 2 credit card).
cc_num column have unique values without error bcz its int type make sure only intergers add (no text or special character).

amt have 37256 unique values.min 1 and max 22768.11 seems normal values. Avg value is 69.39 mean data is right skewed.

city have 849 unique values.
state have 50 unique values.

job have 478 unique values.
(land,make,sub) replace with unknown
barista with barrister incorrect values.
*/
--Check distinct values (for any inconsistency and error)
select distinct(trans_date_trans_time) from dbo.fraudTest;
select distinct(category) from dbo.fraudTest;
select distinct(gender) from dbo.fraudTest;
select distinct(merchant) from dbo.fraudTest;
select distinct(cc_num) from dbo.fraudTest;
select distinct(city) from dbo.fraudTest order by city asc;
select distinct(state) from dbo.fraudTest order by state;
select distinct(job) from dbo.fraudTest order by job;

--Changes in consistent values
--Update make/sub/land with unknown
update dbo.fraudTest
set job = 'unknown'
where job = 'make' or job = 'sub' or job ='land';

--update barista with barister 
update dbo.fraudTest
set job = 'barister'
where job = 'barista';

--Check min,max,avg of amt column
select min(amt) as min_m,max(amt) as max_m,avg(amt) as avg_m from dbo.fraudTest;
/* min 1 and max 22768.11 seems normal values. Avg value is 69.39 mean data is right skewed.*/

--Person with more than 1 credit card
select full_name,count(distinct(cc_num)) from dbo.fraudTest group by full_name
having count(distinct(cc_num)) >1;
/* 7 customers have 2 credit card.*/

            --SQL Queries(further Analysis)--

--Q1 total transaction?
create view trans_num as 
select count(distinct(trans_num)) as total_trancsaction
from dbo.fraudTest;
 /*Total transaction are 555719 */

--Q2 total fraud count?
create view fraud_count as
select is_fraud,count(is_fraud) as count_t from dbo.fraudTest group by is_fraud;
/*Total Fraud entries are 2154 and 553574 are origional transaction.*/

--Q3 Top 5 customers by number of transactions?
create view top_5_cus_by_transaction as
select top 5 full_name,count(trans_num) as total_trans from dbo.fraudTest
group by full_name 
order by total_trans desc;
/* Scott Martin has total transaction 1965 and 2nd highest is 1526 OF Jeffrey Smith.3rd highest of Gina Grimes 1474 transactions*/

--Q4 Business site where fraud rate is highest?
create view  business_with_highest_fraud as
select top 3 merchant, count(merchant) as fraud_trans from dbo.fraudTest where is_fraud = 1
group by merchant order by fraud_trans desc;
/* Business site (fraud_lemke-gutmann)
(fraud_mosciski, ziemann and farrell)
(fraud_romaguera, cruickshank and greenholt) have highest fraudulent trasnsaction rate (18)*/

--Q5 Percentage of fraud transection?
create view fraud_percentage as
select is_fraud,((count(is_fraud) * 1.0) /555719)   as fraud_count from dbo.fraudTest  group by is_fraud;
 /* Origional transactions are 0.99614% and fraudulent transactions are 0.003%. This shows fraud rate is much lower showing strong
 money handling system and security system.*/

 --Q6 Top 2 product categories by highest fraud count
 create view top_2_category_by_fraud_count as
 select top 2 category,count(is_fraud) as fraud_count from dbo.fraudTest where is_fraud =1
 group by category order by fraud_count desc;
 /*shopping_net has fraud count is 506 and grocery_pos has 485 fraud count.Mostly fraud in shopping through online payment
 and in physical point-of-sale in grocery transactions.*/

 --Q7 Top 5 cities with highest fraud count
 create view top_5_cities_highest_fraud_count as
 select top 5 city,count(is_fraud) as fraud_count from dbo.fraudTest where is_fraud =1
 group by city order by fraud_count desc ;
 /* Camden has highest fraud count 27, Birmingham 25.  Other all cities have different fraud range from 2 to 19.*/

 --Q8: Fraud distribution by transaction amount (low vs high)
 create view fraud_dist_by_trans_amt as
 select  min(amt) as min_trans,max(amt) as max_trans
 from dbo.fraudTest
 where is_fraud =1;
 /*Min amount is 1.78 and max amount 1320.92 of fraudulent transactions.It shows fraud happened not only on small amount but also
 occur on large amount.Fraud on large amount is not negligible.*/

 --Q9: Top 5 card holders with highest fraud rate
 create view top_5_cc_highest_fraud_rate as
 select  top 5 cc_num ,full_name,count(is_fraud) as fraud_rate
 from dbo.fraudTest 
 where is_fraud =1
 group by cc_num,full_name order by fraud_rate desc ;
 /*Credit Card 4599285557366050 holder Many Williams has highest fraud rate. 
 2nd highest cc 6538441737335430 holder Gina Grimes has 18 fraud rate.*/

 -- Q10 Top customer job professions involved in fraud?
create view top_cus_job_professional_involve_in_fraud as
select top 2 job,count(is_fraud)as fraud_count
from dbo.fraudTest where is_fraud =1
group by job order by fraud_count desc;
/* Science writer and unknown have highest fraud rate.*/

--Q11 Fraud rate by gender?
create view fraud_rate_by_gender as 
select gender,count(is_fraud) as fraud_Count 
from dbo.fraudTest
where is_fraud =1
group by gender;
/*Fraud is almost evenly distributed across genders, with females (1,164 cases, 468 unique) slightly higher than males (981 cases, 456 unique). 
Many customers are repeat offenders.*/

--Q12 Fraud rate by day of week & month?
with cte as (select is_fraud, Month(trans_date_trans_time) as mon,DATEPART(WEEK,trans_date_trans_time) as wk from dbo.fraudTest)
select mon,wk ,count(is_fraud) as fraud_rate
from cte
where is_fraud = 1
group by mon,wk
order by mon,wk;

/*There is no specific pattern of fraud detection because fraud rate is higher in each month at different weeks.
JUNE LAST WEEK 68 HIGHEST
JULY 4TH WEEK 107 HIGHEST
AUGUST 2ND WEEK 154 HIGHEST 
SEPTEMBER 4th WEEK 85 HIGHEST
OCTOBER 2ND WEEK 126 HIGHEST
NOVEMBER last week 92 highest
DECEMBER 2ND WEEK 116 HIGHEST fraud detection. */

--Q13 City vs total population, card holders, transactions, fraud rate?
select city,city_pop ,count(distinct(cc_num)) as card_holder,count(trans_num) as transactions,
sum(case when is_fraud = 1 then 1 when is_fraud = 0 then 0 end)  as fraud_count
from dbo.fraudTest
group by city,city_pop
order by fraud_count desc

/*There is no dirct link between a city have higher population or higher transactions ,also have higher fraud rate.
Burrton city 503 transaction but highest fraud 19 with small population 1689,
Clark Mills have 1474 transaction with 2nd highest fraud rate 18 with small population 606 
Phoenix have 2222  highest transactions with fraud rate 15 with pop 1312922
Houston have 1679 transaction with 0 fraud rate with highest population 2906700 */

--Q14 Fraud rate by state?
create view fraud_rate_by_state as
select top 5 state,sum(is_fraud) as fraud_case
from dbo.fraudTest
group by state
order by fraud_case desc;
/* NY has highest 175 fraud cases and PA has 2nd highest 114.*/

select state,is_fraud,amt as f from dbo.fraudTest where state = 'AR' and is_fraud = 1