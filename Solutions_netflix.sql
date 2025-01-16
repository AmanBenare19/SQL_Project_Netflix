-- Solutions -- 

--1. Determine the count of Movies versus TV Shows.

SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY 1

-- 2. Identify the most frequent rating assigned to movies and TV shows.

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


-- 3. Display all movies released in a given year (e.g., 2018).

SELECT * 
FROM netflix
WHERE release_year = 2018


-- 4. Find the top 5 countries with the highest volume of content on Netflix.

SELECT * 
FROM
(
	SELECT 
		-- country,
		TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as country,
		COUNT(*) as total_content
	FROM netflix
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5


-- 5. Locate the longest movie available on Netflix.

select * from 
 (select distinct title as movie,
  split_part(duration,' ',1):: numeric as duration 
  from netflix
  where type ='Movie') as subquery
where duration = (select max(split_part(duration,' ',1):: numeric ) from netflix)

-- 6. Retrieve content added to Netflix within the last 5 years.
SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


-- 7. List all movies and TV shows directed by 'Kirsten Johnson.'

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
	director_name = 'Kirsten Johnson'



-- 8. Identify TV shows with more than 5 seasons.

SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5


/* 9. Calculate the average yearly content release in India on Netflix and 
return the top 5 years with the highest averages.*/

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1


/*10. Calculate the average yearly content release
in Canada on Netflix and return the top 5 years with the highest averages. !*/


SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'Canada')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'Canada' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5


-- 11. List all movies categorized as documentaries.
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'



-- 12. Identify all content that lacks a director.
SELECT * FROM netflix
WHERE director IS NULL


-- 13. Count the number of movies featuring actor 'Salman Khan' over the past 10 years.

SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in Canada.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'Canada'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*
Question 15:
Classify content based on the presence of keywords 'kill' and 'violence' in descriptions, 
labeling them as 'Bad' or 'Good,' and count the number in each category..
*/

SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2



-- END -- 