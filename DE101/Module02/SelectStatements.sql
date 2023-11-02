--Overview (обзор ключевых метрик)
with segment as
(
select 
date(date_trunc('month', order_date)) as mnth
,segment
,round(sum(sales),2) as sales_by_segment--Monthly Sales by Segment
from public.orders
group by date(date_trunc('month', order_date)), segment
)
, category as (
select 
date(date_trunc('month', order_date)) as mnth
,category
,round(sum(sales),2) as sales_by_category--Monthly Sales by Segment
from public.orders
group by date(date_trunc('month', order_date)), category
)
select 
date(date_trunc('month', order_date)) as mnth
,o.segment
,o.category
,round(sum(sales),2) as total_sales --Total Sales
,round(sum(profit),2) as total_profit--Total Profit
,round(sum(profit)/sum(sales),2) as profit_ratio--Profit Ratio
,round(sum(profit)/count(distinct order_id),2) as profit_per_order --Profit per Order
,round(sum(sales)/count(distinct customer_id),2) as sales_per_customer --Sales per Customer
,round(avg(discount),2) as avg_discount--Avg. Discount
,s.sales_by_segment--Monthly Sales by Segment ( табличка и график)
,c.sales_by_category --Monthly Sales by Product Category (табличка и график)
from public.orders o
left join segment s on o.segment=s.segment and date(date_trunc('month', order_date))=s.mnth
left join category c on o.category=c.category and date(date_trunc('month', order_date))=c.mnth
group by date(date_trunc('month', order_date)), o.segment, o.category, s.sales_by_segment,c.sales_by_category;


--Product Dashboard (Продуктовые метрики)
--Sales by Product Category over time (Продажи по категориям)
select 
date(date_trunc('month', order_date)) as mnth
,category
,round(sum(sales),2) as sales_by_category--Monthly Sales by Segment
from public.orders
group by date(date_trunc('month', order_date)), category;

--Customer Analysis

with cust as (select 
substring(cast(date(date_trunc('year', order_date)) as varchar),1,4) as year
,segment
,region
,customer_id
,round(sum(sales),2) as sales_by_customer
,round(sum(profit),2) as profit_by_customer
from public.orders
group by date(date_trunc('year', order_date)), segment, region, customer_id 
)
select *
,row_number() over (partition by year, segment, region order by profit_by_customer desc) as cust_profit_rank
,sum(sales_by_customer) over (partition by year, segment, region) as sales_per_region
from cust;



select order_id from public.orders
group by order_id
having count(*)>1;

select * from public.orders
where order_id = 'CA-2016-104738'