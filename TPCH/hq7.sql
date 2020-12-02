-- Copyright (c) 2020, Oracle and/or its affiliates.
-- Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

SELECT /*+ set_var(use_secondary_engine=forced) */  
    supp_nation, cust_nation, l_year, SUM(volume) AS revenue
FROM
    (SELECT 
        n1.n_name AS supp_nation,
            n2.n_name AS cust_nation,
            EXTRACT(YEAR FROM l_shipdate) AS l_year,
            l_extendedprice * (1 - l_discount) AS volume
    FROM
        SUPPLIER
    STRAIGHT_JOIN NATION n1
    STRAIGHT_JOIN LINEITEM
    STRAIGHT_JOIN ORDERS
    STRAIGHT_JOIN CUSTOMER
    STRAIGHT_JOIN NATION n2
    WHERE
        s_suppkey = l_suppkey
            AND o_orderkey = l_orderkey
            AND c_custkey = o_custkey
            AND s_nationkey = n1.n_nationkey
            AND c_nationkey = n2.n_nationkey
            AND ((n1.n_name = 'FRANCE'
            AND n2.n_name = 'GERMANY')
            OR (n1.n_name = 'GERMANY'
            AND n2.n_name = 'FRANCE'))
            AND l_shipdate BETWEEN DATE '1995-01-01' AND DATE '1996-12-31') AS shipping
GROUP BY supp_nation , cust_nation , l_year
ORDER BY supp_nation , cust_nation , l_year;