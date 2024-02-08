# Power-BI Project

| Syntax | Description |
|-----------|-------------|
| 1 | Tasks Acomplished |
| 2 | Methods of importation/transformation |
| 3 | Transforms performed |


## Milestone 1:
#### This milestone included setting up a GitHub repo where the project and all changes/updates to it can be recorded

## Milestone 2:
#### This milestone included using the 'get data' function to connecting to different data sources, load and transform the data.
1. Azure SQL Database - Orders - Transform included deleting the [Card Number] column, splitting both [Order Date] and [Shipping Date] columns into date and time columns, as well as removing missing or null values from [Order Date].
2. Text/CSV - Products - Removed duplicates from the product_code column.
3. Azure Blob Storage - Stores???????????????????????
4. Folder - Customers folder - Combine and Transform to import the data, combining the [First Name] and [Last Name] to create a Full Name column and delete unused columns.
5. Save the file

## Milestone 3:
### Task 1
#### The first part of this Milestone was to create a table containing all dates that covers the entire time period of the data. To do so, navigate to the new table function in the Home Ribbon and enter the following DAX code: 
```Dates = CALENDAR(MIN(Orders[Order Date]), MAX(Orders[Shipping Date]))```
#### This should create a table with a column like the one seen below on the left.
<img width="1440" alt="Screenshot 2024-02-07 at 7 24 00 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/313ce7e4-98f1-454a-8379-5eea7f1f5c28">

#### In order tto create the rest of the columns seen in the image, copy and paste the DAX formulas into a calculated column in the same table created.
| Column | DAX Formula |
|---------|------------|
| Day of Week |```Day of Week = WEEKDAY(Dates[Date], 2)```|
| Month Number |```Month Number = MONTH(Dates[Date])```|
| Month Name |```Month = FORMAT(DATE(1, Dates[Month Number], 1), "MMM")```| 
| Quarter |```Quarter = QUARTER(Dates[Date])```|
| Year |```Year = YEAR(Dates[Date])```|
| Start of Year |```StartOfYear = STARTOFYEAR(Dates[Date])```|
| Start of Quarter |```StartOfQuarter = STARTOFQUARTER(Dates[Date])```|
| Start of Month |```StartOfMonth = STARTOFMONTH(Dates[Date])```|
| Start of Week |```StartOfWeek = Dates[Date] - WEEKDAY(Dates[Date],2) + 1```|

### Task 2
#### Create a star schema with the following relationships (all relationships should be one-to-many):
- Products[product_code] to Orders[product_code]
- Stores[store code] to Orders[Store Code]
- Customers[User UUID] to Orders[User ID]
- Date[date] to Orders[Order Date] (Should be the active relationship)
- Date[date] to Orders[Shipping Date]
<img width="1440" alt="Screenshot 2024-02-07 at 11 40 25 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/88905dd2-e116-41bd-8902-e28703d391fd">

### Task 3
#### Next we'll create the measures table that can also be seen in the image above. Navigate to Model view, select Enter Data from the Home tab of the ribbon, name and then Load the table.

### Task 4
#### We'll now fill this table with measures we create
| Column | DAX Formula |
|---------|------------|
| Total Orders |```Total Orders = SUM(Orders[User ID])```|
| Total Revenue |```Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[sale_price]))```|
| Total Profit |```Total Profit = SUMX(Orders, (RELATED(Products[sale_price]) - RELATED(Products[cost_price])) * Orders[Product Quantity])```| 
| Total Customers |```Total Customers = DISTINCTCOUNT(Orders[User ID])```|
| Total Quantity |```Total Quantity = SUM(Orders[Product Quantity])```|
| Profit YTD |```Profit YTD = CALCULATE(SUMX(Orders, Orders[Product Quantity] * (RELATED(Products[Sale_Price]) - RELATED(Products[cost_price]))), YEAR(Orders[Order Date]) = YEAR(TODAY()))```|
| Revenue YTD |```Revenue YTD = CALCULATE(SUMX(Orders, Orders[Product Quantity] * RELATED(Products[sale_price])), YEAR(Orders[Order Date]) = YEAR(TODAY()))```|

### Task 5
#### Below can be seen that a the columns Country and Geography have been added to the stores table. Country uses the country code column and switches the occuring code for the name of the country whilst georaphy concatenates both the country region and country columns into one.
#### On the right hand side, in the data pane, it can also be seen that two Hierarchies have been created: Region & Date Hierarchy; within the region Hierarchy it follows as Region > Country > Country Region. within the date Hierarchy it follows as Start of Year > Start of Quarter >  Start of Month > Start of Week > Date.

<img width="1440" alt="Screenshot 2024-02-08 at 12 48 05 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/4fcce04c-1b2d-40fd-878d-8826367c0d2e">
