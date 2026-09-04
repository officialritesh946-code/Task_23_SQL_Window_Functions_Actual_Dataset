# Task 23 – Notes & Interview Guide

## Actual dataset used
This project is based on the **AdventureWorks ZIP you supplied**, not invented data.

| File | Rows |
|---|---:|
| AdventureWorks_SalesOrderHeader.csv | 31,465 |
| AdventureWorks_CustomerMaster.csv | 19,193 |
| AdventureWorks_VendorMaster.csv | 104 |

Sales order dates: **31 May 2011 to 30 Jun 2014**.  
Unique customers appearing in sales: **19,119**.

The vendor file is included as source data but is not used in the 12 window-function analyses because it has no direct sales-order key in this extract.

## Window functions

**ROW_NUMBER()** – gives every row a unique sequence.

**RANK()** – tied values receive the same rank; gaps can appear.

**DENSE_RANK()** – tied values receive the same rank; no gaps appear.

**LAG()** – returns a value from a previous row, useful for previous-month or previous-order comparisons.

**LEAD()** – returns a value from a following row, useful for next-period comparisons.

**PARTITION BY** – creates independent groups for the window calculation while keeping detail rows.

## Interview answers

**RANK vs DENSE_RANK?**  
RANK leaves gaps after ties; DENSE_RANK does not.

**When use ROW_NUMBER()?**  
When every row needs a unique sequence, for example numbering orders within each customer.

**When use LAG()?**  
For comparisons with a previous record, such as month-over-month sales.

**Why window functions instead of GROUP BY?**  
GROUP BY collapses rows. Window functions calculate across related rows while preserving row-level detail.

**What does PARTITION BY do?**  
It restarts the window calculation for each logical group.

## Data-driven observations
The `results/` folder contains the actual results calculated from your supplied CSVs. Use these files to discuss the highest-value orders, customer rankings, country rankings, and month-over-month movements.
