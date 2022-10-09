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
        --person.businessentityid AS person_id,
        addy.postalcode AS postal_code,
        addy.city AS city,
        st.name AS state,
        country.name AS country,
        person_main_address.*,
        lookup.*
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

select * from person_address
where person_id = 4073
