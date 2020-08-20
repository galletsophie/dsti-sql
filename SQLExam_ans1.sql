/*
Using the database WideWorldImporters, write a SQL query which reports the consistency between orders and their attached invoices.
The resultset should report for each (CustomerID, CustomerName)
 a. the total number of orders: TotalNBOrders
 b. the number of invoices converted from an order: TotalNBInvoices
 c. the total value of orders: OrdersTotalValue
 d. the total value of invoices: InvoicesTotalValue
 f. the absolute value of the difference between c - d: AbsoluteValueDifference

 The resultset must be sorted by highest values of AbsoluteValueDifference, then by smallest to highest values of TotalNBOrders and CustomerName is that order.

*/


USE [WideWorldImporters]
; --I get an error without this initial ;
WITH order_info as
	(SELECT
		O.CustomerID as CustomerID,
		O.OrderID as OrderID,
		SUM(OL.Quantity * OL.UnitPrice) as OrdersTotalValue
	FROM
		Sales.OrderLines OL,
		Sales.Orders O
	WHERE O.OrderID = OL.OrderID
	GROUP BY O.CustomerID, O.OrderID),

	invoice_info as
	(SELECT
		I.CustomerID as CustomerID,
		I.InvoiceID as InvoiceID,
		I.OrderID as OrderID,
		SUM(IL.Quantity * IL.UnitPrice) as InvoicesTotalValue
	FROM
		Sales.InvoiceLines IL,
		Sales.Invoices I
	WHERE I.InvoiceID = IL.InvoiceID
	GROUP BY I.CustomerID, I.InvoiceID, OrderID)

SELECT
	O.CustomerID,
	CustomerName,
	COUNT(O.OrderID) TotalNBOrders,
	COUNT(I.InvoiceID) TotalNBInvoices,
	SUM(OrdersTotalValue) OrdersTotalValue,
	SUM(InvoicesTotalValue) InvoicesTotalValue,
	ABS(SUM(OrdersTotalValue) - SUM(InvoicesTotalValue)) AbsoluteValueDifference
FROM
	order_info O,
	invoice_info I,
	Sales.Customers C
WHERE
	O.CustomerID = I.CustomerID
	AND O.CustomerID = C.CustomerID
	AND O.OrderID = I.OrderID
GROUP BY O.CustomerID, CustomerName
ORDER BY AbsoluteValueDifference DESC, TotalNBOrders, CustomerName
;
