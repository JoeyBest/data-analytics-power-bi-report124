SELECT month_name, SUM(product_quantity * sale_price) AS Revenue
FROM 
    forview
WHERE
    dates LIKE '%2022%'
GROUP BY
    month_name
ORDER BY
    Revenue DESC
LIMIT 1;