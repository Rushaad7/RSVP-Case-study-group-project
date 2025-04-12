USE imdb;


/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
SELECT * FROM movie;
SELECT * FROM genre;
SELECT * FROM director_mapping;
SELECT * FROM names;
SELECT * FROM ratings;


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- The below query will calculates the total number of rows present in the movie table and displays the result with the label Total_No_Of_Rows_In_Movie
-- And we can observe that there are 7997 rows of data in our table Movie
SELECT COUNT(*) AS Total_No_Of_Rows_In_Movie from movie;
-- Or we can use the follwing query which is believed to be more efficient query|| Though a very nuanced/ illogical reason to call it efficient
SELECT COUNT(1) AS Total_No_Of_Rows FROM movie;
-- _________________________________________________________________
--  We can observe that there are total of 14662 rows in the table Genre
SELECT COUNT(*) AS Total_No_Of_Rows_In_Genre from genre;
-- __________________________________________________________________
-- There are a total of 3867 rows in the director_mapping table
SELECT COUNT(*) AS Total_No_Of_Rows_In_director_mapping from director_mapping;
-- _________________________________________________________________
-- There are a tota of 15615 rows in the role_mapping table
SELECT COUNT(*) AS Total_No_Of_Rows_In_role_mapping from role_mapping;
-- __________________________________________________________________
-- There are total 25735 rows in the names tables
SELECT COUNT(*) AS Total_No_Of_Rows_In_names from names;
-- ___________________________________________________________________
-- There are a total of 7997 rows in the ratings table
SELECT COUNT(*) AS Total_No_Of_Rows_In_ratings from ratings;



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- There are total of 6 columns in our movie table 
SELECT * FROM movie;
-- Now we will apply the Case statement to find nulls in each column of the movie
DESCRIBE movie;
-- Describe helps us understand tha type of features available and their types
SELECT 
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_Null_Count,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_Null_Count,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_Null_Count,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS gross_income_Null_Count,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_Null_Count,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_Null_Count
FROM movie;

/* We can observe the count of null values as 
Country = 20
Gross Income = 3724
Languages = 194
Production = 528
*/


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
SELECT * FROM movie;
SELECT year as Year, 
	COUNT(id) as number_of_movies 
    FROM movie 
    GROUP BY year;
/* we can observe that the data is about three years(2017,18,19) 
2017 = 3052  Which is the most number of movies
2018 = 2944
2019 = 2001 which is the least number of movies
*/
SELECT MONTH(date_published) AS month_num
	,COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;
/* MONTH here extracts the month number from the Date_Published and we are making alias as month_num
 we had id as feature and counting the number of movies based on it usinf COUNT query
 There were 824 movies(highest) that were released in the month of March
 The lowest 438 movies were released in the month of December
*/ 




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(id) AS Total_Movies_USA 
FROM movie 
WHERE year = '2019' 
  AND country LIKE '%USA%';
-- There are total 758 movies released in USA in 2019
SELECT COUNT(id) AS Total_Movies_India 
FROM movie 
WHERE year = '2019' 
  AND country LIKE '%India%';
-- There are a total of 309 movies that were released in India in 2019
-- __________________________________OR__________________________________________________
SELECT 
    SUM(CASE WHEN country LIKE '%USA%' THEN 1 ELSE 0 END) AS Total_Movies_USA,
    SUM(CASE WHEN country LIKE '%India%' THEN 1 ELSE 0 END) AS Total_Movies_India
FROM movie
WHERE year = '2019';




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT * FROM genre;

SELECT DISTINCT (genre) AS Available_Genre
FROM genre;
-- we ca see that there are total of 13 Genres available in our dataset
-- Here DISTINCT finds the unique values present in the Genre column and outputs as alias Available_Genre



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT * FROM movie;
SELECT * FROM genre;

SELECT genre,
	COUNT(movie_id) as Total_Genre_movies from genre g
    JOIN movie m ON
    g.movie_id = m.id
    GROUP BY genre
    ORDER BY Total_Genre_movies DESC;
    
/* WE can observe that DRAMA has the highest movie that were relesed at 4285 with the east being Others at 100
Here we have counte movies ID with alias as Total_Genre_movies
we used inner joins on movie_id and id from tables genre and movie
Then we have ordered the output in descending order to get the top genre
*/




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*) AS Only_one_Genre
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(DISTINCT genre) = 1
) AS Only_one_Genre;

/* There are two queries that are at play here 
we are parsing genre feature and grouping the values
*/





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
SELECT * FROM movie;

SELECT g.genre
	,ROUND(AVG(m.duration)) AS Average_Duration
FROM genre AS g
INNER JOIN movie AS m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY Average_Duration DESC;

/* we can observe that Action has the highest average durtaion
While Horror is the least with 93 
*/ 






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
SELECT * FROM genre;
SELECT * FROM movie;
WITH thriller_genre_rank AS (
    SELECT 
        genre, 
        COUNT(movie_id) AS movie_count, 
        DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
    FROM genre
    GROUP BY genre
)
SELECT *
FROM thriller_genre_rank
WHERE genre = 'Thriller';

/* here's CTE  thriller_genre_rank takes care of ranking every movie
Then SELECT statement we are using to find the rank of thriller movies
*/




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
SELECT * FROM ratings;

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;

-- Here we have used simple Min Max statements to display result using aliases


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
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
SELECT * FROM ratings;

SELECT title
	,avg_rating
	,DENSE_RANK() OVER (
		ORDER BY avg_rating DESC
		) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id limit 10;
-- Here we have used DENSE_RANK() to assign a rank to each movie based on its average rating, allowing for ties in ranking.


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
 
SELECT 
    median_rating, 
    COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating ;

/* here we have calculated the count of movies for each unique median rating from the ratings table and then the
results are grouped by median rating and sorted in ascending order for easy analysis. 
*/

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

SELECT 
    m.production_company, 
    COUNT(m.id) AS no_of_movies, 
    DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM 
    movie m
INNER JOIN 
    ratings r 
ON 
    m.id = r.movie_id
WHERE 
    r.avg_rating > 8 
    AND m.production_company IS NOT NULL
GROUP BY 
    m.production_company;

/*we can clearly observe that Dream Warrior Pictures is the top production company
Here we have assigned a dense rank to each production company based on the number of qualifying movies and
sorted in descending order order to find the top production company
*/




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

SELECT 
    g.genre, 
    COUNT(m.id) AS movie_count -- Counts the number of movies for each genre
FROM 
    movie AS m 
INNER JOIN 
    genre AS g 
ON 
    m.id = g.movie_id 
INNER JOIN 
    ratings AS r 
ON 
    m.id = r.movie_id 
WHERE 
    YEAR(m.date_published) = 2017 -- Filters for movies published in the year 2017
    AND MONTH(m.date_published) = 3 -- Filters for movies published in March
    AND m.country = 'USA' -- Filters for movies from the USA
    AND r.total_votes > 1000 -- Filters for movies with more than 1000 total votes
GROUP BY 
    g.genre 
ORDER BY 
    movie_count DESC;
/* we can observe that Drama genre movie were the most that were relased at 16
Here we have grouped the results by genre and orders them in descending order of movie count
*/


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

SELECT 
    m.title, 
    r.avg_rating, 
    GROUP_CONCAT(g.genre) AS genre 
FROM 
    movie m 
INNER JOIN 
    ratings r 
ON 
    m.id = r.movie_id 
INNER JOIN 
    genre g 
ON 
    m.id = g.movie_id 
WHERE 
    m.title LIKE 'The%' -- Like condition to check the start of movies with The
    AND r.avg_rating > 8 -- Filtering for ratings greater than 8
GROUP BY 
    m.title, r.avg_rating
ORDER BY 
    r.avg_rating DESC;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
    date_published
FROM
    movie;  -- to check the format the dates are stored in the table

SELECT count(m.id) AS movie_count
	,r.median_rating
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published BETWEEN "2018-04-01"
		AND "2019-04-01"
	AND r.median_rating = 8 -- between is used to check the movies between and inclusive of the dates mentioned
GROUP BY r.median_rating;


-- We can observe that there are 361 movies that have a median rating of 8



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    CASE 
        WHEN LOWER(languages) LIKE '%italian%' THEN 'Italian'
        WHEN LOWER(languages) LIKE '%german%' THEN 'German'
    END AS language_group, 
    SUM(r.total_votes) AS total_no_of_votes -- finding the total votes for movies in each language group
FROM 
    movie AS m
INNER JOIN 
    ratings AS r 
ON 
    r.movie_id = m.id -- Matching ratings to corresponding movie to Join table
WHERE 
    LOWER(languages) LIKE '%italian%' -- Filtering for Italian movies
    OR 
    LOWER(languages) LIKE '%german%' -- FIltering for German Movies
GROUP BY 
    language_group
ORDER BY 
    total_no_of_votes DESC;



-- Answer is Yes

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


SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, -- Counts the number of NULL values in the 'name' column

    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls, -- Counts the number of NULL values in the 'height' column

    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls, -- Counts the number of NULL values in the 'date_of_birth' column

    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls -- Counts the number of NULL values in the 'known_for_movies' column

FROM 
    names;






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

WITH top_3_genres AS (
    SELECT 
        g.genre, 
        COUNT(m.id) AS movie_count,  -- Counts the number of movies in each genre
        DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank -- Ranks genres based on movie count
    FROM 
        movie m
    INNER JOIN 
        genre g 
    ON 
        g.movie_id = m.id
    INNER JOIN 
        ratings r 
    ON 
        r.movie_id = m.id
    WHERE 
        r.avg_rating > 8
    GROUP BY 
        g.genre
),
top_3_directors AS ( -- CTE to identify directors of movies in the top 3 genres
    SELECT 
        d.name_id, 
        COUNT(d.movie_id) AS movie_count, 
        g.genre
    FROM 
        director_mapping d
    INNER JOIN 
        genre g 
    ON 
        d.movie_id = g.movie_id
    INNER JOIN 
        ratings r 
    ON 
        d.movie_id = r.movie_id
    INNER JOIN 
        top_3_genres t3 
    ON 
        g.genre = t3.genre
    WHERE 
        r.avg_rating > 8 AND t3.genre_rank <= 3 -- Filters for directors of movies in top genres with high ratings
    GROUP BY 
        d.name_id, g.genre
)
SELECT 
    n.name AS director_name, 
    SUM(t3.movie_count) AS movie_count -- Sums up the movie counts for each director
FROM 
    top_3_directors t3
INNER JOIN 
    names n 
ON 
    t3.name_id = n.id
GROUP BY 
    n.name
ORDER BY 
    movie_count DESC
LIMIT 3;   -- limiting the results to the top three directors


/*We have used Common Table Expressions (CTEs) to first find genres and then determine which directors have directed films in those genres. 
and found that James Mangold had the highest (4) movies with rating >8
*/



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

SELECT n.NAME AS actor_name
	,COUNT(rm.movie_id) AS movie_count -- Counts the number of movies for each actor with aliases it as 'movie_count'
FROM role_mapping rm
INNER JOIN names n ON rm.name_id = n.id -- Joins with the names table on the name ID to get actor names             
INNER JOIN ratings r ON rm.movie_id = r.movie_id  -- Joins with the ratings table on movie ID to access ratings
WHERE category = "actor"
	AND r.median_rating >= 8 -- filters to include only movies with a median rating of 8 or higher 
GROUP BY n.NAME
ORDER BY movie_count DESC LIMIT 2; -- finding only top two actors based on movie count


-- we found Mammootty and Mohanlal as the actors whose median ratings ae >=8



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

SELECT m.production_company          -- production company from movie table and total_votes from the ratings table and hence the requirement of join
	,sum(total_votes) AS vote_count
	,dense_rank() OVER (   -- Calculates a dense rank for each production company based on vote count
		ORDER BY sum(total_votes) DESC 
		) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id  -- Joins with the ratings table on movie ID to access total votes
GROUP BY m.production_company
ORDER BY sum(total_votes) -- ordering results by vote count in descending order, so companies with more votes appear first
DESC limit 3; -- filtering for top three only


-- Marvel Studios, Twentieth Century Fox, Warner Bros. are the top three houses who received the most votes





/*Yes Marvel Studios rules the movie world.
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

WITH rank_actors -- CTE to calculate actor popularity
AS (
	SELECT NAME AS actor_name
		,sum(total_votes) AS total_votes
		,count(rm.movie_id) AS movie_count
		,round(sum(total_votes * avg_rating) / sum(total_votes), 2) AS actor_avg_rating  -- formula to calculate average rating of actors
	FROM role_mapping AS rm
	INNER JOIN names n ON rm.name_id = n.id   -- name id is the primary key and hence to be 
	INNER JOIN ratings r ON rm.movie_id = r.movie_id
	INNER JOIN movie m ON rm.movie_id = m.id
	WHERE category = "Actor" -- Filters results to include only rows where the category is 'Actor'
		AND country LIKE "%India%" -- filters to include only actors from India
	GROUP BY name_id
		,NAME
	HAVING count(DISTINCT rm.movie_id) >= 5 -- Including only actors with at least 5 distinct movies are included
	)
SELECT *
	,dense_rank() OVER ( -- Calculates a dense rank for each actor based on their average rating
		ORDER BY actor_avg_rating DESC
		) AS actor_rank
FROM rank_actors;

-- Top actor being Vijay Sethupathi with  23114 votes least favourite being Atul Sharma with 9604 votes



-- Top actor is Vijay Sethupathi

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

SELECT n.NAME
	,sum(total_votes) as total_votes
	,COUNT(m.id) AS movie_count
	,Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating -- calculating the weighted average rating for each actress, rounded to 2 decimal places
	,DENSE_RANK() OVER (  -- calculating a dense rank for each actress based on their average rating
		ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC
		) AS actress_rank
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN movie m ON rm.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE rm.category = "ACTRESS" -- filtering results to include only rows where the category is 'ACTRESS'
	AND m.languages LIKE "%Hindi%"  -- filtering for Hindi movies 
	AND m.country = "INDIA" -- filtering for movies produced in India
GROUP BY n.NAME
HAVING COUNT(m.id) >= 3  -- Ensures only actresses with at least 3 movies are included
LIMIT 5; -- Limiting to top 5 actresses only

-- It is evident that the Taapsee Pannu is top with 7.74 ratings and Kriti Sanon seconds her with 7.05 ratings




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT title AS movie_name
	,CASE -- CASE statement to categorize movies based on their average rating
		WHEN r.avg_rating > 8  -- Checks if the average rating is greater than 8
			THEN "Superhit"  -- Categorizes as "Superhit" if the condition is met
		WHEN r.avg_rating BETWEEN 7
				AND 8
			THEN "Hit"
		WHEN r.avg_rating BETWEEN 5
				AND 7
			THEN "One-time-watch"
		ELSE "Flop"
		END AS movie_category
FROM genre g
INNER JOIN movie m ON g.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE genre = "thriller" and r.total_votes>=25000 -- Filtering for thriller movies with at least 25,000 votes
ORDER BY r.avg_rating DESC; -- Ordering results by average rating in descending order







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

WITH GenreAvg AS ( -- CTE to calculate average movie duration by genre
    SELECT 
        g.genre,
        ROUND(AVG(m.duration), 2) AS avg_duration -- Calculating the average duration of movies in each genre, rounded to 2 decimal places
    FROM 
        movie m 
    INNER JOIN 
        genre g ON m.id = g.movie_id 
    GROUP BY 
        g.genre
),
RunningTotals AS ( -- CTE to calculate running totals and moving averages based on the average durations
    SELECT 
        genre,
        avg_duration,
        SUM(avg_duration) OVER (ORDER BY genre) AS running_total_duration,
        AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_duration
    FROM 
        GenreAvg
)
SELECT 
    genre, -- Selecting the genre from the second CTE
    avg_duration, -- Selecting the avg_duration from the second CTE
    running_total_duration, -- Selecting the running_total_duration from the second CTE
    moving_avg_duration -- Selecting the moving_avg_duration from the second CTE
FROM 
    RunningTotals 
ORDER BY 
    genre DESC;-- Ordering results by genre in descending order


-- Thriller had the maximum running duration with 1341.03 on the other hand Action had lowest at 112.88



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

WITH top_3_genre AS ( -- CTE to identify the top 3 genres based on movie count
    SELECT 
        g.genre, 
        COUNT(m.id) AS movie_count, 
        RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank   -- Ranking genres based on movie count in descending order
    FROM 
        genre g 
    INNER JOIN 
        movie m ON g.movie_id = m.id 
    GROUP BY 
        g.genre 
    HAVING COUNT(m.id) > 0 -- Ensures only genres with at least one movie are included
    LIMIT 3
),

find_rank AS ( -- CTE to find rankings of movies in the top genres
    SELECT 
        g.genre, 
        m.year, 
        m.title AS movie_name, 
        m.worlwide_gross_income, 
        RANK() OVER (PARTITION BY m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank -- Ranking movies within each year based on worldwide gross income in descending order
    FROM 
        movie m 
    INNER JOIN 
        genre g ON m.id = g.movie_id 
    WHERE 
        g.genre IN (SELECT genre FROM top_3_genre) -- Filtering for movies that belong to one of the top three genres identified earlier
)

SELECT 
    genre, 
    year, 
    movie_name, 
    worlwide_gross_income, 
    movie_rank
FROM 
    find_rank
WHERE 
    movie_rank <= 5 -- Filtering results to include only the top five ranked movies per year
ORDER BY 
    year, genre, movie_rank;  -- Ordering results by year, then genre, and finally by movie rank in ascending order




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

WITH multilingual_movies
AS ( -- CTE to filter and select multilingual movies with high ratings
	SELECT m.id
		,m.production_company
		,r.avg_rating
	FROM movie m
	INNER JOIN ratings r ON m.id = r.movie_id
	WHERE r.avg_rating >= 8 -- Filters for movies with an average rating of 8 or higher
		AND m.production_company IS NOT NULL
		AND POSITION(',' IN m.languages) > 0 -- Ensures the movie is multilingual
	)
	,production_house_summary
AS ( -- CTE to summarize production companies based on their multilingual movies
	SELECT production_company
		,COUNT(id) AS movie_count
		,RANK() OVER (
			ORDER BY COUNT(id) DESC
			) AS prod_comp_rank
	FROM multilingual_movies
	GROUP BY production_company
	)
SELECT production_company -- Selects the production company from the summary CTE
	,movie_count
	,prod_comp_rank
FROM production_house_summary
WHERE prod_comp_rank <= 2; -- Filters results to include only the top two ranked production companies


/*
Here we identify and rank production companies based on their number of high-rated multilingual movies.
and use Common Table Expressions (CTEs) to first filter and summarize relevant data before selecting top companies.
*/



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH superhit_movies AS ( -- CTE to filter and select superhit movies in the drama genre
    SELECT 
        m.id AS movie_id,
        rm.name_id,
        r.avg_rating,
        r.total_votes,
        g.genre
    FROM 
        movie m
    INNER JOIN 
        ratings r ON m.id = r.movie_id -- Joins with the ratings table on movie ID to access ratings
    INNER JOIN 
        role_mapping rm ON m.id = rm.movie_id -- Joins with the role mapping table to associate movies with actresses
    INNER JOIN 
        genre g ON g.movie_id = m.id  -- Joins with the genre table to get the genre of each movie
    WHERE 
        r.avg_rating > 8  -- Filtering for movies with an average rating greater than 8 (superhit)
        AND g.genre = 'Drama'  --  Filtering to include only drama genre movies
        AND rm.category = 'actress' -- Ensuring that only roles categorized as 'actress' are included
),

actress_summary AS ( -- CTE to summarize data about actresses based on their superhit movies
    SELECT 
        n.name AS actress_name,
        SUM(sm.total_votes) AS total_votes,
        COUNT(sm.movie_id) AS movie_count,
        ROUND(SUM(sm.avg_rating * sm.total_votes) / NULLIF(SUM(sm.total_votes), 0), 4) AS actress_avg_rating, -- Calculates weighted average rating for each actress, rounded to four decimal places; NULLIF prevents division by zero
        RANK() OVER (ORDER BY COUNT(sm.movie_id) DESC, SUM(sm.total_votes) DESC, n.name ASC) AS actress_rank -- Ranks actresses based on movie count and total votes; resolves ties alphabetically by name
    FROM 
        names n
    INNER JOIN 
        superhit_movies sm ON n.id = sm.name_id -- Joins with superhit_movies CTE to associate actresses with their movies
    GROUP BY 
        n.name
)

SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM 
    actress_summary
WHERE 
    actress_rank <= 3
ORDER BY 
    actress_rank; -- Orders results by actress rank in ascending order



-- The top actresses are Parvathy Thiruvothu, Amanda Lawrence, Denise Gough



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


-- This is for intermovie range

WITH t_date_summary
AS ( -- CTE to summarize movie details and calculate the next release date for each director
	SELECT d.name_id
		,NAME
		,d.movie_id
		,duration
		,r.avg_rating
		,total_votes
		,m.date_published
		,Lead(date_published, 1) OVER ( -- Calculates the next publication date for each director's movies using LEAD function
			PARTITION BY d.name_id ORDER BY date_published -- Partitions by director ID and orders by publication date and movie ID
				,movie_id
			) AS next_date_published
	FROM director_mapping AS d
	INNER JOIN names AS n ON n.id = d.name_id
	INNER JOIN movie AS m ON m.id = d.movie_id
	INNER JOIN ratings AS r ON r.movie_id = m.id
	)
	,top_director_summary
AS ( -- CTE to calculate date differences between consecutive movies for each director
	SELECT *
		,Datediff(next_date_published, date_published) AS date_difference
	FROM t_date_summary -- Calculates the difference in days between consecutive movie releases and aliases it as 'date_difference'
	)
SELECT name_id AS director_id -- Selects name ID as 'director_id' for output
	,NAME AS director_name
	,COUNT(movie_id) AS number_of_movies
	,ROUND(AVG(date_difference), 2) AS avg_inter_movie_days
	,ROUND(AVG(avg_rating), 2) AS avg_rating
	,SUM(total_votes) AS total_votes
	,MIN(avg_rating) AS min_rating
	,MAX(avg_rating) AS max_rating
	,SUM(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC limit 9; -- Ordering results by number of movies in descending order and limits output to top nine directors


/*
We summarizes information about directors based on their movies,
and then calculating averages and totals related to their filmography and release patterns.
The top directors are 
Andrew Jones,A.L. Vijay, Sion Sono, Chris Stokes, Sam Liu, Steven Soderbergh, Jesse V. Johnson, Justin Price, Özgür Bakar