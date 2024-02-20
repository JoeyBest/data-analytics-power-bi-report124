SELECT sum(staff_numbers) AS Total_UK_Staff
FROM
    dim_store
WHERE
    full_region LIKE '%UK%';