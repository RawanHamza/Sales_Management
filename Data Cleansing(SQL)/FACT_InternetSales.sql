-- Cleansed FACT_InternetSales Table --
SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 

  [SalesOrderNumber], 
 
  [SalesAmount] ,  
  [TaxAmt] AS TaxAmount,
  [Freight]

FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales]
WHERE 
  LEFT (OrderDateKey, 4) >= 2019 -- Ensures we always only bring two years of date from extraction.
ORDER BY
  OrderDateKey ASC

 
