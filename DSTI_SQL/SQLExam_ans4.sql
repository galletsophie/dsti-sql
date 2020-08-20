USE [WideWorldImporters]
;
-- Info on non-invoiced orders
WITH order_info AS
	(SELECT 
		O.CustomerID as CustomerID, 
		O.OrderID as OrderID, 
		SUM(OL.Quantity * OL.UnitPrice) as OrdersTotalValue
	FROM 
		Sales.OrderLines OL,
		Sales.Orders O
	WHERE O.OrderID = OL.OrderID
	AND NOT EXISTS 
	(
		SELECT * FROM Sales.Invoices I
		WHERE I.OrderID = O.OrderID
	)
	GROUP BY O.CustomerID, O.OrderID
	),

-- Info on customers
	cust_info as
(
	SELECT 
		C.CustomerID,
		C.CustomerName,
		CC.CustomerCategoryName,
		CC.CustomerCategoryID
	FROM 
		Sales.CustomerCategories CC,
		Sales.Customers C
	WHERE C.CustomerCategoryID = CC.CustomerCategoryID
),

-- Info on losses 
	all_losses as
(
	SELECT
		C.CustomerCategoryName,
		SUM(OrdersTotalValue) MaxLoss,
		C.CustomerName,
		C.CustomerID
	FROM 
		order_info O,
		cust_info C
	WHERE O.CustomerID = C.CustomerID
	GROUP BY C.CustomerID, C.CustomerName, C.CustomerCategoryName
)

-- Selection of row with MaxLoss for each CustomerCategory
SELECT cat_losses.* 
FROM 
(	
	SELECT 
		DISTINCT CustomerCategoryName
		FROM Sales.CustomerCategories
) CC
CROSS APPLY 
(
	SELECT TOP 1 * 
	FROM all_losses AL
	WHERE AL.CustomerCategoryName = CC.CustomerCategoryName
	ORDER BY MaxLoss DESC
) cat_losses
ORDER BY MaxLoss DESC
;