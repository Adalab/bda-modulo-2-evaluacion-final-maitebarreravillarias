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

SELECT *
FROM category;

SELECT * 
FROM inventory
LIMIT 5;

-- buscar dónde encontrar los datos que necesito--

    SELECT
    subquery.nombre_categoria,
    SUM(subquery.cantidad_alquileres) AS total_alquileres_categoria
FROM
    (SELECT
        category.name AS nombre_categoria,
        film.film_id,
        COUNT(rental.rental_id) AS cantidad_alquileres
    FROM
        rental
    INNER JOIN
        inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN
        film ON inventory.film_id = film.film_id
    INNER JOIN
        film_category ON film.film_id = film_category.film_id
    INNER JOIN
        category ON film_category.category_id = category.category_id
    GROUP BY
        category.name, film.film_id) AS subquery
GROUP BY
    subquery.nombre_categoria;


			/* para encontrar los datos he tenido que hacer varios inner join organizados en una subconsulta. Primero he necesita agrupar 
            cuántos alquileres tiene cada película, después las películas por categorías y finalmente sumar el número total de alquileres por categoría.
            Como el dato que me permite sumar los alquileres (rental_d, en la tabla rental)  no aparece el film_id (que es el que me permitirá 
            saber las categorías de las películas), tengo que utilizar la tabla inventario con varios INNER JOINs para poner en contacto unos datos
            y otros */
            
/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra la clasificación 
junto con el promedio de duración. */            


SELECT category.name, AVG(film.length) AS duracion_media, film_category.category_id
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY film_category.category_id, category.name;
		
        /* El dato duración está  en la tabla film, del que puedo sacar la media "AVG(film.length)", a partir de ahí, cruzo ese dato con 
        film_category.category_id, category.name con INNER JOIN y agrupo los resultados por el nombre de la categoría */
        

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/

		
        
SELECT actor.actor_id, actor.first_name, actor.last_name AS datos_actores
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Indian Love';

		   /* En la tabla actores encuentro la tabla de los actores, para llegar a la tabla film, donde puedo poner el WHERE con el título que 
           estoy buscando para poder hacer INNER JOIN, antes utilizo la tabla film_actor que relaciona las dos*/
   
/*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/
   
SELECT film.title,film.description 
FROM film
WHERE description IN ("dog", "cat");

	/* WHERE  permite seleccionar los registros de la columna title en los que aparezcan los valores señalados en la columna seleccionada*/
    
/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla `film_actor`.*/

SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_actor.actor_id IS NULL;

		/* un LEFT JOIN nos permite cruzar los datos comunes de dos tablas, si algún actor está en la tabla de la izquierda y no en el de la derecha,
        nos aparecería como NULL */
        
/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/


SELECT film.title, film.release_year
FROM film
WHERE release_year BETWEEN "2005" AND "2010";
        /* BETWEEN nos permite seleccionar un rango dentro de la restricción de columna del WHERE  */ 
        
/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family". */

SELECT title
FROM film
WHERE title = "Family";

		/* resuelvo la duda de si "Family" era el título de una película o de una categoría, buscándolo como título = no existe, es una categoría*/
SELECT film.title
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

	/* dos  INNER JOIN, para llegar desde la tabla film (donde tengo que dato que necesito, title) hasta category donde está category.name, utilizando
    como paso intermedio la tabla film_category, donde están film_id y category_id */
    
/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/

SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) > 10;

	/* necesito cruzar las tablas de peliculas y actores, lo hago pasando por la tabla intermedia film_actor. Los agrupo por actores 
    y como he utililos GROUP BY pongo ahí la restricción de que devuelva solo los que aparecen en más de 10*/ 
    
/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`. */

SELECT film.title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'R' AND film.length > 120;

    
    /* necesito encontrar las coincidencias de registros entre la tabla film donde tengo el título, (y el otro dato que necesito, la duración) con la alter
    tabla category, donde puedo buscar el nombre "R", como no tienen columnas comunes, utilizo la tabla film_category para llegar de una a otra*/

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría 
junto con el promedio de duración.*/


SELECT category.name, AVG(film.length) AS duracion_promedio
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
HAVING AVG(film.length) > 120;

	/* la duración de las películas es un dato de la tabla film, del que puedo sacar directamente el promedio, pero para encontrar las categorías y 
    agruparlas por categorías necesito llegar a la tabla category pasando por la tabla intermedia film_category. Como las agrupo, por nombre de categoría,
    mediante un Group by, es en su having en el que introduzco la restricción de solo mostrar las de más de 120 minutos*/
    
/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas 
en las que han actuado.*/


SELECT CONCAT(actor.actor_id, " ", actor.first_name, " ", actor.last_name) AS nombre_actores, COUNT(film_actor.film_id) 
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) >= 5; 

	/* esta vez he concatenado id, nombre y apellido como una entrada única para mayor facilidad de lectura. necesito cruzar los tablas de actores 
    y la de películas, con un JOIN. Finalmente presentar las respuestas agrupadas por los actores, mediante un GROUP BY, en su HAVING introduzco la 
    restricción del número de películas en las que han participado (al menos 5).*/

/*22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_id con una 
duración superior a 5 días y luego selecciona las películas correspondientes.*/


SELECT film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IN (
    SELECT rental_id
    FROM rental
    WHERE (return_date - rental_date) > 5
); 
	/* la subconsulta, definida primero de todo, me permite definir las películas alquiladas durante más de 5 días (restando al día de la 
    entrega el día de alquiler), coloco esta selección como WHERE, como restricción del cruce (INNER)de las tablas film (donde está title) y rental, 
    llegando de una a otra, mediante la tabla intermedia inventory, con otro INNER.*/
    
/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta
para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/

SELECT actor.actor_id, actor.first_name, actor.last_name AS nombre_actores
FROM actor
WHERE actor.actor_id NOT IN (
	SELECT film_actor.actor_id
    FROM film_actor
    JOIN film_category ON film_actor.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = 'Horror'
);
   
	/* En este caso es el la subconsulta donde debo hacer los join. cruzo las tablas de categorías y películas, para 
    obtener las categorías de las películas (y excluyo con un WHERE las que pertenecen al género "Horror") y el resultado de esto
    me permite crear la restricción, con un WHERE, de la tabla de actores */
    

/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.*/

SELECT category.name
FROM category;
			/* compruebo cómo aparece "comedia" en la tabla */


SELECT film.title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Comedy' AND film.length > 180;

		/* los títulos de las películas (y su duración) están en la tabla film, para saber sus categorías lo cruzo con la tabla categoría, 
        a través de la tabla intermedia film_category, con dos joins. A este resultado le puedo poner las dos restricciones con un WHERE, una por género, 
        que encuentro en la tabla category y otro por duración, con una función agregada sobre una columna de la tabla film */ 
        

/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores 
y el número de películas en las que han actuado juntos.*/


SELECT CONCAT(a1.first_name, ' ', a1.last_name) AS actor1,
       CONCAT(a2.first_name, ' ', a2.last_name) AS actor2,
       COUNT(film_actor1.film_id) AS peliculas_en_comun
FROM actor a1
CROSS JOIN actor a2
JOIN film_actor film_actor1 ON a1.actor_id = film_actor1.actor_id
JOIN film_actor film_actor2 ON a2.actor_id = film_actor2.actor_id AND film_actor1.film_id = film_actor2.film_id
WHERE a1.actor_id < a2.actor_id
GROUP BY actor1, actor2
HAVING peliculas_en_comun > 0;

		/* cros join, que ofrece todas las combinaciones posibles de las columnas seleccionadas. En este caso los CONCAT que son el actor1
        y el del actor2. cruzando cada uno de estos nombres de actores con la tabla film_actor, encuentro las películas en las que ha 
        participado cada uno. un cross join me ofrece todas las combinación de actor y película, en las que aparece uno y otro. El GROUP BY agrupa 
        los resultados por los nombres de actores, retirando aquellos que no tienen ninguna en común. Finalmente, el resultado que se ofrece (que 
        he expresado en el SELECT) devuelve la suma de películas en común. Honestamente, la idea de hacer cross join es mía, y la sintaxis, de chatGPT 
         */











