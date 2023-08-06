Query 1.)

Question:
  
Calculate the average of the ratings (rounded to 4 decimal places) for the movies
by genre for each year from 2017 to 2021 for each genre, Adventure, and Thriller.

SQL Query:

SELECT title_basics.startyear AS year,
       'Thriller' AS genres,
       ROUND(AVG(title_ratings.averagerating),4) AS yearly_avg
FROM imdb00.TITLE_BASICS title_basics,
     imdb00.TITLE_RATINGS title_ratings
WHERE title_basics.tconst = title_ratings.tconst
AND   title_basics.titletype = 'movie'
AND   title_basics.genres LIKE '%Thriller%'
AND   title_basics.genres NOT LIKE '\N'
GROUP BY title_basics.startyear
HAVING title_basics.startyear BETWEEN '2017'
   AND '2021'
UNION
SELECT title_basics.startyear AS year,
       'Adventure' AS genres,
       ROUND(AVG(title_ratings.averagerating),4) AS yearly_avg
FROM imdb00.TITLE_BASICS title_basics,
     imdb00.TITLE_RATINGS title_ratings
WHERE title_basics.tconst = title_ratings.tconst
AND   title_basics.titletype = 'movie'
AND   title_basics.genres LIKE '%Adventure%'
AND   title_basics.genres NOT LIKE '\N'
GROUP BY title_basics.startyear
HAVING title_basics.startyear BETWEEN '2017'
   AND '2021'
ORDER BY year;




Query 2.)

Question:

For each year from 2004 to 2018 and for the Drama and Romance genre
combination, find out the lead actor/actress names with the highest average
rating. In case, there are multiple actors/actresses with the same highest average
rating, you need to display all of them.

SQL Query:

SELECT tb.startyear AS year,
       'Drama,Romance' AS genres,
       AVG(tr.averagerating) AS Highest_Avg_ActorRating,
       nb.primaryname AS Most_Popular_Actor
FROM imdb00.TITLE_BASICS tb,
     imdb00.TITLE_RATINGS tr,
     imdb00.TITLE_PRINCIPALS tp,
     imdb00.NAME_BASICS nb
WHERE tb.tconst = tr.tconst
AND   tp.tconst = tb.tconst
AND   nb.nconst = tp.nconst
AND   tb.titletype = 'movie'
AND   (tb.startyear BETWEEN '2004' AND '2018') AND tb.genres LIKE '%Drama%,%Romance%'
AND   (tp.ordering ='1' or tp.ordering ='2')
AND   tr.numvotes >= 80000
GROUP BY tb.startyear,
         tb.genres,
         nb.primaryname
HAVING AVG(tr.averagerating) >= (SELECT MAX(tr1.averagerating)
                                FROM imdb00.TITLE_BASICS tb1,
                                     imdb00.TITLE_RATINGS tr1,
                                     imdb00.TITLE_PRINCIPALS tp1,
                                     imdb00.NAME_BASICS nb1
                                WHERE tp1.tconst = tb1.tconst
                                AND   nb1.nconst = tp1.nconst
                                AND   tb1.tconst = tr1.tconst
                                AND   tb.startyear = tb1.startyear
                                AND   tb1.titletype = 'movie'
                                AND   (tb1.startyear BETWEEN '2004' AND '2018') AND tb1.genres LIKE '%Drama%,%Romance%'
                                AND   (tp1.ordering ='1' or tp1.ordering ='2')
                                AND   tr1.numvotes >= 80000)
ORDER BY tb.startyear;


