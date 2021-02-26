/*Question 1
We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out./

SELECT sub1.title as title, sub1.name as category, sub2.num as count
FROM (
SELECT f.film_id, f.title, c.name
FROM film f
JOIN film_category fc
ON f.film_id=fc.film_id
JOIN category c
ON c.category_id=fc.category_id
WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
) sub1
JOIN (
SELECT i.film_id, COUNT(r.rental_id)AS num
FROM inventory i
JOIN rental r
ON i.inventory_id=r.inventory_id
GROUP BY 1
) sub2
ON sub1.film_id=sub2.film_id
GROUP BY 1,2,3
ORDER BY 2,1


Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories?

SELECT f.title as name, c.name as category, f.rental_duration as duration,
       NTILE(4)OVER(ORDER BY f.rental_duration)
FROM film f
JOIN film_category fc
ON f.film_id=fc.film_id
JOIN category c
ON c.category_id=fc.category_id
WHERE c.name IN('Animation','Children','Classics','Comedy','Family','Music')


Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:
Category
Rental length category
Count

SELECT sub.category, sub.ntile, COUNT(*)
FROM(
SELECT f.title as name, c.name as category, f.rental_duration as duration,
       NTILE(4)OVER(ORDER BY f.rental_duration)
FROM film f
JOIN film_category fc
ON f.film_id=fc.film_id
JOIN category c
ON c.category_id=fc.category_id
WHERE c.name IN('Animation','Children','Classics','Comedy','Family','Music')) sub
GROUP BY 1,2
ORDER BY 1,2
