WITH person_main_address AS (

    SELECT
        person.businessentityid AS person_id,
        min(lookup.addressid) AS main_address_id
    FROM
        sales.customer AS customer
        --
        LEFT OUTER JOIN
            person.person as person
        ON
            customer.personid = person.businessentityid
        --
        LEFT OUTER JOIN
            person.businessentityaddress AS lookup
        ON
            customer.customerid = lookup.businessentityid
    GROUP BY
        1

),

person_address AS (
    SELECT
        person.businessentityid AS person_id,
        addy.postalcode AS postal_code,
        addy.city AS city,
        st.name AS state,
        country.name AS country
    FROM
        person.person AS person
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
        INNER JOIN
            person_main_address
        ON
            person.businessentityid = person_main_address.person_id
)

SELECT
    customer.customerid AS customer_id,
    person.firstname AS first_name,
    person.lastname AS last_name,
    person.persontype AS person_type,
    person_address.postal_code AS postal_code,
    person_address.city AS city,
    person_address.state AS state,
    person_address.country AS country,
    email.emailaddress AS email,
    person.*
FROM
    sales.customer AS customer
    --
    LEFT OUTER JOIN
        person.person AS person
    ON
        customer.personid = person.businessentityid
    --
    LEFT OUTER JOIN
        person_address
    ON
        person.businessentityid = person_address.person_id
    --
    LEFT OUTER JOIN
        person.emailaddress AS email
    ON
        person.businessentityid = email.businessentityid
WHERE
    --(main_address.main_address_id is null OR
    --main_address.main_address_id = lookup.addressid) and
    (customer.customerid = 18689 or
    customer.customerid = 29825)
ORDER BY
    1
