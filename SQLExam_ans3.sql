USE [WideWorldImporters]
GO

CREATE OR ALTER PROCEDURE dbo.ReportCustomerTurnover 
	@Choice int = 1, --Default value for Choice is 1
	@Year int = 2013 --Default value for Year is 2013
AS
BEGIN 
	/*
	When Choice = 1 and Year = <aYear>, 
	ReportCustomerTurnover selects 
	all the customer names and
	their total monthly turnover (invoiced value) for the year <aYear>.
	*/
	IF (@Choice = 1)
		BEGIN
			SELECT 
				CustomerName,
				
				-- Monthly turnover for each month, replacing NULL by 0 
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 1
						THEN Quantity * UnitPrice
						END 
				),0) Jan,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 2
						THEN Quantity * UnitPrice
						END 
				),0) Feb,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 3
						THEN Quantity * UnitPrice
						END 
				),0) Mar,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 4
						THEN Quantity * UnitPrice
						END 
				),0) Apr,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 5
						THEN Quantity * UnitPrice
						END 
				),0) May,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 6
						THEN Quantity * UnitPrice
						END 
				),0) June,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 7
						THEN Quantity * UnitPrice
						END 
				),0) Jul,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 8
						THEN Quantity * UnitPrice
						END 
				),0) Aug,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 9
						THEN Quantity * UnitPrice
						END 
				),0) Sep,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 10
						THEN Quantity * UnitPrice
						END 
				),0) Oct,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 11
						THEN Quantity * UnitPrice
						END 
				),0) Nov,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) = 12
						THEN Quantity * UnitPrice
						END 
				),0) Dec
			FROM
				Sales.InvoiceLines IL,
				Sales.Invoices I,
				Sales.Customers C
			WHERE 
				IL.InvoiceID = I.InvoiceID
				AND I.CustomerID = C.CustomerID
				AND YEAR(InvoiceDate) = @Year
			GROUP BY CustomerName
			ORDER BY CustomerName
		END
	
	/*
	When Choice = 2 and Year = <aYear>, 
	ReportCustomerTurnover selects 
	all the customer names and 
	their total quarterly (3 months) turnover (invoiced value) for the year <aYear>.
	*/
	ELSE IF (@Choice = 2)
		BEGIN
			SELECT 
				CustomerName,

				-- Quarterly turnovers, replace NULL by 0
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) BETWEEN 1 AND 3
						THEN Quantity * UnitPrice
						END 
				),0) Q1,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) BETWEEN 4 AND 6
						THEN Quantity * UnitPrice
						END 
				),0) Q2,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) BETWEEN 7 AND 9
						THEN Quantity * UnitPrice
						END 
				),0) Q3,
				ISNULL(SUM(CASE WHEN MONTH(i.InvoiceDate) BETWEEN 10 AND 12
						THEN Quantity * UnitPrice
						END 
				),0) Q4
			FROM
				Sales.InvoiceLines IL,
				Sales.Invoices I,
				Sales.Customers C
			WHERE 
				IL.InvoiceID = I.InvoiceID
				AND I.CustomerID = C.CustomerID
				AND YEAR(InvoiceDate)= @Year
			GROUP BY CustomerName
			ORDER BY CustomerName
		END
	
	/*
	When Choice = 3, 
	ReportCustomerTurnover selects 
	all the customer names and 
	their total yearly turnover (invoiced value).
	*/
	ELSE IF (@Choice = 3)
		BEGIN
			SELECT 
				CustomerName,

				-- Yearly turnover, replace NULL by 0
				ISNULL(SUM(CASE WHEN YEAR(i.InvoiceDate) =2013
						THEN Quantity * UnitPrice
						END 
				),0) '2013',
				ISNULL(SUM(CASE WHEN YEAR(i.InvoiceDate) =2014
						THEN Quantity * UnitPrice
						END 
				),0) '2014',
				ISNULL(SUM(CASE WHEN YEAR(i.InvoiceDate) =2015
						THEN Quantity * UnitPrice
						END 
				),0) '2015',
				ISNULL(SUM(CASE WHEN YEAR(i.InvoiceDate) =2016
						THEN Quantity * UnitPrice
						END 
				),0) '2016'
			FROM
				Sales.InvoiceLines IL,
				Sales.Invoices I,
				Sales.Customers C
			WHERE 
				IL.InvoiceID = I.InvoiceID
				AND I.CustomerID = C.CustomerID
			GROUP BY CustomerName
			ORDER BY CustomerName
		END
END
GO

--EXEC ReportCustomerTurnover;
--EXEC dbo.ReportCustomerTurnover 1, 2014
--EXEC dbo.ReportCustomerTurnover 2, 2015
EXEC dbo.ReportCustomerTurnover 3;