----2.1. Write a query that lists every product with its brand name, using production.products and production.brands.
SELECT
p.product_name,
b.brand_name
FROM production.products AS p
LEFT JOIN production.brands AS b
on p.brand_id = b.brand_id
ORDER BY p.product_name ASC

---- 2.2. Using a LEFT JOIN, write a query that finds every store with zero staff currently assigned to it.
SELECT
st.store_id,
st.store_name
FROM sales.stores AS st
LEFT JOIN sales.staffs AS s
on st.store_id = s.store_id
WHERE s.store_id is NULL


---- 2.3. Explain, in your own words, why the following query returns every product regardless of stock level,
--- rewrite it so that it only returns products with fewer than 5 units in stock at store 1:
/* 
ANSWER:
That query returns every product because the stock and store_id conditions are placed in On condition with LEFT JOIN , 
It preserves all products records even when their stocks or store_id doesnot meet the conditions 

*/
SELECT 
p.product_name, 
s.quantity,
s.store_id
FROM production.products AS p
LEFT JOIN production.stocks AS s
   ON p.product_id = s.product_id 
   WHERE  s.quantity < 5 AND s.store_id = 1
   order by p.product_name ASC

--- 2.4. Write a self join on sales.staffs that lists every manager along with a count placeholder column showing 1 for each employee they manage 

SELECT 
m.staff_id AS ID,
m.first_name + ' ' + m.last_name AS Manager,
e.first_name + ' ' + e.last_name As Employee,
1 AS Count
FROM sales.staffs AS m
inner join sales.staffs AS e
on e.manager_id = m.staff_id
order by m.staff_id


--- 2.5. Write a three-table join across sales.orders, sales.order_items, and production.products that lists every item in order #1,
--- including product name and quantity.

Select o.order_id,
i.item_id,
p.product_name,
i.quantity
from sales.orders as o
left join sales.order_items as i
on o.order_id=i.order_id
inner join production.products as p
on i.product_id=p.product_id
where o.order_id IN (1)


--- 2.6. A colleague joins orders to order_items and reports "we received 4,658 orders last year." 
--- Explain what actually went wrong with that number and how you would find the true order count instead.

select count(*) AS Total_Orders_2017
from sales.orders
where order_date like ('2017%')

