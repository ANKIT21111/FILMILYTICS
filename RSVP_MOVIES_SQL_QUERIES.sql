USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select * from information_schema.tables; -- INFORMATION_SCHEMA is a special schema in SQL which contains the metadata
										 -- of all the tables within the databases that are present . 
SELECT table_name,
       table_rows -- Finding the total number of rows in each table of our DB imdb
FROM   information_schema.tables -- Using INFORMATION_SCHEMA to fetch the details of all the tables 
WHERE  table_schema = 'imdb';    -- within the imdb database

-- role_mapping is the table with highest number of data with 17285 rows and director_mapping table is having lesser number of rows with 3867 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id_null,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_null,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_null,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_null,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_null,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_null,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS gross_income_null,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_null,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS company_production_null
FROM   movie; 
-- In the movie table there are around 4 columns which are having null values which are country , gross_income,languages and company production having 
-- 20,3724,194,528 null values respectively in each columns.

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year,
       Count(*) AS number_of_movies
FROM   movie
GROUP  BY year; 
-- +---------------+-------------------+
-- | Year			|	number_of_movies|
-- +-------------------+----------------
-- |	2017		|	3052			|
-- |	2018		|	2944 			|
-- |	2019		|	2001			|
-- +---------------+-------------------+

select month(date_published) as month_number,
count(*) as number_of_movies
from movie 
group by month_number
order by number_of_movies DESC;
-- # month_number	number_of_movies
-- 		 3	        824
-- 		 9	        809
--       1	        804
--       10	        801
--       4	        680
--       8	        678
--       2	        640
--      11	        625
--       5	        625
--       6	        580
--       7	        493
--       12	        438

-- March was the month when highest number of movies around 824 movies produced and November and May were the month having same amount of movies producing month with 625.
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT year,
       Count(title) AS number_of_movies
FROM   movie
WHERE  ( country LIKE '%INDIA%' OR country LIKE '%USA%'
		)
       AND year = 2019; 
-- USA 758 AND INDIA 309 TOATAL 1059 movies both USA and INDIA in combination produced in 2019
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre; 

-- 'Drama'
-- 'Fantasy'
-- 'Thriller'
-- 'Comedy'
-- 'Horror'
-- 'Family'
-- 'Romance'
-- 'Adventure'
-- 'Action'
-- 'Sci-Fi'
-- 'Crime'
-- 'Mystery'
-- 'Others'
-- 13 types of genre of movies are listed in genre table  
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT     genre,
           Count(mov.id) AS number_of_movies
FROM       movie       AS mov
INNER JOIN genre       AS gen
where      gen.movie_id = mov.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;

-- Drama genre with total of 4285 movies produced the highest number of movies  
/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH single_genre
     AS (SELECT movie_id,
                Count(genre) AS genre_number
         FROM   genre
         GROUP  BY movie_id
         HAVING genre_number = 1)
SELECT Count(movie_id) AS one_genre_movie
FROM   single_genre; 

-- There are total of 3289 movies which are based on single genre produced in the whole data
/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
       Round(Avg(duration), 2) AS average_duration
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON gen.movie_id = mov.id
GROUP  BY genre
ORDER  BY average_duration DESC; 
-- genre	average_duration
-- Action	112.88
-- Romance	109.53
-- Crime	107.05
-- Drama	106.77
-- Fantasy	105.14
-- Comedy	102.62
-- Adventure101.87
-- Mystery	101.80
-- Thriller	101.58
-- Family	100.97
-- Others	100.16
-- Sci-Fi	97.94
-- Horror	92.72
-- Action genre have the highest number of average duration of movies produced with 112.88 mins .
/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH thrill_gen
     AS (SELECT genre,
                Count(movie_id)                     AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC ) AS GENRE_RANK
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   thrill_gen
WHERE  genre = "thriller"; 

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|Thriller		|	1484			|			3		  |
+---------------+-------------------+---------------------+*/
/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 

-- +---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
-- | min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
-- +---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
-- |		1.0		|			10.0	|	       100		  |	   725138   		 |		1.0	       |	10.0			 |
-- +---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

-- Largest person got votes around 725138 and lowest votes getting is only 100 votes.

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT     title,
           avg_rating,
           Dense_rank() OVER(ORDER BY avg_rating DESC) AS rank_of_movies
FROM       ratings                                     AS rate
INNER JOIN movie                                       AS mov
ON         mov.id=rate.movie_id limit 10;
-- # title	                   avg_rating	rank_of_movies
--   Kirket	                       10.0	        1
--   Love in Kilnerry              10.0     	1
--   Gini Helida Kathe              9.8      	2
--   Runam	                        9.7         3
--   Fan	                        9.6	        4
--   Android Kunjappan Version5.25	9.6	        4
--   Yeh Suhaagraat Impossible	    9.5	        5
--   Safe	                        9.5    	    5
--   The Brighton Miracle	        9.5	        5
--   Shibu	                        9.4      	6
-- Kirket and Love in Kilnerry is the movie with highest average ratings with 10.0 and Shibu is last movie to be in top 10 with average rating of around 9.4  
/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
       Count(DISTINCT movie_id) AS number_of_movies
FROM   ratings AS rate
       INNER JOIN movie AS mov
               ON mov.id = rate.movie_id
GROUP  BY median_rating
ORDER  BY median_rating ASC; 
-- median_rating	number_of_movies
-- 1	            94
-- 2	            119
-- 3	            283
-- 4	            479
-- 5	            985
-- 6	            1975
-- 7	            2257
-- 8	            1030
-- 9	            429
-- 10	            346
-- Number of movies 2257 got median rating around 7 is the highest 
/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH greatmovie
     AS (SELECT id,
                title,
                production_company,
                avg_rating
         FROM   movie AS mov
                INNER JOIN ratings AS rate
                        ON mov.id = rate.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL)
SELECT production_company,
       Count(DISTINCT id)                    AS number_of_movies,
       Dense_rank()
         OVER(
           ORDER BY Count(DISTINCT id) DESC) AS rank_of_production_company
FROM   greatmovie
GROUP  BY production_company
ORDER  BY number_of_movies DESC; 
-- Dream Warrior Pictures or National Theatre Live are the highest number of movies producing production company around 3 movies each . 
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:
+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH USAMOVIES
     AS (SELECT id,
                year,
                date_published,
                country,
                genre,
                total_votes
         FROM   movie AS mov
                INNER JOIN genre AS gen
                        ON mov.id = gen.movie_id
                INNER JOIN ratings AS rate
                        ON mov.id = rate.movie_id
         WHERE  Month(date_published) = 3
                AND year = 2017
                AND country LIKE '%USA%'
                AND total_votes > 1000)
SELECT genre,
       Count(DISTINCT id) AS count_of_movies
FROM   USAMOVIES
GROUP  BY genre
ORDER  BY count_of_movies DESC; 

-- genre		count_of_movies
-- Drama		24
-- Comedy		9
-- Action		8
-- Thriller		8
-- Sci-Fi		7
-- Crime		6
-- Horror		6
-- Mystery		4
-- Romance		4
-- Adventure	3
-- Fantasy		3
-- Family		1
 
-- Drama was the genre in USA which have highest number of movies around 24 which got more than 1000 votes 

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON mov.id = gen.movie_id
       INNER JOIN ratings AS rate
               ON mov.id = rate.movie_id
WHERE  title LIKE'The%'
       AND avg_rating > 8
ORDER  BY genre; 
-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
SELECT title,
       median_rating,
       genre
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON mov.id = gen.movie_id
       INNER JOIN ratings AS rate
               ON mov.id = rate.movie_id
WHERE  title LIKE'The%'
       AND avg_rating > 8
ORDER  BY genre; 
-- There are total 8 movies starting with 'The' keyword with medain_rating greater than 8 
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(DISTINCT id) AS Number_of_movies -- count of movies
FROM   movie AS mov
INNER JOIN ratings AS rate -- joining movies and ratings tables
		ON mov.id = rate.movie_id
WHERE  (date_published BETWEEN '2018-04-01' AND '2019-04-01')
       AND median_rating = 8;
-- BETWEEN '2018-04-01' AND '2019-04-01' total of 361 movies produced among all got ratings 8 
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT country,
       Sum(total_votes) AS Count_of_Votes
FROM   movie AS mov
       INNER JOIN ratings AS rate
               ON mov.id = rate.movie_id
WHERE  country IN ( 'GERMANY', 'ITALY' )
GROUP  BY country; 
-- 
-- Answer is Yes Germany is having higher number of votes than Italian movies with difference of 28745 votes.

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select * from names;
SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           END) AS nullin_names,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS nullin_heights,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS nullin_date_of_birth,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS nullin_known_for_movies
FROM   names; 

-- +---------------+-------------------+---------------------+------------------------+
-- | nullin_names  |	nullin_heights	|nullin_date_of_birth  |nullin_known_for_movies|
-- +---------------+-------------------+---------------------+------------------------+
-- |		0		|			17335	|	       13431	  |	   15226	    	   |
-- +---------------+-------------------+---------------------+----------------------+*/
-- Names table is having 3 columns having null values which are nullin_heights,nullin_date_of_birth and nullin_known_for_movies with 17335 , 13431 and 15226 null values presence.
/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH topgen AS
(
           SELECT     genre,
                      Count(gen.movie_id) AS movie_count
           FROM       genre               AS gen
           INNER JOIN ratings             AS r
           ON         gen.movie_id = r.movie_id
           WHERE      avg_rating > 8
           GROUP BY   genre
           ORDER BY   movie_count DESC limit 3 ),
top_direct AS
(
           SELECT     nam.NAME                                             AS director_name,
                      Count(gen.movie_id)                                  AS movie_count,
                      Row_number() OVER(ORDER BY Count(gen.movie_id) DESC) AS director_row_rank
           FROM       names                                                AS nam
           INNER JOIN director_mapping                                     AS directm
           ON         nam.id = directm.name_id
           INNER JOIN genre AS gen
           ON         directm.movie_id = gen.movie_id
           INNER JOIN ratings AS rate
           ON         rate.movie_id = gen.movie_id,
                      topgen
           WHERE      gen.genre IN (topgen.genre)
           AND        avg_rating > 8
           GROUP BY   director_name
           ORDER BY   movie_count DESC )
SELECT director_name,
       movie_count
FROM   top_direct limit 3;

-- +---------------+--------------------+
-- | director_name	|	movie_count		|
-- +---------------+--------------------|
-- |James Mangold	|		4			|
-- |Soubin Shahir	|		3			|
-- |Joe Russo		|		3			|
-- +---------------+--------------------+ */
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT nam.name        AS actors_name,
       Count(movie_id) AS movies_count
FROM   role_mapping AS role_map
       INNER JOIN movie AS mov
               ON mov.id = role_map.movie_id
       INNER JOIN ratings AS rate USING(movie_id)
       INNER JOIN names AS nam
               ON nam.id = role_map.name_id
WHERE  rate.median_rating >= 8
       AND category = 'ACTOR'
GROUP  BY actors_name
ORDER  BY movies_count DESC
LIMIT  2; 
-- +---------------+-------------------+
-- | actor_name	|	movie_count		|
-- +-------------------+----------------
-- |	'Mammootty' |		8			|
-- |	'Mohanlal'	|		5			|
-- +---------------+-------------------+ */
/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH top_prod_house AS(
SELECT production_company, sum(total_votes) AS count_of_votes,
	RANK() OVER(ORDER BY SUM(total_votes) DESC) AS rankings_production
FROM movie AS mov
	INNER JOIN ratings AS rate ON rate.movie_id=mov.id
GROUP BY production_company)
SELECT production_company, count_of_votes, rankings_production
FROM top_prod_house
WHERE rankings_production<4;

-- +------------------------+--------------------+---------------------+
-- |production_company      |vote_count			 |		prod_comp_rank|
-- +------------------------+--------------------+---------------------+
-- | 'Marvel Studios'       |		2656967		 |		    1	 	   |
-- |'Twentieth Century Fox'	|		2411163		 |			2		   |
-- |'Warner Bros.'			|		2396057		 |			3		   |
-- +-------------------+-------------------------+---------------------+*/

/*Yes Marvel Studios production company rules the movie world with highest number of votes of 2656967 .
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
DROP VIEW IF EXISTS MaleActors;        -- Drop Actor VIEW if exists in Database
DROP VIEW IF EXISTS IndianMovies;  -- Drop movies_India VIEW if exists in Database

CREATE VIEW MaleActors AS              -- This table will for store details of actors
SELECT     *
FROM       role_mapping AS rm
INNER JOIN names        AS n
ON         rm.name_id= n.id
WHERE      category='actor';

CREATE VIEW IndianMovies AS         -- This table will store details of movies in India
SELECT *
FROM   movie
WHERE  country IN ('India');

SELECT     act.NAME                                                   					AS actor_name,
           SUM(rate.total_votes)                                      						AS total_votes,
           COUNT(DISTINCT act.movie_id)                               					AS movie_count,
           (SUM(rate.avg_rating* rate.total_votes)/SUM(rate.total_votes))    					AS actor_avg_rating, -- finding weighted average rating for each actor using total votes as weight
           RANK() 
			OVER(ORDER BY (SUM(rate.avg_rating* rate.total_votes)/SUM(rate.total_votes)) DESC) 	AS actor_rank        
FROM       MaleActors               AS act
INNER JOIN IndianMovies         AS movind -- joining the view ACTORS with the view movies_India
ON         act.movie_id = movind.id
INNER JOIN ratings AS rate               -- joining ratings
ON         act.movie_id = rate.movie_id
GROUP BY   actor_name                 -- grouping by actor
HAVING     movie_count >= 5 
LIMIT 3;

-- Top actor is Vijay Sethupathi with average rating of 8.41 and total votes of 23114

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
DROP VIEW IF EXISTS FemaleActors;  --       -- Drop Actor VIEW if exists in Database
DROP VIEW IF EXISTS IndianMovies;  -- Drop movies_India VIEW if exists in Database

CREATE VIEW FemaleActors AS              -- This table will for store details of actors
SELECT     *
FROM       role_mapping AS rm
INNER JOIN names        AS n
ON         rm.name_id= n.id
WHERE      category='actress';

CREATE VIEW IndianMovies AS         -- This table will store details of movies in India
SELECT *
FROM   movie
WHERE  country IN ('India') AND languages='Hindi';

SELECT     act.NAME                                                   					AS actor_name,
           SUM(rate.total_votes)                                      						AS total_votes,
           COUNT(DISTINCT act.movie_id)                               					AS movie_count,
           (SUM(rate.avg_rating* rate.total_votes)/SUM(rate.total_votes))    					AS actor_avg_rating, -- finding weighted average rating for each actor using total votes as weight
           RANK() 
			OVER(ORDER BY (SUM(rate.avg_rating* rate.total_votes)/SUM(rate.total_votes)) DESC) 	AS actor_rank        
FROM       FemaleActors               AS act
INNER JOIN IndianMovies         AS movind -- joining the view ACTORS with the view movies_India
ON         act.movie_id = movind.id
INNER JOIN ratings AS rate               -- joining ratings
ON         act.movie_id = rate.movie_id
GROUP BY   actor_name                 -- grouping by actor
HAVING     movie_count >= 3 
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74 with total votes of 18061
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title,
	   rate.avg_rating,
       ( CASE
           WHEN avg_rating > 8 THEN 'SUPERHIT MOVIES'
           WHEN avg_rating BETWEEN 8 AND 7 THEN 'HIT MOVIES'
           WHEN avg_rating BETWEEN 7 AND 5 THEN 'ONE-TIME-WATCH MOVIES'
           ELSE 'FLOP MOVIES'
         END ) AS MOVIES_CLASSIFICATION
FROM   movie AS mov
       INNER JOIN ratings AS rate
               ON mov.id = rate.movie_id
       INNER JOIN genre AS gen
               ON mov.id = gen.movie_id
WHERE  genre = "thriller"; 

-- 
/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
		ROUND(AVG(duration)) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS mov 
INNER JOIN genre AS gen 
ON mov.id= gen.movie_id
GROUP BY genre
ORDER BY genre;

-- genre		avg_duration	running_total_duration	moving_avg_duration
-- Action		113				112.88					112.880000
-- Adventure	102				214.75					107.375000
-- Comedy		103				317.37					105.790000
-- Crime		107				424.42					106.105000
-- Drama		107				531.19					106.238000
-- Family		101				632.16					105.360000
-- Fantasy		105				737.30					105.328571
-- Horror		93				830.02					103.752500
-- Mystery		102				931.82					103.535556
-- Others		100				1031.98					103.198000
-- Romance		110				1141.51					103.773636
-- Sci-Fi		98				1239.45					102.415455
-- Thriller		102				1341.03					102.389091
 

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
with Top3gen as (select genre, count(movie_id) as nom
from genre as gen
inner join movie as mov
on gen.movie_id=mov.id
group by genre
order by count(movie_id) desc
limit 3
),top5mov as(
SELECT     genre,
			   year,
			   title AS Movie_name,
			   worlwide_gross_income,
			   DENSE_RANK() OVER(partition BY year ORDER BY worlwide_gross_income DESC) AS Rank_of_movies
	FROM       movie                                                                    AS m
	INNER JOIN genre                                                                    AS g
	ON         m.id = g.movie_id
	WHERE      genre IN
					(SELECT genre
					 FROM   Top3Gen) 
)select * from top5mov 
where Rank_of_movies<=5; 

-- genre			year		Movie_name					worlwide_gross_income	Rank_of_movies
-- Drama	        2017		Shatamanam Bhavati			INR 530500000			1
-- Drama	        2017		Winner						INR 250000000			2
-- Drama	        2017		Thank You for Your Service	$ 9995692				3
-- Comedy	        2017		The Healer					$ 9979800				4
-- Drama	        2017		The Healer					$ 9979800				4
-- Thriller	    	2017		Gi-eok-ui bam				$ 9968972				5
-- Thriller	    	2018		The Villain					INR 1300000000			1
-- Drama	        2018		Antony & Cleopatra			$ 998079				2
-- Comedy	        2018		La fuitina sbagliata		$ 992070				3
-- Drama	        2018		Zaba						$ 991					4
-- Comedy	        2018		Gung-hab					$ 9899017				5
-- Thriller	   		2019		Prescience					$ 9956					1
-- Thriller	    	2019		Joker						$ 995064593				2
-- Drama	        2019		Joker						$ 995064593				2
-- Comedy	        2019		Eaten by Lions				$ 99276					3
-- Comedy	        2019		Friend Zone					$ 9894885				4
-- Drama	        2019		Nur eine Frau				$ 9884					5


-- 'Shatamanam Bhavati' in 2017 from Drama genre ,  'The Villain' in 2018 from Thriller genre and 'Joker' in 2019 from thriller genre were 
-- the movies having highest worldwide gross income per year .

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
select production_company,
count(id) as movie_count,
row_number() over(order by count(id) desc) as prod_comp_rank
from movie as mov
inner join ratings as rate
on mov.id=rate.movie_id
WHERE median_rating >=8 AND production_company IS NOT NULL AND languages like "%,%"
group by production_company
limit 2;
-- production_company	movie_count	prod_comp_rank
-- Star Cinema          	7	        1
-- Twentieth Century Fox	4	        2

-- Star Cinema is the production company with 7 number of movies as the most movies producing production company . 

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select nam.name as actress_name,
sum(total_votes) as total_votes,
count(role_map.movie_id) as movie_count, 
gen.genre,
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
DENSE_RANK() OVER(ORDER BY COUNT(role_map.movie_id) DESC) AS actress_rank
FROM names AS nam
INNER JOIN role_mapping AS role_map
ON nam.id = role_map.name_id
INNER JOIN genre AS gen
ON role_map.movie_id = gen.movie_id
LEFT OUTER JOIN ratings AS rate
ON rate.movie_id = gen.movie_id
WHERE category = 'actress' AND avg_rating > 8 AND genre = 'Drama'
GROUP BY actress_name
LIMIT 3;

-- 'Parvathy Thiruvothu' ,'Susan Brown' , 'Amanda Lawrence' is the top actress doing highest number movie with 4974 , 656 and 656 total votes respectively .





/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH movie_date_info AS
(
	SELECT     d.name_id,
			   name,
			   d.movie_id,
			   m.date_published,
			   LEAD(date_published, 1) OVER(partition BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
	FROM       director_mapping d
	INNER JOIN names AS n
	ON         d.name_id = n.id
	INNER JOIN movie AS m
	ON         d.movie_id = m.id 
), 
date_difference AS
(
	SELECT *,
		   DATEDIFF(next_movie_date, date_published) AS diff
	FROM   movie_date_info 
), 
avg_inter_days AS
(
	 SELECT   name_id,
			  Avg(diff) AS avg_inter_movie_days
	 FROM     date_difference
	 GROUP BY name_id 
), 
final_result AS
(
	SELECT     d.name_id                                          AS director_id,
			   NAME                                               AS director_name,
			   COUNT(d.movie_id)                                  AS number_of_movies,
			   ROUND(avg_inter_movie_days)                        AS inter_movie_days,
			   ROUND(Avg(avg_rating),2)                           AS avg_rating,
			   SUM(total_votes)                                   AS total_votes,
			   MIN(avg_rating)                                    AS min_rating,
			   MAX(avg_rating)                                    AS max_rating,
			   SUM(duration)                                      AS total_duration,
			   ROW_NUMBER() OVER(ORDER BY Count(d.movie_id) DESC) AS director_row_rank
	FROM       names                                              AS n
	INNER JOIN director_mapping                                   AS d
	ON         n.id = d.name_id
	INNER JOIN ratings AS r
	ON         d.movie_id = r.movie_id
	INNER JOIN movie AS m
	ON         m.id = r.movie_id
	INNER JOIN avg_inter_days AS a
	ON         a.name_id = d.name_id
	GROUP BY   director_id 
)
SELECT *
FROM   final_result LIMIT 9;
-- Steven Soderbergh is the director with highest average rating of 6.48 and highest number of total votes .
-- Biggest duration movies made by Director A.L.Vijay with total duration of 613
-- Sion Sono is having the highest interval of days between his next movie.
-- Andrew Jones is top rank director  
-- director_id	director_name	 number_of_movies	inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration	director_row_rank
-- nm2096009	Andrew Jones	 5	                191	                3.02	    1989	    2.7	        3.2	        432	                1
-- nm1777967	A.L. Vijay	     5	                177              	5.42	    1754	    3.7     	6.9	        613         	    2
-- nm6356309	'Özgür Bakar'	 4	                112             	3.75	    1092	    3.1      	4.9	        374                 3
-- nm2691863	Justin Price	 4	                315             	4.5	        5343	    3       	5.8     	346             	4
-- nm0814469	Sion Sono	     4	                331             	6.03     	2972	    5.4     	6.4	        502             	5
-- nm0831321	Chris Stokes	 4	                198             	4.33     	3664	    4	        4.6      	352             	6
-- nm0425364	Jesse V.Johnson	 4	                299	                5.45    	14778	    4.2     	6.5     	383              	7
-- nm0001752    Steven Soderbergh4	                254	                6.48     	171684	    6.2      	7	        401             	8
-- nm0515005	Sam Liu          4	                260               	6.23    	28557	    5.8	        6.7     	312              	9






