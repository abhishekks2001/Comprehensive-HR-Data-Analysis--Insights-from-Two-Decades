USE PROJECT;

-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT GENDER,COUNT(*) AS COUNT FROM HR
WHERE TERMDATE IS NULL 
GROUP BY GENDER;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT RACE,COUNT(*) AS COUNT FROM HR
WHERE TERMDATE IS NULL 
GROUP BY RACE
ORDER BY COUNT(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT MIN(AGE) AS YOUNGEST, MAX(AGE) AS OLDEST FROM HR
WHERE TERMDATE IS NULL ;

SELECT 
    AGE_GROUP,
    SUM(CASE WHEN GENDER = 'Male' THEN 1 ELSE 0 END) AS Male,
    SUM(CASE WHEN GENDER = 'Female' THEN 1 ELSE 0 END) AS Female,
    COUNT(*) AS Total
FROM (
    SELECT 
        CASE
            WHEN AGE >= 18 AND AGE <= 25 THEN '18-25'
            WHEN AGE >= 26 AND AGE <= 35 THEN '26-35'
            WHEN AGE >= 36 AND AGE <= 45 THEN '36-45'
            WHEN AGE >= 46 AND AGE <= 55 THEN '46-55'
            WHEN AGE >= 56 AND AGE <= 65 THEN '56-65'
            ELSE '65+'
        END AS AGE_GROUP,
        GENDER
    FROM HR 
    WHERE TERMDATE IS NULL
) AS subquery
GROUP BY AGE_GROUP
ORDER BY AGE_GROUP;


SELECT 
  CASE
    WHEN AGE>=18 AND AGE<=25 THEN '18-25'
	WHEN AGE>=26 AND AGE<=35 THEN '26-35'
    WHEN AGE>=36 AND AGE<=45 THEN '36-45'
    WHEN AGE>=46 AND AGE<=55 THEN '46-55'
    WHEN AGE>=56 AND AGE<=65 THEN '56-65'
    ELSE '65+'
  END AS AGE_GROUP,COUNT(*) AS COUNT FROM HR 
WHERE TERMDATE IS NULL
GROUP BY AGE_GROUP
ORDER BY AGE_GROUP;


-- 4. How many employees work at headquarters versus remote locations?
SELECT LOCATION,COUNT(*) AS COUNT FROM HR
WHERE TERMDATE IS NULL 
GROUP BY LOCATION;


-- 5. What is the average length of employment for employees who have been terminated?
SELECT
   round(AVG(DATEDIFF(TERMDATE,HIRE_DATE))/365,0) AS AVG_EMP_LEN
FROM HR WHERE TERMDATE<=curdate() AND TERMDATE IS NOT NULL;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT DEPARTMENT,GENDER, COUNT(*) AS COUNT FROM HR
WHERE TERMDATE IS NULL
GROUP BY DEPARTMENT, GENDER
ORDER BY DEPARTMENT;

SELECT 
DEPARTMENT,
SUM(CASE WHEN GENDER = 'Male' THEN 1 ELSE 0 END) AS MALE,
SUM(CASE WHEN GENDER = 'Female' THEN 1 ELSE 0 END) AS FEMALE,
SUM(CASE WHEN GENDER = 'Non-Conforming' THEN 1 ELSE 0 END) AS OTHER
FROM HR
WHERE TERMDATE IS NULL
GROUP BY DEPARTMENT
ORDER BY DEPARTMENT;

-- 7. What is the distribution of job titles across the company?
SELECT JOBTITLE,COUNT(8) AS COUNT FROM HR
WHERE TERMDATE IS NULL
GROUP BY JOBTITLE
ORDER BY COUNT DESC;

-- 8. Which department has the highest turnover rate?
SELECT DEPARTMENT,TOTAL_COUNT,TERMINATED_COUNT,TERMINATED_COUNT/TOTAL_COUNT AS TERMINATION_RATE
FROM(
  SELECT DEPARTMENT,COUNT(*) AS TOTAL_COUNT,
  SUM(CASE WHEN TERMDATE IS NOT NULL AND TERMDATE<=curdate() THEN 1 ELSE 0 END) AS TERMINATED_COUNT
  FROM HR GROUP BY DEPARTMENT
  ) AS SUBQUERY
ORDER BY TERMINATION_RATE DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT LOCATION_STATE,COUNT(*) AS COUNT FROM HR
WHERE TERMDATE IS NULL
GROUP BY LOCATION_STATE
ORDER BY COUNT DESC;



-- 10. What is the tenure distribution for each department?
SELECT DEPARTMENT, round(avg(datediff(TERMDATE, HIRE_DATE)/365),0) AS AVG_TENURE FROM HR
WHERE termdate <= curdate() AND TERMDATE IS NOT NULL
GROUP BY department;

SELECT MIN(hire_date) AS min_hire_date, MAX(hire_date) AS max_hire_date
FROM hr;


-- 11. what is total count and net change of employees year wise?  

SELECT
    year,
    hires,
    terminations,
    total_employees,
    ROUND((hires - terminations)/hires*100,2) AS net_change_percent
FROM(
    SELECT
        YEAR(hire_date) AS year,
        COUNT(*) as hires,
        SUM(CASE WHEN termdate <= curdate() AND termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminations,
        (SELECT COUNT(*) FROM hr WHERE YEAR(hire_date) <= year AND (termdate > curdate() OR termdate IS NULL)) AS total_employees
    FROM hr
    WHERE age >= 18
    GROUP BY year(hire_date)
) AS subquery
ORDER BY year ASC;