--Get all customers and their addresses.
SELECT * FROM "customers"
JOIN "addresses"
ON "customers"."id" = "addresses"."customer_id";

-- Get all orders and their line items (orders, quantity and product).
SELECT * FROM "orders"
JOIN "line_items"
ON "orders"."id" = "line_items"."order_id"
JOIN "products"
ON "line_items"."product_id" = "products"."id";

-- Which warehouses have cheetos?
SELECT * FROM "warehouse"
JOIN "warehouse_product"
ON "warehouse"."id" = "warehouse_product"."warehouse_id"
JOIN "products"
ON "warehouse_product"."product_id" = "products"."id"
WHERE "products"."id" = 5;

-- Which warehouses have diet pepsi?
SELECT * FROM "warehouse"
JOIN "warehouse_product"
ON "warehouse"."id" = "warehouse_product"."warehouse_id"
JOIN "products"
ON "warehouse_product"."product_id" = "products"."id"
WHERE "products"."id" = 6;

-- Get the number of orders for each customer. 
--    NOTE: It is OK if those without orders are not included in results.
SELECT "customers"."last_name", COUNT("orders"."id")
FROM "orders"
JOIN "addresses"
ON "orders"."address_id" = "addresses"."id"
JOIN "customers"
ON "addresses"."customer_id" = "customers"."id"
GROUP BY "customers"."last_name";

-- How many customers do we have?
SELECT COUNT(*) FROM "customers";
-- How many products do we carry?
SELECT COUNT(*) FROM "products";

--. What is the total available on-hand quantity of diet pepsi?
SELECT SUM("warehouse_product"."on_hand") FROM "warehouse_product"
WHERE "product_id" = 6;

--How much was the total cost for each order?
SELECT orders.id, SUM(products.unit_price)
FROM orders
    JOIN line_items ON line_items.order_id=orders.id
    JOIN products ON products.id=line_items.product_id
GROUP BY orders.id
ORDER BY orders.id;

--How much has each customer spent in total?
SELECT CONCAT(first_name, ' ', last_name), SUM(products.unit_price)
FROM customers
    JOIN addresses ON addresses.customer_id=customers.id
    JOIN orders ON orders.address_id=addresses.id
    JOIN line_items ON line_items.order_id=orders.id
    JOIN products ON products.id=line_items.product_id
GROUP BY CONCAT(first_name, ' ', last_name);

How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).

SELECT customers.first_name, SUM(products.unit_price*line_items.quantity) FROM customers
JOIN addresses on addresses.customer_id = customers.id
JOIN orders on orders.address_id = addresses.id
JOIN line_items ON line_items.order_id=orders.id
JOIN products ON line_items.product_id=products.id
GROUP BY customers.first_name;
