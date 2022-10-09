SELECT
    *
FROM
    sales.salesorderheader AS salesorderheader
    --
    LEFT OUTER JOIN
        sales.customer AS customer
    ON
        salesorderheader.customerid = customer.customerid
    --
    LEFT OUTER JOIN
        person.person AS person
    ON
        customer.customerid = person.businessentityid
    --
    LEFT OUTER JOIN
        sales.salesperson as salesperson
    ON
        salesorderheader.salespersonid = salesperson.businessentityid
    --
    LEFT OUTER JOIN
        person.person as sales_people
    ON
        salesperson.businessentityid = sales_people.businessentityid
WHERE
    1=1
--LIMIT 10
