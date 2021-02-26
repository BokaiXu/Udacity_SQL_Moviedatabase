/* We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month./

SELECT DATE_PART('month',r.rental_date) AS month,
       DATE_PART('year',r.rental_date) AS year,
       s.store_id,
       COUNT(*)
FROM rental r
JOIN customer c
ON r.customer_id=c.customer_id
JOIN store s
ON s.store_id=c.store_id
GROUP BY 1,2,3
ORDER BY 4 DESC

/* We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?/

SELECT DATE_TRUNC('month', p.payment_date),
       sub.name,
       COUNT(*),
       SUM(p.amount)
FROM
(SELECT c.customer_id,
       CONCAT(c.first_name,' ',c.last_name) AS name,
       SUM(p.amount)
FROM payment p
JOIN customer c
ON p.customer_id=c.customer_id
WHERE p.payment_date BETWEEN '2007-01-01' AND '2008-01-01'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10) sub
JOIN payment p
ON p.customer_id=sub.customer_id
GROUP BY 2,1
ORDER BY 2,1

/* Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments./

WITH table1 AS(
SELECT DATE_TRUNC('month', p.payment_date) AS date,
       sub.name AS name,
       SUM(p.amount) AS month_payment,
       LAG(SUM(p.amount))OVER(PARTITION BY sub.name ORDER BY DATE_TRUNC('month', p.payment_date)) AS lag,
       SUM(p.amount)-LAG(SUM(p.amount))OVER(PARTITION BY sub.name ORDER BY DATE_TRUNC('month', p.payment_date)) AS month_diff
FROM(
SELECT c.customer_id,
       CONCAT(c.first_name,' ',c.last_name) AS name,
       SUM(p.amount)
FROM payment p
JOIN customer c
ON p.customer_id=c.customer_id
WHERE p.payment_date BETWEEN '2007-01-01' AND '2008-01-01'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10) sub
JOIN payment p
ON p.customer_id=sub.customer_id
GROUP BY 2,1)
SELECT *,
       CASE WHEN table1.month_diff=(SELECT MAX(table1.month_diff) FROM table1) THEN 'max'
       ELSE 'not_max' END AS Is_max
FROM table1
