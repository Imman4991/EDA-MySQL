-- Exploratory Data Analysis

USE world_layoffs;

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Total Number of companies with ALL employees laid off (where 1% means ALL)
 
SELECT COUNT(company)
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Company with highest number of laid-off employees

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY Company
ORDER BY 2 DESC;

-- Date Range of The Data

SELECT MIN(`Date`), MAX(`Date`)
FROM layoffs_staging2;

-- Industry with highest number of laid-off employees

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC; 

-- Country with highest number of laid-off employees

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC; 

-- Period with highest number of laid-off employees

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC; 

-- Period with highest number of laid-off employees (USING YEAR)

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC; 

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; 

-- Organizational Stage with the highest number of laid-off employees 

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 

-- Company with highest percentage of laid-off employees

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY Company
ORDER BY 2 DESC;

-- ROLLING TOTAL OF LAYOFFS MONTH ON MONTH

SELECT SUBSTRING(`DATE`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS `Total_Off`
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


-- Create CTE to temporarily analyze the Rolling Total of lay-offs
WITH Rolling_Total AS
(
SELECT SUBSTRING(`DATE`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS `Total_Off`
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,`Total_Off`,
SUM(Total_Off)OVER(ORDER BY `MONTH`) AS Rolling_Total
FROM Rolling_Total;  

 
-- Ranking Companies accourding to Lay-offs Year on Year

SELECT company, YEAR(`DATE`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`DATE`)
ORDER BY 3 DESC;

WITH Company_Year(Company, Years, Total_Laid_Off) AS
(
SELECT company, YEAR(`DATE`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`DATE`)
), Company_Year_Rank AS 
(
SELECT *,
DENSE_RANK () OVER(PARTITION BY Years ORDER BY Total_Laid_Off DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5;











 

 

 





