CREATE VIEW StoreSalesView AS
SELECT
    store_type,
    SUM(product_quantity * sale_price) AS Total_Sales,
    (SUM(product_quantity * sale_price) / (SELECT SUM(product_quantity * sale_price) FROM forview)) * 100 AS Percentage_Of_Total_Sales,
    COUNT(*) AS Order_Count
FROM
    forview
GROUP BY
    store_type;

SELECT * FROM StoreSalesView;