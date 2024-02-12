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

## Milestone 5:

### Task 1
#### Two rectanglular shapes were created and placed next to the navigation bar side by side. Inside these shapes I added a card visial for the number of unique customers and the revenue per customer.
<img width="349" alt="Screenshot 2024-02-12 at 1 19 55 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/37cf36b9-ff76-432e-be3d-4f91bc11801d">

### Task 2/3/4
#### Next, a donut chart and a column chart visual to display the total customers for each country and the number of customers who purchased each product category, were created respectively.
#### Then a line chart of the total customers by date and a table of the top 20 customers, filtered by revenue, was added. The line chart containing a drill down function to view number of customers by year, quarter or month, with a trendline and forecast for the next 10 periods with a 95% confidence interval. As well as the table containing the number of total orders and total revenue of the top 20 customers.

### Task 5/6
#### Similar to task 1, three card visuals were created to display the full name, total number of orders and total revenue of the top 20 customers, filtered by revenue and including data bars.
#### Finally, a date slicer was added to allow users to filter the page by year, using the between slicer style.
<img width="1440" alt="Screenshot 2024-02-12 at 2 06 05 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/66b27fd7-2cd4-4c34-8ac0-54f0c95d886c">

## Milestone 6:

### Task 1
#### One of the visual cards from the Customer Detail page was coppied and pasted to the Executive Summary page three times and spread out half way across the page. Using the Distribute horozontally function, the spaces between could be made even.
<img width="593" alt="Screenshot 2024-02-12 at 5 11 59 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/b4517fd1-1994-4e42-af6f-bf3ab6be82f0">
<img width="177" alt="Screenshot 2024-02-12 at 5 12 25 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/2339ddb2-0170-4082-8f81-3dab9a955d28">

#### These cards were then assigned to my Total Revenue, Total Orders and Total Profit measures. Using the Callout Value pane change the decimal values to 2 decimal places for the revenue and profit cards, and 1 for the Total Orders measure. 
<img width="173" alt="Screenshot 2024-02-12 at 5 16 36 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/d79d5c6f-f276-46e1-87af-f00ded83fcc0">

### Task 2
#### copy the line graph from the Customer Detail page and paste on the executive summary page.
- Set X axis to your Date Hierarchy (using only the levels Start of Year, Start of Quarter and Start of Month)
- Set Y-axis to Total Revenue
#### Then place the line chart just below the cards

### Task 3 
#### Adding two donut charts can also be done by copy and pasting from the Customer Details page. But adapt them to show Total Revenue broken down by Store[Country] and Store[Store Type] respectively. Place these on the right half of the page, one on top of the other and expand to ensure the data fits on the chart.

### Task 4
####  Create a Clustered bar chart visual with the X axis field containing Total Orders, an in the y-axis add Product Category.

### Task 5
#### In this task we want to create KPIs for Quarterly Revenue, Orders and Profit. But to do so we need to create some more measures in our Measures Table to calculate:
- Previous Quarter Profit
- Previous Quarter Revenue
- Previous Quarter Orders
- Target Profit/Revenue/Orders (equal to 5% growth compared to the previous quarter)
#### The DAX formula for the Previous Quarter Profit is written as: 
```Previous Quarter Profit = CALCULATE( SUMX(Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])) * ORDERS[Product Quantity]), PREVIOUSQUARTER(Dates[Date]) )``` 
#### Using this you can adapt it for the Previous Quarter Revenue and Previous Quarter Orders DAX formulas.
#### In order to to create the Targets we take the previous quarter and multiply it by 1.05 for the 5% growth. 
```E.g. Target Profit = 'Measures Table'[Previous Quarter Profit] * 1.05```
#### But adapt this code for the Target Revenue and Target Orders.

#### Now we can create the KPIs we need. Add three KPI visuals below the Revenue line chart. 
1. Within the first KPI (Revenue), the Value field should be Total Revenue, the Trend Axis should be Start of Quarter and the Target should be Target Revenue
2. In the format pane ensure that the following is set for the Trend Axis, Direction: High is Good, Bad Colour: red and Transparency: 15%
3. In the Callout Value set the decimal place value to 1
4. For the second KPI (Profit), duplicate the first but change the Value field to Total Profit and change the Target to Target Profit
5. Finally for the third KPI (Orders), duplicate one of the others again and change the Value field to Total Orders and change the Target to Target Orders



