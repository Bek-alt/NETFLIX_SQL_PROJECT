# 
![Netflix Logo](https://github.com/Bek-alt/NETFLIX_SQL_PROJECT/blob/main/netflix_logo.png)
## Objective


##Dataset
The data for this project is sourced from the Kaggle dataset:


##QUESTIONS AND SOLUTIONS


#### **1. Difference Between the Numbers of Movies and TV Shows**

```sql
SELECT
  ABS(
    (SELECT COUNT(*) FROM netflix WHERE type = 'Movie') -
    (SELECT COUNT(*) FROM netflix WHERE type = 'TV Show')
  ) AS difference;
```

> Returns the absolute difference between the number of movies and TV shows.

---

#### **2. List TV Shows Released in a Specific Year (e.g., 2019)**

```sql
SELECT *
FROM netflix
WHERE release_year = 2019
  AND type = 'TV Show';
```

> Filters TV shows by release year.

---

#### **3. Top 3 Countries (Excluding USA and India) With Most Content**

```sql
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
```

> Splits multi-country fields, excludes USA and India, and shows the top 3 remaining.

---

#### **4. Identify the Shortest Movies**

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT;
```

> Sorts movies by duration in ascending order.

---

#### **5. Count of Movies Actor ‘Lorena Franco’ Appeared in Last 10 Years**

```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Lorena Franco%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

> Filters movies by actor and recent 10-year window.

---

#### **6. All Movies/TV Shows by Director ‘Troy Byer’**

```sql
SELECT *
FROM (
  SELECT *,
         UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
  FROM netflix
) AS sub
WHERE director_name = 'Troy Byer';
```

> Handles multiple directors per entry and filters by name.

---

#### **7. List All TV Shows With Exactly 3 Seasons**

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT = 3;
```

> Filters TV shows with 3 seasons.

---

#### **8. Average Duration of Movies vs. TV Shows**

```sql
SELECT 
  type,
  AVG(CASE 
        WHEN type = 'Movie' THEN SPLIT_PART(duration, ' ', 1)::INT
      END) AS avg_movie_minutes,
  AVG(CASE 
        WHEN type = 'TV Show' THEN SPLIT_PART(duration, ' ', 1)::INT
      END) AS avg_tv_seasons
FROM netflix
GROUP BY type;
```

> Calculates the average duration for each type (in minutes or seasons).

---

#### **9. Which Day of the Week Netflix Adds Most Content**

```sql
SELECT 
  TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Day') AS weekday,
  COUNT(*) AS added_count
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY weekday
ORDER BY added_count DESC;
```

> Parses the date and aggregates additions by weekday.

---

#### **10. Median Release Year of All Content**

```sql
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY release_year) AS median_release_year
FROM netflix
WHERE release_year IS NOT NULL;
```

> Uses a percentile function to find the median release year.

---


