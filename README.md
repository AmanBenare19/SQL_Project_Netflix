# Netflix Movie and TV Show Analysis with SQL

![Netflix Logo](./Netflix_logo1.jpg)

## Description
This project aims to analyze Netflix's vast collection of movies and TV shows using SQL. By answering specific questions, we gain insights into the distribution, content variety, and trends in Netflix's library. The dataset used for this analysis was downloaded from Kaggle, and PostgreSQL is used for executing SQL queries.

## Objectives
- To perform an in-depth analysis of Netflix's movie and TV show database.
- To answer key questions about the content in Netflix's library, such as identifying the most frequent ratings, counting the number of movies and TV shows, and exploring various metadata attributes like country, genre, and actors.
- To demonstrate SQL proficiency by creating and executing queries based on real-world data.

## Dataset
The dataset used for this analysis is the Netflix Movies and TV Shows dataset, which is available on Kaggle. You can access and download the dataset from the following link: [Dataset link](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## Technologies Used
- PostgreSQL: Used for data manipulation and query execution.
- Kaggle Dataset: For raw data regarding Netflix's content.

### Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Business Problems and Solutions
### 1. Determine the count of Movies versus TV Shows.
```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```
### 2. Identify the most frequent rating assigned to movies and TV shows.
```sql
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
```
### 3. Display all movies released in a given year (e.g., 2018).
```sql
SELECT * 
FROM netflix
WHERE release_year = 2018
```
### 4. Find the top 5 countries with the highest volume of content on Netflix.
```sql

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
```
### 5. Locate the longest movie available on Netflix.
```sql

select * from 
 (select distinct title as movie,
  split_part(duration,' ',1):: numeric as duration 
  from netflix
  where type ='Movie') as subquery
where duration = (select max(split_part(duration,' ',1):: numeric ) from netflix)
```
### 6. Retrieve content added to Netflix within the last 5 years.
```sql

SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
```
### 7. List all movies and TV shows directed by 'Kirsten Johnson.'
```sql

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
```
### 8. Identify TV shows with more than 5 seasons.'
```sql

SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5
```
### 9. Count the total number of content items categorized by genre.
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1
```
### 10. Calculate the average yearly content release
in Canada on Netflix and return the top 5 years with the highest averages.

```sql
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
```
### 11. List all movies categorized as documentaries.
```sql
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'
```
### 12. Identify all content that lacks a director.
```sql
SELECT * FROM netflix
WHERE director IS NULL
```
### 13. Count the number of movies featuring actor 'Salman Khan' over the past 10 years.
```sql
SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```
### 14. Find the top 10 actors who have appeared in the most movies produced in Canada.
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'Canada'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
```
### 15. Classify content based on the presence of keywords 'kill' and 'violence' in descriptions, 
labeling them as 'Bad' or 'Good,' and count the number in each category.
``` sql
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
```
### Conclusion
This project gave us some interesting insights into Netflix’s content library using SQL. We explored how movies and TV shows are distributed, identified popular ratings, and looked at content trends across different countries and genres.

We also dug into details like the longest movie, multi-season TV shows, and yearly content releases. Analyzing keywords in descriptions even helped categorize content based on themes.

Overall, this project showed how SQL can be a powerful tool for analyzing real-world data and uncovering trends that could help in decision-making.












