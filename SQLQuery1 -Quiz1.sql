---Chapter 1: Querying & Filtering


/*
Q1. (LIKE, IN, ORDER BY with multiple columns) Return the first_name, last_name and city of customers
who live in the state NY or CA, whose email ends in .com and whose last_name starts with the letter M.
Sort by city ascending, then last_name ascending.*/
select
first_name,
last_name,
city
from sales.customers
where state='Ny' OR state='CA'
AND email  like '%.com'
AND last_name like 'M%'
order by city asc , last_name asc

/*
Q2. (Aliases, calculated column, ORDER BY, pagination) Show product_name, list_price and a calculated column called discounted_price (10% off)
for products with a list_price above 500. Skip the 10 most expensive products and return the next 10 (the 11th to 20th most expensive).
*/
select
product_name,
list_price,
list_price * 0.90 as Discounted_price
from production.products
where list_price>500
order by list_price desc
offset 10 rows fetch next 10 rows only

/*
Q3. (NULL, BETWEEN, AND/OR precedence) Find all orders that are either Pending or Processing, have not shipped yet, 
and were placed between 2018-01-01 and 2018-06-30. Return order_id, order_date, required_date and order_status. 
Your AND/OR logic must be explicitly grouped.
*/
select
order_id,
order_date,
required_date,
order_status
 from sales.orders
 where order_status In (1,2) 
 AND order_date Between '2018-01-01' AND '2018-06-30'


 --Chapter 2: Joins
 /*Q4. (Multi-table INNER JOIN, 5 tables) For all Completed orders placed in 2018, 
 return the customer's full name, order_id, order_date, store_name, product_name and quantity. Sort by order_date, newest first.
 */
 select 
 c.first_name+c.last_name as Full_name,
 o.order_id,
 o.order_date,
 st.store_name,
 p.product_name,
  ot.quantity
 from sales.orders as o
 left join sales.customers as c
 on c.customer_id=o.customer_id
 inner join sales.stores as st
 on o.store_id=st.store_id
 inner join sales.order_items as ot
 on o.order_id=ot.order_id
 inner join production.products as p
 on ot.product_id=p.product_id
 where order_date like '2018%'
 order by order_date asc

 /*
 Q5. (LEFT JOIN + NULL check, 4 tables)
 List every product that has never been sold, showing product_name, category_name and brand_name.*/

 select
 p.product_name,
 c.category_name,
b.brand_name
 from  production.products as p
 left join sales.order_items as oi
 on p.product_id=oi.product_id
 inner join production.categories as c
 on p.category_id=c.category_id
 inner join production.brands as b
 on p.brand_id=b.brand_id
 where oi.product_id is null

 /*
 Q6. (Self join + extra join) Show every staff member's full name, their manager's full name (NULL for the top-level person) 
 and the name of the store they work in.
 */


 --Chapter 3: Views
 /*
Q7. (CREATE VIEW + query the view)
(a) Create a view sales.vw_order_details that joins orders, customers, order_items and products and exposes: 
order_id, order_date, order_status, customer_id, first_name, last_name, product_name, quantity and a calculated line_total (quantity × list_price × (1 − discount)).
(b) Using only that view, return each customer's total spend on Completed orders, and keep only customers who spent more than 10,000. Sort by total spend, highest first.
*/

Create View sales.vw_order_details as
select 

o.order_id,
c.customer_id,
c.first_name,
c.last_name,
p.product_name,
p.quantity
from sales.customers as c


--Chapter 4: Aggregation
/*
Q8. (GROUP BY on multiple columns, HAVING, COUNT DISTINCT, joins, top N)
For each combination of category_name and brand_name, return the number of distinct orders and the total revenue.
Keep only combinations that appear in at least 20 distinct orders, and return the top 5 by revenue.
*/
select Top 5
c.category_name,
b.brand_name,
sum(oi.list_price) as Total_price
from sales.order_items as oi
inner join production.products as p
on oi.product_id=p.product_id
inner join production.categories as c
on p.category_id=c.category_id
inner join production.brands as b
on p.brand_id=b.brand_id
group by c.category_name ,b.brand_name
order by Total_price desc





/*
Q9. (Aggregation across joins, YEAR(), COUNT DISTINCT)
For each store and each order year, return store_name, order_year, the number of distinct orders and total revenue.
Sort by store_name, then order_year.
*/

select
st.store_name,
count (Distinct o.order_id) No_of_orders,
Sum (oi.list_price) as Total_revenue
from sales.orders as o
inner join sales.stores as st
on o.store_id=st.store_id
inner join sales.order_items as oi
on o.order_id=oi.order_id
group by store_name 
