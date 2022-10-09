SELECT
    person.firstname AS firstname,
    person.lastname AS lastname,
    person.persontype AS persontype,
    addy.postalcode AS postalcode,
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
WHERE
    lookup.addressid is not null
