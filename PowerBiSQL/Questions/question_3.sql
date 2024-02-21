SELECT store_type, SUM(product_quantity * sale_price) AS Revenue
FROM 
    forview
WHERE
    dates LIKE '%2022%'
    AND
    country = 'Germany'
GROUP BY
    store_type
ORDER BY
    Revenue DESC
LIMIT 1;