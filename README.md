# Sales management Data Cleaning and Dashboard

## Business Request & User Storeies
The business initiated this data analyst project with a request for an executive sales report tailored to meet the needs of sales managers. In response to this request, we formulated the 
following user stories to guide our project delivery and ensure the consistent adherence to acceptance criteria.

__Business Demand Overview:__
-	Reporter: Steven – Sales Manager
-	Value of Change: Visual dashboards and improved Sales reporting or follow up or sales force
-	Necessary Systems: Power BI, CRM System
-	Other Relevant Info: Budgets have been delivered in Excel for 2021
__User Stories:__

| NO# | As a (role) | I want (request / demand)  | So that I (user value) | Acceptance Criteria |
| -------- | -------- | -------- | -------- | -------- |
| 1 | Sales Manager | To get a dashboard overview of internet sales | Can follow better which customers and products sells the best | A Power BI dashboard which updates data once a day |
| 2 | Sales Representative | A detailed overview of Internet Sales per Customers | Can follow up my customers that buys the most and who we can sell ore to| A Power BI dashboard which allows me to filter data for each customer |
| 3 | Sales Representative | A detailed overview of Internet Sales per Products | Can follow up my Products that sells the most | A Power BI dashboard which allows me to filter data for each Product |
| 4 | Sales Manager | A dashboard overview of internet sales | Follow sales over time against budget | A Power Bi dashboard with graphs and KPIs comparing against budget. |

## Data Cleansing & Transformation (SQL)

### Dim_Date
```
-- Cleansed DIM_Date Table --
SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Date,  
  [EnglishDayNameOfWeek] AS Day, 
  [EnglishMonthName] AS Month, 
  Left([EnglishMonthName], 3) AS MonthShort,   -- Useful for front end date navigation and front end graphs.
  [MonthNumberOfYear] AS MonthNo, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year 
FROM 
 [AdventureWorksDW2019].[dbo].[DimDate]
WHERE 
  CalendarYear >= 2019

```
### Dim_Customer
```
-- Cleansed DIM_Customers Table --
SELECT 
  c.customerkey AS CustomerKey, 
  c.firstname AS [First Name], 
  c.lastname AS [Last Name], 
  c.firstname + ' ' + lastname AS [Full Name], 
  -- Combined First and Last Name
  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
  c.datefirstpurchase AS DateFirstPurchase, 
  g.city AS [Customer City] 
  -- Joined in Customer City from Geography Table
FROM 
  [AdventureWorksDW2019].[dbo].[DimCustomer] as c
  LEFT JOIN dbo.dimgeography AS g ON g.geographykey = c.geographykey 
ORDER BY 
  CustomerKey ASC -- Ordered List by CustomerKey

```

### Dim_Product
```
-- Cleansed DIM_Products Table --
SELECT 
  p.[ProductKey], 
  p.[ProductAlternateKey] AS ProductItemCode, 
  p.[EnglishProductName] AS [Product Name], 
  ps.EnglishProductSubcategoryName AS [Sub Category], -- Joined in from Sub Category Table
  pc.EnglishProductCategoryName AS [Product Category], -- Joined in from Category Table
  p.[Color] AS [Product Color], 
  p.[Size] AS [Product Size], 
  p.[ProductLine] AS [Product Line], 
  p.[ModelName] AS [Product Model Name], 
  p.[EnglishDescription] AS [Product Description], 

  ISNULL (p.Status, 'Outdated') AS [Product Status] 
FROM 
  [AdventureWorksDW2019].[dbo].[DimProduct] as p
  LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
  LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey 
order by 
  p.ProductKey asc

```

### FACT_InternetSales
```
-- Cleansed FACT_InternetSales Table --
SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  [SalesOrderNumber],  
  [SalesAmount],  
  [TaxAmt] AS TaxAmount,
  [Freight]
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales]
WHERE 
  LEFT (OrderDateKey, 4) >= 2019 -- Ensures we always only bring two years of date from extraction.
ORDER BY
  OrderDateKey ASC

```

## Data Model
Here's a Screenshot of how we organized the data in Power BI after cleaning and getting it ready. This Screenshot also shows how we connected FACT_Budget with FACT_InternetSales and some other important tables.
![image](https://github.com/RawanHamza/Sales_Management/assets/62294577/9f463087-f820-4036-bdfa-94486c98cdf8)

## Sales Management Dashboard
The completed sales management dashboard has one main page that works as an overview dashboard. Additionally, there are two other pages that concentrate on bringing together tables for important information and creating visuals to display sales trends over time, for individual customers, and for products.

### [Click Here to open the dashboard and try it out!](https://www.novypro.com/project/sales-management-3)

[![image](https://github.com/RawanHamza/Sales_Management/assets/62294577/08c6c0f0-93ee-43be-973e-d7754c59f169)]

