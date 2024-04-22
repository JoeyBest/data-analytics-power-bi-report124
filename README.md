# Power-BI Project

## Contents Table
| Syntax | Description |
|-----------|-------------|
| 1 | Data Sources |
| 2 | Data Cleaning and Transformation |
| 3 | Data Model |
| 5 | Customer Detail Page |
| 6 | Executive Summary Page |
| 7 | Product Detail Page |
| 8 | Stores Map Page |
| 9 | Drillthrough Page |
| 10 | Cross-Filtering and Navigation |
| 11 | File Structure |

## Data Sources
#### First, set up a GitHub repo where the project and all changes/updates to it can be recorded.

#### Using the Import option in Power BI connect to the Azure database. To do so you will need the necessary credentials and table name. Use the Database credentials option.
#### By selecting the 'get data' function to connect to different data sources, we can now load and transform the data. 

## Data Cleaning and Transformation
#### For the folowing it will be in the order of Get Data>[Database to connect to]>[Table to import]>[Transformation to be made].

1. Azure SQL Database - Orders - Delete the [Card Number] column, split both [Order Date] and [Shipping Date] columns into date and time columns, and remove missing or null values from [Order Date]
2. Text/CSV - Products - Remove duplicates from the product_code column
3. Azure Blob Storage - Stores - Rename any columns that don't align with Power BI naming conventions
4. Folder - Customers folder - Combining the [First Name] and [Last Name] to create a Full Name column and delete unused columns.
5. Save the file

## Data Model
### Creating a data table
#### We want to create a table with all dates that cover the entire time period of the data. To do so, navigate to the new table function in the Home Ribbon and enter the following DAX code: 
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

### Star Schema
#### Create a star schema with the following relationships (all relationships should be one-to-many):
- Products[product_code] to Orders[product_code]
- Stores[store code] to Orders[Store Code]
- Customers[User UUID] to Orders[User ID]
- Date[date] to Orders[Order Date] (Should be the active relationship)
- Date[date] to Orders[Shipping Date]
<img width="1440" alt="Screenshot 2024-02-07 at 11 40 25 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/88905dd2-e116-41bd-8902-e28703d391fd">

### Measures Table
#### Next we'll create the measures table that can also be seen in the image above. Navigate to Model view, select Enter Data from the Home tab of the ribbon, name and then Load the table.

### Key Measures
#### Fill the table with the following measures:
| Measure | DAX Formula |
|---------|------------|
| Total Orders |```Total Orders = COUNTROWS(Orders)```|
| Total Revenue |```Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[sale_price]))```|
| Total Profit |```Total Profit = SUMX(Orders, (RELATED(Products[sale_price]) - RELATED(Products[cost_price])) * Orders[Product Quantity])```| 
| Total Customers |```Total Customers = DISTINCTCOUNT(Orders[User ID])```|
| Total Quantity |```Total Quantity = SUM(Orders[Product Quantity])```|
| Profit YTD |```Profit YTD = CALCULATE('Measures Table'[Total Profit], DATESYTD(Dates[Date]) )```|
| Revenue YTD |```Revenue YTD = CALCULATE('Measures Table'[Total Revenue], DATESYTD(Dates[Date]) )```|

### Hierarchies
#### Below can be seen that a the columns Country and Geography have been added to the stores table. Country uses the country code column and switches the occuring code for the name of the country whilst georaphy concatenates both the country region and country columns into one.
#### On the right hand side, in the data pane, it can also be seen that two Hierarchies have been created: Region & Date Hierarchy; within the region Hierarchy it follows as Region > Country > Country Region. within the date Hierarchy it follows as Start of Year > Start of Quarter >  Start of Month > Start of Week > Date.

<img width="1440" alt="Screenshot 2024-02-08 at 12 48 05 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/4fcce04c-1b2d-40fd-878d-8826367c0d2e">


## Customer Detail Page

#### First we need to create a report page.
#### Add a narrow rectangular shape that spans the height of the page to the left-hand side of the page. Duplicate this report page to have 4 identical pages.

#### Format them as you wish and rename them with the following:
- Executive Summary
- Customer Detail
- Product Detail
- Stores Map

### Card Visuals
#### Within the Customer Detail Page, create two rectanglular shapes and place next to the navigation bar side by side. Inside these shapes add a card visial for the number of unique customers and the revenue per customer.
<img width="349" alt="Screenshot 2024-02-12 at 1 19 55 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/37cf36b9-ff76-432e-be3d-4f91bc11801d">

### Summary Charts
#### Create a donut chart and a column chart visual, these are for displaying the total customers for each country and the number of customers who purchased each product category, respectively.
<img width="319" alt="Screenshot 2024-02-20 at 11 15 58 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/cee6e39b-49d7-468a-b200-23f0a0e0ca85"><img width="316" alt="Screenshot 2024-02-20 at 11 16 21 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/e468433d-9cac-4a72-b4eb-2a8b679d6737">

### Line Chart and Top 20 Table
#### Then add a line chart of the total customers by date. It should show [Total Customers] on the Y axis, and the Date Hierarchy on the X axis. It also needs a drill down function to view number of customers by year, quarter or month, with a trendline and forecast for the next 10 periods with a 95% confidence interval.
<img width="197" alt="Screenshot 2024-02-20 at 11 21 10 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/adfb8321-8b61-40f5-8dee-eabc3563d612">
<img width="640" alt="Screenshot 2024-02-20 at 11 21 50 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/251ac86d-1dd6-4b30-9b19-19c9af949493">

### Top 20 Table
#### Add a table of the top 20 customers, filtered by revenue. This table should also display the number of total orders and total revenue of the top 20 customers. So we need to include [Full Name], [Total Orders] and [Revenue per Customer] as well as using a 'Top N' filter on 'Full Name' set to 'Top' 20, by the value 'Revenue per Customer.'

### Top Customer and Data Slicer
#### Similar to the card visuals task, two more need to be created to display the full name, total number of orders and total revenue of the top 20 customers. These should be filtered by revenue and include data bars.
#### Finally, add a date slicer to allow users to filter the page by year, using the between slicer style.
<img width="1440" alt="Screenshot 2024-02-12 at 2 06 05 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/66b27fd7-2cd4-4c34-8ac0-54f0c95d886c">

## Executive Summary Page

### Card Visuals
#### Copy one of the visual cards from the Customer Detail page and paste to the Executive Summary page three times, and spread out half way across the page. Using the Distribute horozontally function, the spaces between can be made even.
<img width="593" alt="Screenshot 2024-02-12 at 5 11 59 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/b4517fd1-1994-4e42-af6f-bf3ab6be82f0">
<img width="177" alt="Screenshot 2024-02-12 at 5 12 25 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/2339ddb2-0170-4082-8f81-3dab9a955d28">

#### Assign these cards to the Total Revenue, Total Orders and Total Profit measures. Using the Callout Value pane change the decimal values to 2 decimal places for the revenue and profit cards, and 1 for the Total Orders measure. 
<img width="173" alt="Screenshot 2024-02-12 at 5 16 36 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/d79d5c6f-f276-46e1-87af-f00ded83fcc0">

### Revenue Line Chart
#### Copy the line graph from the Customer Detail page and paste on the executive summary page.
- Set X axis to Date Hierarchy (using only the levels: Start of Year, Start of Quarter and Start of Month)
- Set Y-axis to Total Revenue
- Place the line chart just below the cards

### Donut and Bar Charts
#### Add two donut charts or copy and pasting from the Customer Details page. But adapt them to show Total Revenue broken down by Store[Country] and Store[Store Type] respectively. Place these on the right half of the page, one on top of the other and expand to ensure the data fits on the chart.
#### Create a Clustered bar chart visual with the X axis field containing Total Orders, an in the y-axis add Product[Category].

### KPI Visuals
#### In this task we want to create KPIs for Quarterly Revenue, Orders and Profit. But to do so we need to create some more measures in our Measures Table to calculate:
- Previous Quarter Profit
- Previous Quarter Revenue
- Previous Quarter Orders
- Target Profit/Revenue/Orders (equal to 5% growth compared to the previous quarter)

#### The DAX formula for the Previous Quarter Profit is written as: 
```Previous Quarter Profit = CALCULATE( SUMX(Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])) * ORDERS[Product Quantity]), PREVIOUSQUARTER(Dates[Date]) )``` 

#### Using this you can adapt it for the Previous Quarter Revenue and Previous Quarter Orders DAX formulas. In order to to create the Targets we take the previous quarter and multiply it by 1.05 for the 5% growth. 
```E.g. Target Profit = 'Measures Table'[Previous Quarter Profit] * 1.05```

#### But adapt this code for the Target Revenue and Target Orders. Now we can create the KPIs we need. Add three KPI visuals below the Revenue line chart. 

1. Within the first KPI (Revenue), the Value field should be Total Revenue, the Trend Axis should be Start of Quarter and the Target should be Target Revenue
2. In the format pane ensure that the following is set for the Trend Axis, Direction: High is Good, Bad Colour: red and Transparency: 15%
3. In the Callout Value set the decimal place value to 1
4. For the second KPI (Profit), duplicate the first but change the Value field to Total Profit and change the Target to Target Profit
5. Finally for the third KPI (Orders), duplicate one of the others again and change the Value field to Total Orders and change the Target to Target Orders

## Product Detail Page

### Gauge Visuals
#### Add measures for current quarter performance and quarterly targets with a 10% growth for each metric. 
```
E.g.
Current Quarter Profit = CALCULATE(SUMX(Orders, (RELATED(Products[sale_price]) - RELATED(Products[cost_price])) * Orders[Product Quantity]), DATESQTD(Dates[Date]))
Target Quarter Profit = 'Measures Table'[Current Quarter Profit] * 1.10
``` 
#### From here we can create our gauges that will display a maximum value of our target and the currect performance as the value. If the value is under the target amount format the callout value to be red, but if its met then format as green.
<img width="621" alt="Screenshot 2024-02-19 at 7 03 06 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/46a48073-8969-44e4-8b28-ce90358c6854">

### Filter State Cards
#### Create two new measures using the following DAX code:
```Category Selection = IF(ISFILTERED(Products[Category]), SELECTEDVALUE(Products[Category]), "No Selection")```
```Country Selection = IF(ISFILTERED(Stores[Country]), SELECTEDVALUE(Stores[Country]), "No Selection")```
#### Create two rectangular boxes next to the three previous gauges and add a Card visual with one of the two previous measures in each.

### Area Chart
#### Create a area chart visual using the following:
- X axis should be Dates[Start of Quarter]
- Y axis values should be Total Revenue
- Legend should be Products[Category]

### Top Products Table
#### Create a table with the following fields:
- Product Description
- Total Revenue
- Total Customers
- Total Orders
- Profit per Order

### Scatter Graph
#### In the products table, add a new calculated column with the DAX 
```Profit per item = CALCULATE(SUMX(Orders, (RELATED(Products[sale_price]) - RELATED(Products[cost_price]))/ Orders[Product Quantity]))```
#### This will allow us to visually display the profit of individual items. Create a scatter graph visual and add the following into the fields:
- Values should be Products[Description]
- X-Axis should be Products[Profit per Item]
- Y-Axis should be Orders[Total Quantity]
- Legend should be Products[Category]

### Slicer Toolbar
#### Create a blank button for the top of your navigation bar and set the icon type to 'Custom' in the Format pane. If you have images for the icons you can skip to the next part. If not you can download some icon images here. -> [Icons](https://cdn.theaicore.com/content/projects/e71908f1-fbf5-4c65-ad36-7d43589c3706/navigation_bar_images.zip)

#### Select Filter_icon.png (or your prefered image) as the icon image and set the tooltip text to Open Slicer Panel.
<img width="166" alt="Screenshot 2024-02-19 at 7 32 50 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/8069e2c9-6a62-443f-8f93-716ecedf2b0e"> <img width="171" alt="Screenshot 2024-02-19 at 7 34 37 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/ac5f629f-fa6a-4bef-b2df-fef25ebeafcd">

#### Duplicate your navigation bar and extend it 3-5x its original length. Create two slicers that will be placed in this new shape and set one to Products[Category], and the other to Stores[Country]. Change the titles to Product Category and Country respectively.
- Change the slicer style to Vertical List
- Turn off 'Multi-select with CTRL' for Product Category
- Turn on 'Show "Select all" option' for Country
- Group the slicers with your slicer toolbar shape in the selection pane

<img width="195" alt="Screenshot 2024-02-19 at 7 50 57 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/1b94b009-4ecc-45cb-a661-703ae320b10d"><img width="193" alt="Screenshot 2024-02-19 at 7 51 14 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/826874da-27d7-4ca6-93db-2e632d3805ce">

#### Create a button with the Back button type and position it at top-right corner of the toolbar. In the Selection pane, drag the back button into the group with the slicers and toolbar shape. 
<img width="211" alt="Screenshot 2024-02-19 at 7 55 13 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/6c7c5cec-232a-45e2-9a84-2d65d2caee4a">

#### Open the bookmarks pane and add two new bookmarks, one where the toolbar group is hidden in the Selection pane, and one with it visible. Name them Slicer Bar Closed and Slicer Bar Open. In these created bookmarks, right click and uncheck the data option. this will ensure that data from changing when the bookmarks are opened and closed.
<img width="175" alt="Screenshot 2024-02-19 at 8 03 20 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/f1c0d7a9-6a0e-460b-818f-fb777d30c5dd">
<img width="357" alt="Screenshot 2024-02-19 at 8 03 56 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/f8bce98b-fd07-460d-8847-03b0354010c8">
<img width="358" alt="Screenshot 2024-02-19 at 8 04 35 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/d27e6417-014d-4c8f-9af0-08c4952a92ca">

#### In the format pane of both the filter button and the back button assign the action type to bookmark, then select the relevent bookmark for slicer open or closed.
<img width="196" alt="Screenshot 2024-02-19 at 8 08 14 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/32b0dca2-a202-4567-b181-f11ca864ef0b">
<img width="194" alt="Screenshot 2024-02-19 at 8 08 36 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/248c4ee5-9e5e-44df-a123-4f37d2f25d8b">

## Stores Map Page

### Map Visual
#### Create a map visual spanning the majority of the page, with a space on top for a slicer to be added later. Add 'Geography' into the location field and 'Profit YTD' into the Bubble size field and set the following in the formatting:
- Show Labels: On
- Auto-Zoom: On
- Zoom buttons: Off
- Lasso button: Off

### Country Slicer
#### Create a slicer above the map visual and add Stores[Country] to the field. Set the slicer style to Tile and the Selection settings to Multi-select with CTRL and Show "Select All" as an option in the slicer.
<img width="197" alt="Screenshot 2024-02-19 at 11 36 26 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/21adcddc-588c-46f9-9086-2d5250a14fd1">

## Drillthrough Page
#### Make a new page called Stores Drillthrough. In the format pane, set the Page type to 'Drillthrough', set Drill through from to 'country region' and set Drill through when to 'Used as category.'
<img width="183" alt="Screenshot 2024-02-19 at 11 49 36 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/2cbf5c83-6836-46ed-b6e6-f8c4b9a927ef">
<img width="178" alt="Screenshot 2024-02-19 at 11 50 00 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/abafc4d3-1ed7-4f6f-81aa-47c48edd9565">
<img width="180" alt="Screenshot 2024-02-19 at 11 50 13 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/f02b6283-d03d-49f4-bdf1-963db6ee4a3e">

#### Next create two new measures: Profit Goal & Revenue Goal (target of 20% year-on-year growth vs. the same period in the previous year)
- ```Profit Goal = CALCULATE( 'Measures Table'[Total Profit], SAMEPERIODLASTYEAR(DATESYTD(Dates[Date])) ) * 1.2```
- ```Revenue Goal = CALCULATE( 'Measures Table'[Total Revenue], SAMEPERIODLASTYEAR(DATESYTD(Dates[Date])) ) * 1.2```

1. Create a table showing the top 5 products, with columns: Description, Profit YTD, Total Orders, Total Revenue
2. A column chart showing Total Orders by product category for the store
3. Gauges for Profit YTD & Revenue YTD against a profit/revenue goal (The goal should use the Target field)
4. A Card visual showing the currently selected store
<img width="1111" alt="Screenshot 2024-02-19 at 11 53 26 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/8854981d-000f-4f07-8c40-dabfdcd73409">

### Stores Tooltip Page
#### Create a new page called Stores Tooltips. Copy and paste the profit gauge created on the previous page to this new one.
1. Head back too the Stores Map Page
2. Select the map and in the format pane turn on Tooltips
3. Set the Type to 'Report Page'
4. Set the Page to 'Stores Tooltip'

#### The map should now display the profits gauge when you hover over one of the stores.
<img width="1109" alt="Screenshot 2024-02-20 at 12 10 17 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/510d52c2-a86e-4693-b1c8-fdc7dd3f1d08">

## Cross-Filtering and Navigation
### Fixing Cross-Filtering
### Executive Summary Page:
1. Select the Product Category bar chart and then 'Edit Interactions' (in the ribbon of the Format Tab) to select 'None' on the card visuals and KPIs
<img width="72" alt="Screenshot 2024-02-20 at 2 27 31 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/518ec5ca-ba33-45f3-a63f-89339ffce892"><img width="25" alt="Screenshot 2024-02-20 at 2 28 07 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/f8a67340-d742-46ab-ba36-2b7dffa3295c">
2. Do the same for the Top 10 Products table
3. Follow the same procedure for all charts in this milestone, but pay attention to which visual interaction should be fixed.

### Customer Detail Page
1. Top 20 Customers table - select 'None' on all visials
2. Total Customers by Category Column Chart - Select 'None' on the Customers line graph
3. Total Customers by Country donut chart - Select cross-filter on the Total Customers by Category Column Chart <img width="21" alt="Screenshot 2024-02-20 at 2 35 35 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/b68965ef-cb79-47bd-9b2f-12f630b811c1">

### Product Detail Page
1. Orders vs. Profitability scatter graph - select 'None' on all other visuals
2. Top 10 Products table - select 'None' on all other visuals

### Complete the Navigation Bar
#### Using the 'Icons' folder downloaded earlier we'll be completing the navigation bar.
1. Create 4 empty buttons and place them in the navigation bar
2. In the Format > Button Style pane, set Apply settings to 'Default'
3. In Icon, set Icon Type to custom and select the relavent white Icon from the downloaded folder <img width="51" alt="Screenshot 2024-02-21 at 1 19 00 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/b40f97e8-ed6e-404c-8c6c-520aa465c0f1">
4. For each button, go to Format > Button Style > Apply settings to and set it to On Hover
5. In Icon, remove the currect .png and select the relavent alternate coloured Icon from the downloaded folder
<img width="48" alt="Screenshot 2024-02-20 at 2 54 42 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/6107cd9a-adf1-4eed-a7ee-3effacb5d6b0"><img width="47" alt="Screenshot 2024-02-20 at 2 55 10 am" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/fd703052-281e-4f59-84f4-dce9e722d675">
6. For each button, turn on action in the format pane, change the type to Page Navigation and select the relevant page for the Icon.

#### Now that the navigation bar is complete, group the buttons together then copy and paste them to the remaining pages.

### <ins>Metrics for Users Outside the Company Using SQL</ins>
#### Now that the project on PowerBi is complete we can connect to the database using SQL in VScode. If 'SQLTools' isn't already downloaded as an extension then download it now.

### Connecting to the Server
- Select the SQLTools Extension <img width="44" alt="Screenshot 2024-02-20 at 9 52 16 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/625a3708-b518-422b-9fab-e978ae7b5f61">
- Select 'Add New Connection' and then PostgresSQL <img width="18" alt="Screenshot 2024-02-20 at 9 53 49 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/5795a714-5d63-4db4-8f44-f58b37a16d0e"><img width="92" alt="Screenshot 2024-02-20 at 9 55 42 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/3fa3f663-481b-4f32-aa80-71333c142c68">
- Using your credentials connect to the server, such will include:
  1. HOST: 
  2. PORT: 5432
  3. DATABASE:
  4. USERNAME:
  5. PASSWORD:
#### Now you can test the connection and if all works well then you can select save connection.

### Check the Table and Column Names
#### The database is now connected, but the tables within the database have different names to those we were working on in PowerBi. Using SQL we want to get an understanding for the data that it does have.
1. Print a list of the tables in the database and save the result to a csv file for your reference.
```
SELECT TABLE_NAME
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_TYPE = 'BASE TABLE' 
    AND 
    table_schema = 'public'
ORDER BY
    table_name;
```
2. Print a list of the columns in the orders table and save the result to a csv file called orders_columns.csv
3. Repeat the same process for each other table in the database, saving the results to a csv file with the same name as the table

<img width="219" alt="Screenshot 2024-02-20 at 10 09 45 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/c9a3cd21-fa95-46ee-bd4b-9719060b6b0d"><img width="208" alt="Screenshot 2024-02-20 at 10 10 15 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/d5844b29-6345-45a0-8f04-9c087da7d467"><img width="165" alt="Screenshot 2024-02-20 at 10 10 57 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/27b56d45-7390-4549-8d87-eb3af2097599">

### Query the Database
#### Using SQL answer the following questions and save as both a .csv and .sql file:
1. How many staff are there in all of the UK stores?
2. Which month in 2022 has had the highest revenue?
3. Which German store type had the highest revenue for 2022?
4. Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders
5. Which product category generated the most profit for the "Wiltshire, UK" region in 2021?
<img width="165" alt="Screenshot 2024-02-20 at 10 15 52 pm" src="https://github.com/JoeyBest/data-analytics-power-bi-report124/assets/149332225/a0c843d2-954f-42a2-8cf7-0768898d5147">

## File Structure:
```
.
└── /Users/
    └── joeybest/
        └── Ai Core/
            └── power bi/
                └── data-analytics-power-bi-report124/
                    ├── Power BI Project.pbix
                    ├── README.md
                    ├── PowerBiSQL/
                    │   ├── Questions/
                    │   │   ├── PowerBi.session.sql
                    │   │   ├── question_1.csv
                    │   │   ├── question_1.sql
                    │   │   ├── question_2.csv
                    │   │   ├── question_2.sql
                    │   │   ├── question_3.csv
                    │   │   ├── question_3.sql
                    │   │   ├── question_4.csv
                    │   │   ├── question_4.sql
                    │   │   ├── question_5.csv
                    │   │   └── question_5.sql
                    │   └── tables_and_columns/
                    │       ├── country_region.csv
                    │       ├── dim_customer.csv
                    │       ├── dim_date.csv
                    │       ├── dim_product.csv
                    │       ├── dim_store.csv
                    │       ├── forquerying2.csv
                    │       ├── forview.csv
                    │       ├── Milestone10.csv
                    │       ├── my_store_overviews_2.csv
                    │       ├── my_store_overviews.csv
                    │       ├── my_store_overviewsnew.csv
                    │       ├── new_store_overview.csv
                    │       ├── orders_columns.csv
                    │       ├── test_store_overviews_2.csv
                    │       ├── test_store_overviews.csv
                    │       └── test.csv
                    └── Images/
                        ├── Client Detail Screenshot.png
                        ├── Executive Summary Screenshot.png
                        ├── Product Detail Screenshot.png
                        ├── Product Detail Toolbar Screenshot.png
                        ├── Stores Drillthrough Screenshot.png
                        ├── Stores Map Screenshot.png
                        └── Stores Tooltip Screenshot.png
```