WITH addy AS (

    SELECT * FROM {{ ref('stg_addresses') }}

)

SELECT
    customer.customerid AS customer_id,
    person.firstname AS first_name,
    person.lastname AS last_name,
    person.persontype AS person_type,
    email.emailaddress AS email,
    addy.postal_code AS postal_code,
    addy.city AS city,
    addy.state AS state,
    addy.state AS country
FROM
    sales.customer AS customer
    --
    LEFT OUTER JOIN
        person.person AS person
    ON
        customer.personid = person.businessentityid
    --
    LEFT OUTER JOIN
        person.emailaddress AS email
    ON
        person.businessentityid = email.businessentityid
    --
    LEFT OUTER JOIN
        addy
    ON
        person.businessentityid = addy.person_id
