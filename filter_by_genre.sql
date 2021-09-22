SELECT * FROM dbo.anime_prediction AS PREDICTION 
INNER JOIN dbo.anime_info AS INFO ON PREDICTION.anime_id = INFO.anime_id
WHERE INFO.Genre LIKE '%Comedy%Romance%'
ORDER BY PREDICTION.rating DESC