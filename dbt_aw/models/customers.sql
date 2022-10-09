WITH customers AS (

    SELECT
        person.businessentityid AS customer_id,
        person.firstname AS first_name,
        person.lastname AS last_name,
        person.persontype AS person_type,
        addy.postalcode AS postal_code,
        addy.city AS city,
        st.name AS state,
        country.name AS country,
        email.emailaddress AS email
    FROM
        sales.customer AS customer
        --
        LEFT OUTER JOIN
            person.person AS person
        ON
            customer.personid = person.businessentityid
        --
        LEFT OUTER JOIN
            person.businessentityaddress AS lookup
        ON
            person.businessentityid = lookup.businessentityid
        --
        LEFT OUTER JOIN
            person.address AS addy
        ON
            lookup.addressid = addy.addressid
        --
        LEFT OUTER JOIN
            person.stateprovince AS st
        ON
            addy.stateprovinceid = st.stateprovinceid
        --
        LEFT OUTER JOIN
            person.countryregion AS country
        ON
            st.countryregioncode = country.countryregioncode
        --
        LEFT OUTER JOIN
            person.emailaddress AS email
        ON
            person.businessentityid = email.businessentityid

),

orders AS (

    SELECT
        sales.salesorderid AS order_id,
        customerid AS customer_id,
        orderdate AS order_date,
        status
    FROM
        sales.salesorderheader AS sales
),

customer_orders AS (

    SELECT
        customer_id,
        min(order_date) AS first_order_date,
        max(order_date) AS most_recent_order_date,
        count(order_id) AS number_of_orders
    FROM
        orders
    GROUP BY
        1

),

final AS (

    SELECT
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) AS number_of_orders
    FROM
        customers
        --
        LEFT OUTER JOIN
            customer_orders USING (customer_id)

)

SELECT
    *
FROM
    final
