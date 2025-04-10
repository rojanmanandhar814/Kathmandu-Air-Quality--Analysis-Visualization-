select *
from dbo.AQI;

-- Daily AQI report 
select Date, AQI_Value, Status
from dbo.AQI
order by AQI_Value desc;

-- Number of Hazardous Days 
select count(*) as Hazardous    
from dbo.AQI
where status = 'Hazardous' or status = 'Very Unhealthy';

-- Beat cleanest AQI days or less AQI 
select top 1 *
from dbo.AQI
Order by AQI_Value Asc;

-- Dangerous AQI days or Most AQI 
select top 1 *
from dbo.AQI
Order by AQI_Value Desc;

-- Find AQI Range(MAX-MIN)
select
	MAX(AQI_Value) AS Max_AQI,
	MAX(AQI_Value) AS Min_AQI,
	MAX(AQI_Value) - MIN(AQI_Value) AS AQI_Range
from dbo.AQI;

--Days When AQI Was Above WHO Limit (e.g., >100)
select *
from dbo.AQI
where AQI_Value > 100;

--Average AQI by week NUmber 
SELECT 
    DATEPART(WEEK, Date) AS Week_Num,
    AVG(AQI_Value) AS Weekly_Avg_AQI
FROM dbo.AQI
GROUP BY DATEPART(WEEK, Date)
ORDER BY Week_Num;

--8️⃣ Show % of Days in Each AQI Category
select
    Status,
    COUNT(*) AS Days,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM dbo.AQI), 2) AS Percentage
FROM dbo.AQI
GROUP BY  Status
ORDER BY Days DESC;

 --Find Days with AQI Jump > 20 Compared to Previous Week
 SELECT TOP 1
    Date,
    AQI_Value,
    LAG(AQI_Value) OVER (ORDER BY Date) AS Previous_AQI,
    (AQI_Value - LAG(AQI_Value) OVER (ORDER BY Date)) AS AQI_Jump
FROM dbo.AQI
WHERE City = 'Kathmandu'
ORDER BY AQI_Jump DESC