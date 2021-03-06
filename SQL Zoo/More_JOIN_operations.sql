-- http://sqlzoo.net/wiki/More_JOIN_operations


/* 1. List the films where the yr is 1962 [Show id, title] */

SELECT
    id,
    title
  FROM
    movie
  WHERE
    yr = 1962;


/* 2. Give year of 'Citizen Kane'. */

SELECT
    yr
  FROM
    movie
  WHERE
    title = 'Citizen Kane';


/* 3. List all of the Star Trek movies, include the id, title and yr
(all of these movies include the words Star Trek in the title). Order results by year. */

SELECT
    id,
    title,
    yr
  FROM
    movie
  WHERE
    title LIKE '%Star Trek%';


/* 4. What are the titles of the films with id 11768, 11955, 21191 */

SELECT
    title
  FROM
    movie
  WHERE
    id in (11768, 11955, 21191);


/* 5. What id number does the actress 'Glenn Close' have? */

SELECT
    id
  FROM
    actor
  WHERE
    name = 'Glenn Close';


/* 6. What is the id of the film 'Casablanca' */

SELECT
    id
  FROM
    movie
  WHERE
    title = 'Casablanca';


/* 7. Obtain the cast list for 'Casablanca'. */

SELECT
    actor.name
  FROM
    actor
      JOIN casting ON actor.id = casting.actorid
      JOIN movie ON casting.movieid = movie.id
  WHERE
    movie.title = 'Casablanca';


/* 8. Obtain the cast list for the film 'Alien' */

SELECT
    actor.name
  FROM
    actor
      JOIN casting ON actor.id = casting.actorid
      JOIN movie ON casting.movieid = movie.id
  WHERE
    movie.title = 'Alien';


/* 9. List the films in which 'Harrison Ford' has appeared */

SELECT
    movie.title
  FROM
    movie
      JOIN casting ON movie.id = casting.movieid
      JOIN actor ON casting.actorid = actor.id
  WHERE
    actor.name = 'Harrison Ford';


/* 10. List the films where 'Harrison Ford' has appeared - but not in the starring role.
[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role] */

SELECT
    movie.title
  FROM
    movie
      JOIN casting ON movie.id = casting.movieid
      JOIN actor ON casting.actorid = actor.id
  WHERE
    actor.name = 'Harrison Ford' AND
    casting.ord > 1;


/* 11. List the films together with the leading star for all 1962 films. */

SELECT
    movie.title,
    actor.name
  FROM
    movie
      JOIN casting ON movie.id = casting.movieid
      JOIN actor ON casting.actorid = actor.id
  WHERE
    movie.yr = 1962 AND
    casting.ord = 1;


/* 12. Which were the busiest years for 'John Travolta',
show the year and the number of movies he made each year for any year in which he made more than 2 movies. */

SELECT
    movie.yr,
    COUNT(title)
  FROM
    movie
      JOIN casting ON movie.id = casting.movieid
      JOIN actor ON casting.actorid = actor.id
  WHERE
    actor.name = 'John Travolta'
  GROUP BY
    movie.yr
  HAVING
    COUNT(title) = (
      SELECT
          MAX(nb_movies)
        FROM (
          SELECT
              yr,
              COUNT(title) AS nb_movies
            FROM
              movie
                JOIN casting ON movie.id = casting.movieid
                JOIN actor ON casting.actorid = actor.id
            WHERE
              name = 'John Travolta'
            GROUP BY
              yr) subq);


/* 13. List the film title and the leading actor for all of the films 'Julie Andrews' played in. */

SELECT
    movie.title,
    actor.name
  FROM
    movie
      JOIN casting ON movie.id = casting.movieid
      JOIN actor ON casting.actorid = actor.id
  WHERE
    casting.ord = 1 AND
    movie.id IN (
      SELECT
          movie.id
        FROM
          movie
            JOIN casting ON movie.id = casting.movieid
            JOIN actor ON casting.actorid = actor.id
        WHERE
          actor.name = 'Julie Andrews');


/* 14. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles. */

SELECT
    actor.name
  FROM
    actor
      JOIN casting ON actor.id = casting.actorid
      JOIN movie ON casting.movieid = movie.id
  WHERE
     casting.ord = 1
  GROUP BY
     actor.name
  HAVING
     COUNT(movie.title) >= 30;


/* 15. List the films released in the year 1978 ordered by the number of actors in the cast. */

SELECT
    movie.title,
    COUNT(actorid) AS actors
  FROM
    movie
      JOIN casting ON movie.id = casting.movieid
  WHERE
    movie.yr = 1978
  GROUP BY
    movie.title
  ORDER BY
    actors DESC


/* 16. List all the people who have worked with 'Art Garfunkel'. */

SELECT
    actor.name
  FROM
    actor
      JOIN casting ON actor.id = casting.actorid
      JOIN movie ON casting.movieid = movie.id
  WHERE
    actor.name != 'Art Garfunkel' AND
    movie.id IN (
      SELECT
          movie.id
        FROM
          movie
            JOIN casting ON movie.id = casting.movieid
            JOIN actor ON casting.actorid = actor.id
        WHERE
          actor.name = 'Art Garfunkel');
