/*1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/

USE Sakila;
-- DISTINCT selecciona todos los títulos no repetidos en la columna seleccionada (title) --
SELECT DISTINCT(title)
FROM film;


/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/

SELECT *
FROM film
LIMIT 5;

-- revisar la tabla film para ver dónde está el dato que buscamos. Comprobado que está en la columna rating

SELECT film_id, title, rating
FROM film
WHERE rating = "PG-13";

-- Devolver datos de las películas en las que aparece el registro PG-13 en el rating

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/

SELECT film_id, title, description
FROM film
WHERE description IN ("amazing");

-- query para seleccionar aquellos títulos en cuya description aparece el término requerido--

/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/

SELECT length
FROM film
LIMIT 10;
-- comprobar en la columna length de qué forma aparece la duración--


SELECT film_id, title, length
FROM film
WHERE length > 120
-- seleccionar los títulos de más de 120 minutos--

/*5. Recupera los nombres de todos los actores. */

SELECT (first_name + " " + last_name) AS nombre_actores
FROM actor;

-- creado un alias para que el nombre y el apellido aparezcan como un solo dato para facilitar lectura--

/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

SELECT first_name, last_name
FROM actor
WHERE last_name IN ("Gibson");

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/

SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- Devuelve las 11 columnas del id_actor 10 al 20, en el caso que por alguna razón se quisiera excluir estas se pediría, BETWEEN 11 AND 19--

/* 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/

SELECT title, rating
FROM film
WHERE rating NOT IN ("R") AND rating NOT IN ("PG-13");

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.*/

SELECT COUNT(film_id), rating
FROM film
GROUP BY rating;

-- agrupamos las películas por clasificaciones (rating) y contamos cuántas aparecen en cada tipo de clasificación--

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas.*/

SELECT * 
FROM customer
LIMIT 3;

SELECT * 
FROM rental
LIMIT 25;

-- localizar dónde están los datos que se necesitan, asumiendo que cada id_rental es una sola película --

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS cantidad_peliculas
FROM customer 
INNER JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
;
    /*utilizar un INNER JOIN me permite encontrar los registros comunes de dos tablas, aquí el customer.id y el rental.id, puesto que no 
    elimina los duplicados, me permite contarlos COUNT(rental-id) y saber cuántas películas. Finalmente, se agrupan las respuestas por los datos
    personales de cada cliente */


/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.*/

SELECT 












