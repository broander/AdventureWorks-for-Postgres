SELECT
    sales.salesorderid AS order_id,
    customerid AS customer_id,
    orderdate AS order_date,
    status
FROM
    sales.salesorderheader AS sales
