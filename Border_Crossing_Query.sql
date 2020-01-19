USE USBorderCrossing

/* 1. BORDER CROSSING */

/* For finding the Measures Per State for Each Method of Travel */
SELECT State, Measure, COUNT(Value) AS MeasurePerState
FROM USBorderCrossing
GROUP BY State, Measure
ORDER BY State

/* For finding the Number of Entrants Based on the Measures of Entry */
SELECT Measure, SUM(CAST(Value AS bigint)) AS CountryLevel
FROM USBorderCrossing
GROUP BY Measure

/* For finding the Number of Entrants Based on the Border and the Measure */
SELECT Border, Measure, SUM(CAST(Value AS bigint)) AS BorderLevel
FROM USBorderCrossing
GROUP BY Border, Measure
ORDER BY BorderLevel

/* THE ABOVE WAS A SCAFFOLD OF HOW TO GO ABOUT THIS PROCESS, BELOW IS MY INDIVIDUAL EFFORT */

/* US-Mexico vs US-Canada - which one is more popular? */
SELECT Border, SUM(CAST(Value AS bigint)) AS BorderEntries
FROM USBorderCrossing
GROUP BY Border
ORDER BY BorderEntries

/* Which months were the most popular for entry into the United States through US-Canada? */
SELECT [Border], SUM(CAST(Value AS bigint)), DAY([Date]) as month_value_can
FROM USBorderCrossing
WHERE Border = 'US-Canada Border'
GROUP BY [Border], DAY([Date])
ORDER BY Border, DAY([Date])

/* Which months were the most popular for entry into the United States through US-Mexico? */
SELECT [Border], SUM(CAST(Value AS bigint)), DAY([Date]) as month_value_mex
FROM USBorderCrossing
WHERE Border = 'US-Mexico Border'
GROUP BY [Border], DAY([Date])
ORDER BY Border, DAY([Date])

/* Which months are popular for entry into the United States - this was described with 'Date' instead */
SELECT [Border], [Date], SUM(CAST(Value AS bigint)) AS MonthlyBorderEntries
FROM USBorderCrossing
GROUP BY [Border], [Date]
ORDER BY [Border], [Date]

/* 2. PORTS */

/* Let's break this down based on the Port Names in the US-Canada Border */
SELECT Border, [Port Name], SUM(CAST(Value AS bigint)) AS BorderEntriesCan
FROM USBorderCrossing
WHERE Border = 'US-Canada Border'
GROUP BY Border, [Port Name]
HAVING SUM(CAST(Value AS bigint)) >= 500000
ORDER BY BorderEntriesCan

/* Now let's break this down based on the Port Names in the US-Mexico Border */
SELECT Border, [Port Name], SUM(CAST(Value AS bigint)) AS BorderEntriesMex
FROM USBorderCrossing
WHERE Border = 'US-Mexico Border'
GROUP BY Border, [Port Name]
HAVING SUM(CAST(Value AS bigint)) >= 500000
ORDER BY BorderEntriesMex


/* Which years were the most popular for entry into the United States through US-Mexico? */
SELECT [Border], SUM(CAST(Value AS bigint)), YEAR([DATE]) as year_value
FROM USBorderCrossing 
WHERE Border = 'US-Mexico Border'
GROUP BY [Border], YEAR([Date]), DAY([Date])
ORDER BY Border, YEAR([Date])

/*  */
SELECT Border, YEAR([Date]), DAY([Date]), SUM(CAST(Value AS bigint)) as date_month
FROM USBorderCrossing
WHERE DAY([Date]) = 1
GROUP BY Border, YEAR([Date]), DAY([Date])
ORDER BY YEAR([Date]),DAY([Date])


/* 3. INFORMATION ABOUT TRUCK FLOWS IN BORDER CROSSINGS */

/* Popularity of Trucks in the US-Mexico Border */
SELECT [Border], [Port Name], SUM(CAST(Value AS bigint)) AS TrucksUSMex
FROM USBorderCrossing
WHERE Border = 'US-Mexico Border'
AND Measure = 'Trucks'
GROUP BY [Border], [Port Name]
HAVING SUM(CAST(Value AS bigint)) > 1000000
ORDER BY TrucksUSMex


/* Popularity of Trucks in the US-Canada Border */
SELECT Border, [Port Name], SUM(CAST(Value AS bigint)) AS TrucksUSCan
FROM USBorderCrossing
WHERE Measure = 'Trucks'
AND [Border] = 'US-Canada Border'
GROUP BY Border, [Port Name]
ORDER BY TrucksUSCan