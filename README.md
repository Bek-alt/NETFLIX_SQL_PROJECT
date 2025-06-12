# 
![Netflix Logo](https://github.com/Bek-alt/NETFLIX_SQL_PROJECT/blob/main/netflix_logo.png)
## Objective


##Dataset
The data for this project is sourced from the Kaggle dataset:


##QUESTIONS AND SOLUTIONS


1. **What are the top 3 most popular genres each year?**

```sql
WITH genre_counts AS (
  SELECT 
    release_year,
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS count
  FROM netflix
  GROUP BY release_year, genre
),
ranked_genres AS (
  SELECT *,
    RANK() OVER (PARTITION BY release_year ORDER BY count DESC) AS rnk
  FROM genre_counts
)
SELECT * FROM ranked_genres WHERE rnk <= 3
ORDER BY release_year, rnk;
```

2. **How many new titles were added each month for the last 3 years?**

```sql
SELECT 
  DATE_TRUNC('month', TO_DATE(date_added, 'Month DD, YYYY')) AS month_added,
  COUNT(*) AS total_titles
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '3 years'
GROUP BY month_added
ORDER BY month_added;
```

---

### 🆕 New and creative ones:

3. **Find the average duration of Movies vs. TV Shows**

```sql
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
```



5. **Which day of the week is Netflix most likely to add new content?**

```sql
SELECT 
  TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Day') AS weekday,
  COUNT(*) AS added_count
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY weekday
ORDER BY added_count DESC;
```

6. **Detect duplicate titles (same name, same type, different release years)**

```sql
SELECT 
  title,
  type,
  COUNT(*) as count_versions,
  STRING_AGG(release_year::text, ', ') as years
FROM netflix
GROUP BY title, type
HAVING COUNT(*) > 1
ORDER BY count_versions DESC;
```

7. **Find the shortest movie on Netflix**

```sql
SELECT * 
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT ASC
LIMIT 1;
```

8. **Which genre has the highest proportion of TV Shows?**

```sql
WITH genre_type_counts AS (
  SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    type,
    COUNT(*) AS count
  FROM netflix
  GROUP BY genre, type
),
genre_totals AS (
  SELECT genre, SUM(count) AS total
  FROM genre_type_counts
  GROUP BY genre
)
SELECT 
  g.genre,
  SUM(CASE WHEN gtc.type = 'TV Show' THEN gtc.count ELSE 0 END) * 100.0 / gt.total AS tv_show_ratio
FROM genre_type_counts gtc
JOIN genre_totals gt ON gtc.genre = gt.genre
GROUP BY g.genre, gt.total
ORDER BY tv_show_ratio DESC
LIMIT 10;
```

9. **Find which countries have produced the most Netflix Original content**

> *(Assuming “Netflix Original” appears in the title or description)*

```sql
SELECT 
  UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
  COUNT(*) AS original_count
FROM netflix
WHERE title ILIKE '%Netflix Original%'
GROUP BY country
ORDER BY original_count DESC
LIMIT 10;
```

10. **Find the median release year of all content on Netflix**

```sql
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY release_year) AS median_release_year
FROM netflix
WHERE release_year IS NOT NULL;
```

---

