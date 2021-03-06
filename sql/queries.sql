#Basic Query to test data base
SELECT HOMETEAM_NAME AS TEAM, ROUND(AVG(HOMETEAM_POINTS),2) as AVG_POINTS_HOME, ROUND(AVG(AWAYTEAM_POINTS),2) as AVG_POINTS_AWAY
FROM GAME_STATS JOIN TEAM ON GAME_STATS.HOMETEAM_NAME = TEAM.TEAM_NAME
GROUP BY HOMETEAM_NAME
ORDER BY TEAM ASC;



#FD query to view season results per team
SELECT A.T_NAME AS TEAM_NAME, SUM(WIN) AS W, SUM(LOSS) AS L
FROM (SELECT  HOMETEAM_NAME AS T_NAME , SUM(HOMETEAM_RESULT = 'Win') AS WIN, SUM(HOMETEAM_RESULT = 'Lose') AS LOSS
FROM GAME_STATS 
GROUP BY HOMETEAM_NAME
UNION ALL
SELECT AWAYTEAM_NAME, SUM(AWAYTEAM_RESULT = 'Win') AS WIN, SUM(AWAYTEAM_RESULT = 'Lose') AS LOSS
FROM GAME_STATS
GROUP BY AWAYTEAM_NAME) AS A
GROUP BY T_NAME
ORDER BY T_NAME;


#FD to see Season results of one Team against other team, Query will sum result of wins and losses against each opponent
SELECT A.OPPONENT AS ATLANA_VS_OPPONENT, SUM(WIN) AS W, SUM(LOSS) AS L
FROM (SELECT AWAYTEAM_NAME AS OPPONENT, SUM(HOMETEAM_RESULT = 'Win') AS WIN, SUM(HOMETEAM_RESULT = 'Lose') AS LOSS
FROM GAME_STATS 
WHERE HOMETEAM_NAME = "Atlanta Socks"
GROUP BY AWAYTEAM_NAME
UNION ALL
SELECT HOMETEAM_NAME, SUM(AWAYTEAM_RESULT = 'Win') AS WIN, SUM(AWAYTEAM_RESULT = 'Lose') AS LOSS
FROM GAME_STATS
WHERE AWAYTEAM_NAME = "Atlanta Socks"
GROUP BY HOMETEAM_NAME) AS A
GROUP BY OPPONENT
ORDER BY OPPONENT ASC;

#FD query to see result of games in date range
SELECT GAME_DATE, HOMETEAM_NAME, HOMETEAM_POINTS, AWAYTEAM_NAME, AWAYTEAM_POINTS
FROM GAME_STATS JOIN GAME ON GAME_STATS.GAME_ID = GAME.GAME_ID AND GAME_STATS.SEASON_ID = GAME.SEASON_ID
WHERE GAME_DATE BETWEEN '2020-02-31' AND '2020-04-01'
ORDER BY GAME_DATE ASC;

#FD query to see salary of players and coaches of a team
SELECT TEAM_NAME, FULL_NAME,POSITION,P.SALARY, AGE
FROM (SELECT TEAM_ID,FULL_NAME,POSITION,SALARY, AGE
FROM PLAYER
WHERE TEAM_ID = 9
UNION ALL
SELECT TEAM_ID,FULL_NAME,POSITION, SALARY AS SALARY,AGE
FROM COACH
WHERE TEAM_ID = 9
ORDER BY SALARY) as P JOIN TEAM ON P.TEAM_ID = TEAM.LEAGUE_ID;