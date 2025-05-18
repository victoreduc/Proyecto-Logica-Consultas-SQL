-- 1. Crea el esquema de la BBDD.
-- Véase archivo --> esquema-bbdd.png

-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
SELECT title FROM film WHERE rating='R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT first_name, last_name FROM actor WHERE actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT title FROM film WHERE language_id=original_language_id;

-- 5. Ordena las películas por duración de forma ascendente.
SELECT title, length FROM film ORDER BY length ASC;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%Allen%';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
SELECT rating, COUNT(*) AS total FROM film GROUP BY rating;

-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
SELECT title FROM film WHERE rating = 'PG-13' OR length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT VAR_POP(replacement_cost) FROM film;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT MAX(length) AS max_duracion, MIN(length) AS min_duracion FROM film;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT amount FROM payment ORDER BY payment_date DESC LIMIT 1 OFFSET 2;

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.
SELECT title FROM film WHERE rating NOT IN ('NC17', 'G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating, AVG(length) AS avg_length FROM film GROUP BY rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT title FROM film WHERE length > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(amount) FROM payment;

-- 16. Muestra los 10 clientes con mayor valor de id.
SELECT * FROM customer ORDER BY customer_id DESC LIMIT 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’
SELECT first_name, last_name 
FROM actor
JOIN film_actor ON actor.actor_id=film_actor.actor_id
JOIN film ON film.film_id=film_actor.film_id
WHERE title='Egg Igby'
ORDER BY first_name, last_name;

-- 18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT title FROM film;

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
SELECT title 
FROM film 
JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON film_category.category_id=category.category_id
WHERE name='Comedy' AND length>180;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT name, AVG(length) AS avg_duration
FROM film
JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON film_category.category_id=category.category_id
GROUP BY name
HAVING AVG(length)>110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(rental_duration) FROM film;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo FROM actor;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT DATE(rental.rental_date) AS fecha, COUNT(*) AS total_alquileres
FROM rental
GROUP BY DATE(rental.rental_date)
ORDER BY total_alquileres DESC;

-- 24. Encuentra las películas con una duración superior al promedio.
SELECT * FROM film WHERE length > (SELECT AVG(length) FROM film);

-- 25. Averigua el número de alquileres registrados por mes.
SELECT TO_CHAR(rental.rental_date, 'YYYY-MM') AS mes, COUNT(*) AS total_alquileres
FROM rental
GROUP BY TO_CHAR(rental.rental_date, 'YYYY-MM')
ORDER BY mes;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT AVG(payment.amount) AS promedio, STDDEV(payment.amount) AS desviacion_estandar, VARIANCE(payment.amount) AS varianza
FROM payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
SELECT DISTINCT film.title
FROM film
JOIN inventory ON film.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
JOIN payment ON rental.rental_id=payment.rental_id
WHERE payment.amount>(SELECT AVG(payment.amount) FROM payment);

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT film_actor.actor_id
FROM film_actor
GROUP BY film_actor.actor_id
HAVING COUNT(film_actor.film_id) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT film.title, COUNT(inventory.inventory_id) AS cantidad_disponible
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
GROUP BY film.title;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS total_peliculas
FROM actor
JOIN film_actor ON actor.actor_id=film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT film.title, actor.first_name, actor.last_name
FROM film
LEFT JOIN film_actor ON film.film_id=film_actor.film_id
LEFT JOIN actor ON film_actor.actor_id=actor.actor_id;

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT actor.first_name, actor.last_name, film.title
FROM actor
LEFT JOIN film_actor ON actor.actor_id=film_actor.actor_id
LEFT JOIN film ON film_actor.film_id=film.film_id;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT film.title, rental.rental_date
FROM film
LEFT JOIN inventory ON film.film_id=inventory.film_id
LEFT JOIN rental ON inventory.inventory_id=rental.inventory_id;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount) AS total_gastado
FROM customer
JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_gastado DESC LIMIT 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT * FROM actor WHERE first_name = 'Johnny';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT first_name AS Nombre, last_name AS Apellido FROM actor;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN(actor_id) AS id_min, MAX(actor_id) AS id_max FROM actor;

-- 38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(*) FROM actor;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT * FROM actor ORDER BY last_name ASC;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT * FROM film LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT first_name, COUNT(*) AS total FROM actor GROUP BY first_name ORDER BY total DESC LIMIT 1;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT rental.rental_id, rental.rental_date, customer.first_name, customer.last_name
FROM rental
JOIN customer ON rental.customer_id = customer.customer_id;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT customer.customer_id, customer.first_name, customer.last_name, rental.rental_id, rental.rental_date
FROM customer
LEFT JOIN rental ON customer.customer_id=rental.customer_id;

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT film.title, category.name FROM film CROSS JOIN category;
-- Esta consulta no aporta valor pues los resultados que muestra son irreales, cruzan los datos de ambas tablas de manera desestructurada.

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id=film_actor.actor_id
JOIN film ON film_actor.film_id=film.film_id
JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON film_category.category_id=category.category_id
WHERE category.name = 'Action';

-- 46. Encuentra todos los actores que no han participado en películas.
SELECT * FROM actor WHERE actor_id NOT IN (SELECT DISTINCT actor_id FROM film_actor);

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS cantidad_peliculas
FROM actor
JOIN film_actor ON actor.actor_id=film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name;

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS
SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS cantidad_peliculas
FROM actor
JOIN film_actor ON actor.actor_id=film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_alquileres
FROM customer
JOIN rental ON customer.customer_id=rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT SUM(film.length) AS duracion_total
FROM film
JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON film_category.category_id=category.category_id
WHERE category.name='Action';

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_alquileres
FROM customer
JOIN rental ON customer.customer_id=rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name;

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT film.film_id, film.title, COUNT(rental.rental_id) AS total_alquileres
FROM film
JOIN inventory ON film.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
GROUP BY film.film_id, film.title
HAVING COUNT(rental.rental_id)>=10;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
SELECT DISTINCT film.title
FROM film
JOIN inventory ON film.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
JOIN customer ON rental.customer_id=customer.customer_id
WHERE customer.first_name = 'Tammy' AND customer.last_name = 'Sanders' AND rental.return_date IS NULL
ORDER BY film.title;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id=film_actor.actor_id
JOIN film ON film_actor.film_id=film.film_id
JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON film_category.category_id=category.category_id
WHERE category.name='Sci-Fi'
ORDER BY actor.last_name;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_date > (SELECT MIN(rental.rental_date)
FROM film
JOIN inventory ON film.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
WHERE film.title = 'Spartacus Cheaper')
ORDER BY actor.last_name;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id NOT IN (SELECT DISTINCT actor.actor_id
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film.film_id = film_actor.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name = 'Music');

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT film.title
FROM film
JOIN inventory ON film.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
WHERE DATE_PART('day', rental.return_date-rental.rental_date)>8;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT DISTINCT film.title
FROM film
JOIN film_category ON film.film_id=film_category.film_id
WHERE film_category.category_id=(SELECT category.category_id
FROM category
WHERE category.name='Animation');

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
SELECT film.title
FROM film
WHERE film.length=(SELECT length FROM film WHERE title='Dancing Fever')
ORDER BY film.title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT customer.first_name, customer.last_name
FROM customer
JOIN rental ON customer.customer_id=rental.customer_id
JOIN inventory ON rental.inventory_id=inventory.inventory_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
HAVING COUNT(DISTINCT inventory.film_id)>=7
ORDER BY customer.last_name;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT category.name, COUNT(rental.rental_id) AS total_alquileres
FROM rental
JOIN inventory ON rental.inventory_id=inventory.inventory_id
JOIN film ON inventory.film_id=film.film_id
JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON film_category.category_id=category.category_id
GROUP BY category.name;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT category.name, COUNT(film.film_id) AS total_peliculas
FROM film
JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON film_category.category_id=category.category_id
WHERE film.release_year=2006
GROUP BY category.name;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT staff.first_name, staff.last_name, store.store_id FROM staff CROSS JOIN store;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_alquileres
FROM customer
JOIN rental ON customer.customer_id=rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name;