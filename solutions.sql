-- Netflix Data Analysis using SQL - Solutions of 15 business problems

-- 1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*)
FROM netflix
GROUP BY 1


-- 2. Find the most common rating for both movies and TV shows  
select type, rating
from (
	SELECT type, rating 
	, COUNT(*) as rating_count
	,rank() over(partition by type order by count(*) desc) as rank
	FROM netflix
	group by 1,2
) e
where rank=1;


-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM netflix
WHERE type='Movie' and release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix
select 
TRIM( UNNEST(STRING_TO_ARRAY(country,',')) ) as country
,count(*) as total_content
from netflix
where country is not null
group by 1
order by 2 desc
limit 5

-- OR
-- select 
-- TRIM( UNNEST(STRING_TO_ARRAY(country,',')) ) as country
-- ,count(*) as total_content
-- from (
-- 	SELECT country 
-- 	FROM netflix
-- 	where country is not null
-- ) e
-- group by 1
-- order by 2 desc
-- limit 5


-- 5. Identify the longest movie
SELECT  title, duration_in_minutes
from ( SELECT 
	* 
	, split_part(duration,' ',1)::int as duration_in_minutes
	, rank() over( order by  split_part(duration,' ',1)::int desc ) as rank 
	FROM netflix
	WHERE type = 'Movie'
	and duration is not null 
) e
where rank = 1 

-- OR
-- SELECT *
-- FROM netflix
-- WHERE type = 'Movie' and  duration is not null 
-- ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
-- limit 1 


-- 6. Find content added in the last 5 years
SELECT*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT *
FROM netflix
WHERE director ilike '%Rajiv Chilaka%'

-- SELECT *
-- FROM ( SELECT *,
-- 	UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
-- 	FROM netflix
-- ) e
-- WHERE director_name = 'Rajiv Chilaka'


-- 8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE TYPE = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::INT > 5


-- 9. Count the number of content items in each genre
SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1


-- 10. Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release !
SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release , 
	round( count(show_id)::numeric*100/(select count(1) from netflix where country ilike '%india%')::numeric ,2) as average_release
FROM netflix
WHERE  country ilike '%india%' 
GROUP BY 1, 2
ORDER BY 3 DESC 
LIMIT 5


-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in iLIKE '%Documentaries%'


-- 12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT count(*) FROM netflix
WHERE casts iLIKE '%Salman Khan%' AND  release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) as actor,
	COUNT(*)
FROM netflix
WHERE country ilike '%India%'
GROUP BY 1
ORDER BY 2 desc 
LIMIT 10


-- 15: Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
SELECT 
	type,
	CASE 
		WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
		ELSE 'Good'
	END AS category ,
	count(*) as content_count
FROM netflix
group by 1 , 2
order by 3




-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM netflix
WHERE type='Movie' and release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix
select 
TRIM( UNNEST(STRING_TO_ARRAY(country,',')) ) as country
,count(*) as total_content
from (
	SELECT country 
	FROM netflix
	where country is not null
) e
group by 1
order by 2 desc
limit 5

-- OR
-- select 
-- TRIM( UNNEST(STRING_TO_ARRAY(country,',')) ) as country
-- ,count(*) as total_content
-- from netflix
-- where country != ''
-- group by 1
-- order by 2 desc
-- limit 5


-- 5. Identify the longest movie
SELECT  title, duration_in_minutes
from ( SELECT 
	* 
	, split_part(duration,' ',1)::int as duration_in_minutes
	, rank() over( order by  split_part(duration,' ',1)::int desc ) as rank 
	FROM netflix
	WHERE type = 'Movie'
	and duration is not null 
) e
where rank = 1 
