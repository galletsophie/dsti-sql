/*Q5. In the database SQLPlayground, write a SQL query selecting all the customers' data who have purchased all the products AND have bought more than 50 products in total (sum of all purchases).
Resultset enclosed in Q5-Resultset.csv*/

USE [SQLPlayground]

SELECT 
	C.*
FROM 
	Customer C,
	Purchase P1 
WHERE NOT EXISTS
(
	SELECT *
	FROM Product P
	WHERE NOT EXISTS
	(
		SELECT *
		FROM Purchase Pu
		WHERE 
			Pu.CustomerId = C.CustomerId
			AND Pu.ProductId = P.ProductId
	)
)
AND C.CustomerId = P1.CustomerId
GROUP BY C.CustomerId, CustomerName
HAVING SUM(P1.Qty)>50
