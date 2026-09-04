/*
TASK 23 – SQL WINDOW FUNCTIONS INTRO
Based on the user-provided AdventureWorks CSV extract.

Create/import these SQL Server tables first:
AdventureWorks_SalesOrderHeader
AdventureWorks_CustomerMaster
AdventureWorks_VendorMaster
*/

-- Q01: ROW_NUMBER() – unique order sequence by TotalDue
SELECT SalesOrderID, OrderDate, CustomerID, TotalDue,
       ROW_NUMBER() OVER (ORDER BY TotalDue DESC, SalesOrderID) AS PriceRowNumber
FROM AdventureWorks_SalesOrderHeader
ORDER BY PriceRowNumber;

-- Q02: RANK() – ties share rank and gaps can occur
SELECT SalesOrderID, OrderDate, CustomerID, TotalDue,
       RANK() OVER (ORDER BY TotalDue DESC) AS TotalDueRank
FROM AdventureWorks_SalesOrderHeader
ORDER BY TotalDueRank, SalesOrderID;

-- Q03: DENSE_RANK() – ties share rank without gaps
SELECT SalesOrderID, OrderDate, CustomerID, TotalDue,
       DENSE_RANK() OVER (ORDER BY TotalDue DESC) AS DenseTotalDueRank
FROM AdventureWorks_SalesOrderHeader
ORDER BY DenseTotalDueRank, SalesOrderID;

-- Q04: Compare ROW_NUMBER, RANK and DENSE_RANK
SELECT SalesOrderID, OrderDate, CustomerID, TotalDue,
       ROW_NUMBER() OVER (ORDER BY TotalDue DESC, SalesOrderID) AS RowNumberRank,
       RANK() OVER (ORDER BY TotalDue DESC) AS RankValue,
       DENSE_RANK() OVER (ORDER BY TotalDue DESC) AS DenseRankValue
FROM AdventureWorks_SalesOrderHeader
ORDER BY TotalDue DESC, SalesOrderID;

-- Q05: ROW_NUMBER() within each customer
SELECT CustomerID, SalesOrderID, OrderDate, TotalDue,
       ROW_NUMBER() OVER (
           PARTITION BY CustomerID
           ORDER BY OrderDate, SalesOrderID
       ) AS CustomerOrderRowNumber
FROM AdventureWorks_SalesOrderHeader
ORDER BY CustomerID, CustomerOrderRowNumber;

-- Q06: Rank customers by total sales
WITH CustomerSales AS (
    SELECT CustomerID, SUM(TotalDue) AS TotalCustomerSales
    FROM AdventureWorks_SalesOrderHeader
    GROUP BY CustomerID
)
SELECT CustomerID, TotalCustomerSales,
       RANK() OVER (ORDER BY TotalCustomerSales DESC) AS SalesRank
FROM CustomerSales
ORDER BY SalesRank, CustomerID;

-- Q07: Top 3 orders by country
WITH CountryOrders AS (
    SELECT soh.SalesOrderID, soh.OrderDate, soh.CustomerID,
           COALESCE(cm.CountryName, 'Unknown') AS CountryName,
           soh.TotalDue,
           DENSE_RANK() OVER (
               PARTITION BY COALESCE(cm.CountryName, 'Unknown')
               ORDER BY soh.TotalDue DESC
           ) AS CountryOrderRank
    FROM AdventureWorks_SalesOrderHeader AS soh
    LEFT JOIN AdventureWorks_CustomerMaster AS cm
      ON soh.ShipToAddressID = cm.AddressID
)
SELECT SalesOrderID, OrderDate, CustomerID, CountryName,
       TotalDue, CountryOrderRank
FROM CountryOrders
WHERE CountryOrderRank <= 3
ORDER BY CountryName, CountryOrderRank, SalesOrderID;

-- Q08: LAG() – previous month sales
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalDue) AS MonthlySales
    FROM AdventureWorks_SalesOrderHeader
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, MonthlySales,
       LAG(MonthlySales) OVER (ORDER BY SalesMonth) AS PreviousMonthSales,
       MonthlySales - LAG(MonthlySales) OVER (ORDER BY SalesMonth) AS SalesChange
FROM MonthlySales
ORDER BY SalesMonth;

-- Q09: LAG() – previous order for each customer
SELECT CustomerID, SalesOrderID, OrderDate, TotalDue,
       LAG(TotalDue) OVER (
           PARTITION BY CustomerID
           ORDER BY OrderDate, SalesOrderID
       ) AS PreviousOrderValue,
       TotalDue - LAG(TotalDue) OVER (
           PARTITION BY CustomerID
           ORDER BY OrderDate, SalesOrderID
       ) AS ChangeFromPreviousOrder
FROM AdventureWorks_SalesOrderHeader
ORDER BY CustomerID, OrderDate, SalesOrderID;

-- Q10: LEAD() – next month sales
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalDue) AS MonthlySales
    FROM AdventureWorks_SalesOrderHeader
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, MonthlySales,
       LEAD(MonthlySales) OVER (ORDER BY SalesMonth) AS NextMonthSales,
       LEAD(MonthlySales) OVER (ORDER BY SalesMonth) - MonthlySales AS ChangeToNextMonth
FROM MonthlySales
ORDER BY SalesMonth;

-- Q11: Rank countries by total sales
WITH CountrySales AS (
    SELECT COALESCE(cm.CountryName, 'Unknown') AS CountryName,
           SUM(soh.TotalDue) AS CountrySales
    FROM AdventureWorks_SalesOrderHeader AS soh
    LEFT JOIN AdventureWorks_CustomerMaster AS cm
      ON soh.ShipToAddressID = cm.AddressID
    GROUP BY COALESCE(cm.CountryName, 'Unknown')
)
SELECT CountryName, CountrySales,
       RANK() OVER (ORDER BY CountrySales DESC) AS CountrySalesRank
FROM CountrySales
ORDER BY CountrySalesRank, CountryName;

-- Q12: Monthly sales rank + previous month comparison
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalDue) AS MonthlySales
    FROM AdventureWorks_SalesOrderHeader
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, MonthlySales,
       RANK() OVER (ORDER BY MonthlySales DESC) AS MonthlySalesRank,
       LAG(MonthlySales) OVER (ORDER BY SalesMonth) AS PreviousMonthSales,
       MonthlySales - LAG(MonthlySales) OVER (ORDER BY SalesMonth) AS MonthOverMonthChange
FROM MonthlySales
ORDER BY SalesMonth;
