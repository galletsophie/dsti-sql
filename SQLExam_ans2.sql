
/*
Q2. For the CustomerId = 1060 (CustomerName = 'Anand Mudaliyar')
Identify the first InvoiceLine of his first Invoice, 
where "first" means the lowest respective IDs, 
and write an update query increasing the UnitPrice of this InvoiceLine by 20.

Preliminary work

-- Select InvoiceID of first invoice 
SELECT TOP 1 InvoiceID -- 69627
FROM Sales.Invoices 
WHERE CustomerID = 1060
ORDER BY InvoiceID

-- Select first invoice line(s) of first invoice with TOP
SELECT TOP 5 * 
FROM Sales.InvoiceLines 
WHERE InvoiceID = (SELECT TOP 1 InvoiceID -- 69627
	FROM Sales.Invoices 
	WHERE CustomerID = 1060
	ORDER BY InvoiceID)
ORDER BY InvoiceLineID

-- Select first invoice line of first invoice without top
SELECT * 
FROM 
	Sales.InvoiceLines IL1,
	(SELECT TOP 1 * 
	FROM Sales.InvoiceLines 
	WHERE InvoiceID = (SELECT TOP 1 InvoiceID -- 69627
		FROM Sales.Invoices 
		WHERE CustomerID = 1060
		ORDER BY InvoiceID)
	ORDER BY InvoiceLineID) IL2
WHERE 
	IL1.InvoiceLineID = IL2.InvoiceLineID
*/

USE [WideWorldImporters]

UPDATE Sales.InvoiceLines
SET UnitPrice = IL.UnitPrice + 20 
FROM (SELECT 
		TOP 1 * 
	FROM Sales.InvoiceLines 
	WHERE InvoiceID = (
		SELECT TOP 1 InvoiceID -- 69627
		FROM Sales.Invoices 
		WHERE CustomerID = 1060
		ORDER BY InvoiceID)
	ORDER BY InvoiceLineID) AS IL
WHERE Sales.InvoiceLines.InvoiceLineID = IL.InvoiceLineID
;