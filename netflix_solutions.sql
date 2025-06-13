-- Netflix Data Analysis using SQL
-- Solutions of 10 business problems
-- SCHEMAS of Netflix

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;
-- Netflix Data Analysis using SQL
-- Solutions of 10 problems
-- 1. Difference between the numbers of Movies and TV Shows

SELECT
  ABS(
    (SELECT COUNT(*) FROM netflix WHERE type = 'Movie') -
    (SELECT COUNT(*) FROM netflix WHERE type = 'TV Show')
  ) AS difference;

-- 2. List TV shows released in a specific year (e.g., 2019)

SELECT *
FROM netflix
WHERE release_year = 2019
  AND type = 'TV Show';


-- 3. Find the top 3 countries not including USA and India with the most content on Netflix

SELECT country, COUNT(*) AS total_content
FROM (
    SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country
    FROM netflix
    WHERE country IS NOT NULL
) AS t1
WHERE country NOT IN ('United States', 'India')
GROUP BY country
ORDER BY total_content DESC
LIMIT 3;


-- 4. Identify the shortest Movies

SELECT 
    *
FROM netflix
WHERE type = 'Movies'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT;

-- 5. Find how many movies actor 'Lorena Franco' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
	casts LIKE '%Lorena Franco%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10




-- 6. Find all the movies/TV shows by director 'Troy Byer'!

SELECT *
FROM
(

SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM 
netflix
)
WHERE 
	director_name = 'Troy Byer'



-- 7. List all TV shows with with 3 seasons

SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT = 3

--8. Find the average duration of Movies vs. TV Shows

SELECT 
  type,
  AVG(CASE 
        WHEN type = 'Movie' THEN SPLIT_PART(duration, ' ', 1)::INT
        WHEN type = 'TV Show' THEN NULL
      END) AS avg_movie_minutes,
  AVG(CASE 
        WHEN type = 'TV Show' THEN SPLIT_PART(duration, ' ', 1)::INT
        WHEN type = 'Movie' THEN NULL
      END) AS avg_tv_seasons
FROM netflix
GROUP BY type;

--9. Which day of the week is Netflix most likely to add new content?


SELECT 
  TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Day') AS weekday,
  COUNT(*) AS added_count
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY weekday
ORDER BY added_count DESC;

--10. Find the median release year of all content on Netflix

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY release_year) AS median_release_year
FROM netflix
WHERE release_year IS NOT NULL;


---KONETS






















