SELECT INFO.anime_id, INFO.name, INFO.genre, cast(PREDICTION.rating as decimal(10,2)) AS Predicted_Rating,
INFO.rating AS Popular_Rating, INFO.members AS Members
FROM dbo.anime_prediction AS PREDICTION 
INNER JOIN dbo.anime_info AS INFO ON PREDICTION.anime_id = INFO.anime_id
WHERE (INFO.Genre LIKE '%Comedy%Romance%' OR INFO.Genre LIKE '%Harem%' OR INFO.Genre LIKE '%Slice of Life%' OR INFO.Genre LIKE '%Hentai%')
AND INFO.name LIKE '%Ore Monogatari!!%'
ORDER BY Predicted_Rating DESC, Popular_Rating DESC;

WITH PEARSON_TABLE AS
(
SELECT SUM(PREDICTION.rating) AS SUM_X, COUNT(PREDICTION.rating) AS N,
SUM(INFO.rating) AS SUM_Y, SUM(PREDICTION.rating * INFO.rating) AS SUM_XY,
SUM(INFO.rating*INFO.rating) AS SUM_Y_2, SUM(PREDICTION.rating * PREDICTION.rating) AS SUM_X_2
FROM dbo.anime_prediction AS PREDICTION 
INNER JOIN dbo.anime_info AS INFO ON PREDICTION.anime_id = INFO.anime_id
)
SELECT (P.N * P.SUM_XY - P.SUM_X*P.SUM_Y) / 
SQRT((P.N * P.SUM_X_2 - P.SUM_X * P.SUM_X) * (P.N * P.SUM_Y_2 - P.SUM_Y * P.SUM_Y))
AS PEARSON_COEFFICIENT
FROM PEARSON_TABLE AS P


SELECT INFO.anime_id, INFO.name, INFO.genre, cast(PREDICTION.rating as decimal(10,2)) AS Predicted_Rating,
INFO.rating AS Popular_Rating, INFO.members AS Members
FROM dbo.anime_prediction AS PREDICTION 
INNER JOIN dbo.anime_info AS INFO ON PREDICTION.anime_id = INFO.anime_id
WHERE INFO.Genre LIKE '%Hentai%'
ORDER BY Predicted_Rating DESC, Popular_Rating DESC;
