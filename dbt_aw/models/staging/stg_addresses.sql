WITH recent_addresses AS (

    SELECT
        lookup.businessentityid as person_id,
        max(lookup.addressid) max_address_id
    FROM
        person.businessentityaddress lookup
    GROUP BY
        1

)

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
        recent_addresses
    ON
        lookup.businessentityid = recent_addresses.person_id AND
        lookup.addressid = recent_addresses.max_address_id
