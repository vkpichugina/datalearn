--region
insert into region
select   
  500+row_number() over (partition by 1) as rn
 ,region  
 ,country
from (select distinct country
 ,region from orders) o;

--state
insert into "State"
select   
  600+row_number() over (partition by 1) as rn
 ,"state"
 ,region_id  
from (select distinct 
 "state"
 ,region_id from orders o 
 left join region r on o.region=r.region);


--Address
insert into address
select   
  1000+row_number() over (partition by 1) as rn
 ,city
 ,coalesce(postal_code,0)
 ,state_id 
from (select distinct 
 city
 ,postal_code
 ,state_id from orders o 
 left join "State" s on o.state=s.state);



-- Category

insert into category
select 
100+row_number() over (partition by 1)
 , category  
from (select distinct category from orders) o;


select * from category;

--Subcategory
insert into subcategory 
select 
200+row_number() over (partition by 1)
,subcategory
,category_id
from
(select 
distinct 
subcategory
,category_id
from orders 
left join category on category=category_name ) 


--Product
insert into product 
select 
product_id   
,max(product_name) 
,subcategory_id
from orders 
left join subcategory on subcategory =subcategory_name
group by product_id   
,subcategory_id
;

--Segment
insert into segment 
select 
300+row_number() over (partition by 1)
,segment
from (select distinct segment from orders);

-- Customer
insert into customer 
select distinct customer_id
 ,customer_name
 ,segment_id 
 from orders 
left join segment s  on segment=segment_name;

--Shipping
insert into shipping  
select 
400+row_number() over (partition by 1)
,ship_mode 
from (select distinct ship_mode  from orders);

--Sales

insert into sales
select 
 row_id   
 ,order_id   
 ,order_date 
 ,ship_date  
 ,sales      
 ,quantity   
 ,discount   
 ,profit     
 ,product_id  
 ,customer_id
 ,s.shipping_id 
 ,a.address_id 
 from orders o 
 left join shipping s on s.shipping_name =o.ship_mode 
 left join address a on  a.city=o.city
 and a.postal_code=coalesce(o.postal_code,0)

