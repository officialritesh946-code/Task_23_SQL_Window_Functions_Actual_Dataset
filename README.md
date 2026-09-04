# Task 23 – SQL Window Functions Intro

**Data Analytics Track | Veda Technology Internship**

## Objective
Practice `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, and `LEAD()` for real business-style analysis.

## Dataset
This repository uses the **AdventureWorks ZIP supplied for this task**.

- **SalesOrderHeader:** 31,465 rows
- **CustomerMaster:** 19,193 rows
- **VendorMaster:** 104 rows
- Sales period: **31 May 2011 – 30 Jun 2014**
- Unique CustomerID values in sales: **19,119**

> This is a CSV extract containing three AdventureWorks-related tables, rather than the complete Microsoft AdventureWorks SQL Server backup.

## Project contents
- `AdventureWorks_Window_Functions.sql` — 12 SQL Server window-function queries
- `Query_Catalog.csv` — query/business-question mapping
- `Notes.md` — concepts, interview questions, and dataset notes
- `results/` — actual output CSVs generated from the supplied data

## Functions covered
`ROW_NUMBER()` • `RANK()` • `DENSE_RANK()` • `LAG()` • `LEAD()` • `PARTITION BY`

## Data relationship
Sales orders connect to the supplied customer/address extract through:

`SalesOrderHeader.ShipToAddressID → CustomerMaster.AddressID`

The vendor extract is retained for completeness but is not used in the 12 analyses because it has no direct sales-order relationship in the supplied files.

## SQL Server workflow
1. Import the three CSV files into SQL Server.
2. Use these table names:
   - `AdventureWorks_SalesOrderHeader`
   - `AdventureWorks_CustomerMaster`
   - `AdventureWorks_VendorMaster`
3. Open `AdventureWorks_Window_Functions.sql`.
4. Run each query separately.
5. Compare the SQL Server output with the corresponding file in `results/`.

## Skills demonstrated
SQL • Window Functions • Ranking • Trend Analysis • Customer Analysis • Sales Analysis • Business Intelligence
