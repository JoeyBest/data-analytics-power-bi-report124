# Power-BI Project

| Syntax | Description |
|-----------|-------------|
| 1 | Tasks Acomplished |
| 2 | Methods of importation/transformation |
| 3 | Transforms performed |


## Milestone 1:
#### This milestone included setting up a GitHub repo where the project and all changes/updates to it can be recorded

## Milestone 2:
#### This milestone included using the 'get data' function to connecting to different data sources, load and transform the data.
1. Azure SQL Database - Orders - Transform included deleting the [Card Number] column, splitting both [Order Date] and [Shipping Date] columns into date and time columns, as well as removing missing or null values from [Order Date].
2. Text/CSV - Products - Removed duplicates from the product_code column.
3. Azure Blob Storage - Stores???????????????????????
4. Folder - Customers folder - Combine and Transform to import the data, combining the [First Name] and [Last Name] to create a Full Name column and delete unused columns.
5. Save the file

## Milestone 3:
#### The first part of this Milestone was to create a table containing all dates that covers the entire time period of the data.
#### To do so, navigate to the new table function in the Home Ribbon and enter the following DAX code: 
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

