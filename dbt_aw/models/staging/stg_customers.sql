WITH main_address AS (

    SELECT
        businessentityid AS customer_id,
        min(addressid) AS main_address_id
    FROM
        person.businessentityaddress
    GROUP BY
        1

)

SELECT
    customer.customerid AS customer_id,
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
        main_address
    ON
        lookup.addressid = main_address.main_address_id
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
