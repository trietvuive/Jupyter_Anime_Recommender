WITH fav_user_count AS
(
SELECT user_id as User_ID, SUM(Rating-6) as Total_Rating
FROM Anime.dbo.rating
WHERE anime_id IN 
(10719,14967,14813,18897,14749,25159,37450,23847,39547,10110,27787,13759,32281)
AND rating > 7
GROUP BY user_id
),
/* Haganai S1, Haganai S2, Oregairu S1, Nisekoi S1, Oreshura, Inou-Battle wa Nichijou
Bunny Girl Senpai, Oregairu S2, Oregairu S3, Mayo Chiki!, Nisekoi S2, Sakurasou,
Kimi no na wa
*/
anime_rec AS
(
SELECT anime.anime_id AS ID, SUM(Favorite.Total_Rating*(anime.rating - 5)) AS Aggregate_Rating
FROM Anime.dbo.rating as anime
INNER JOIN fav_user_count AS Favorite ON anime.user_id = Favorite.User_ID
WHERE anime.rating > 0
GROUP BY anime.anime_id
),
algo_rank AS
(SELECT anime_info.anime_id, anime_info.name AS Name, anime_rec.Aggregate_Rating AS Algo_Rating, 
anime_info.rating AS Crowd_Rating,
anime_info.members AS Members,
anime_info.genre AS Genre,
DENSE_RANK() OVER(ORDER BY anime_rec.Aggregate_Rating DESC) as Rank
FROM Anime.dbo.anime_info AS anime_info
INNER JOIN anime_rec ON anime_info.anime_id = anime_rec.ID),

info_rank AS
(
SELECT *, 
DENSE_RANK() OVER(ORDER BY (Info.members * Info.rating) DESC) as Rank
FROM Anime.dbo.anime_info AS Info
)
SELECT algo_rank.*, (info_rank.Rank - algo_rank.Rank) AS Rank_Difference 
FROM algo_rank INNER JOIN info_rank ON algo_rank.anime_id = info_rank.anime_id
WHERE algo_rank.Genre LIKE '%Comedy%Romance%'
ORDER BY algo_rank.Rank

