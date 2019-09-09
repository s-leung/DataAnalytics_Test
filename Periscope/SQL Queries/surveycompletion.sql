-- finding the number of members who have used the app for more than 30 days

WITH CTE AS (SELECT
    ID,
    MEMBERNAME,
    NAME,
    DATEDIFF('days',CREATEDAT, CURRENT_DATE) AS "daysusingapp"
  FROM [patient_dataset]
  GROUP BY 1,2,3,4
  HAVING DATEDIFF('days',CREATEDAT, CURRENT_DATE) >=100) 


--gives the count of those who have completed a survey
-- only caveat is that there are some who never received a survey
--what happens to the legacy members who have used the app before implementation of the survey feature? 
-- there are some members who are "legacy" but still received surveys, but others have not
-- they also have time challenge start dates

--legacy uuids that received survey 1,2,3: 69,61,30,41,28,61

SELECT
  *
FROM [patient_dataset]
  LEFT JOIN AppFollower.surveys
    ON AppFollower.surveys.userId = patient_dataset.id
WHERE AppFollower.surveys.surveyid = 1 AND AppFollower.surveys.completed = True




--these are all the "legacy" members who have used the app for more than 100 days
-- did not exist in time challenge start dates
SELECT
  *
FROM AppFollower.timed_challenge_start_dates
RIGHT JOIN CTE
  ON CTE.ID = AppFollower.timed_challenge_start_dates.userID
WHERE AppFollower.timed_challenge_start_dates.userID IS NULL



-----------------
-- counts the members who have used the app for more than 30 days
WITH CTE AS (SELECT
    ID,
    MEMBERNAME,
    NAME,
    DATEDIFF('days',CREATEDAT, CURRENT_DATE) AS "daysusingapp"
  FROM [patient_dataset]
  GROUP BY 1,2,3,4
  HAVING DATEDIFF('days',CREATEDAT, CURRENT_DATE) >=30) 

-- divide the number of above with the number of members who have completed survey 1
SELECT
  --the count of those who have completed survey 1
  CAST((SELECT
  COUNT(AppFollower.surveys.USERID)
FROM [patient_dataset]
  LEFT JOIN AppFollower.surveys
    ON AppFollower.surveys.userId = patient_dataset.id
WHERE AppFollower.surveys.surveyid = 1 AND AppFollower.surveys.completed = True) AS FLOAT) / CAST(COUNT(ID) AS FLOAT)

FROM CTE
