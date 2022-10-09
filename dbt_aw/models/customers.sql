WITH
    customers AS (

    SELECT
        person.firstname AS firstname,
        person.lastname AS lastname,
        address.postalcode AS postalcode,
        address.city AS city,
        state.name AS state,
        country.name AS country,
        email.emailaddress AS email
    FROM
        sales.customer AS customer
        --
        LEFT OUTER JOIN
            person.person as person
        ON
            customer.personid = person.businessentityid
        --
        LEFT OUTER JOIN
            businessentityaddress AS addresslookup
        ON
            person.businessentityid = addresslookup.businessentityid
        --
        LEFT OUTER JOIN
            person.address AS address
        ON
            addresslookup.addressid = address.addressid
        --
        LEFT OUTER JOIN
            person.stateprovince AS state
        ON
            address.stateprovinceid = state.stateprovinceid
        --
        LEFT OUTER JOIN
            countryregion AS country
        ON
            state.countryregioncode = country.countryregioncode
        --
        LEFT OUTER JOIN
            emailaddress AS email
        ON
            person.businessentityid = email.businessentityid
    )
