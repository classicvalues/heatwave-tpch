-- Copyright (c) 2020, Oracle and/or its affiliates.
-- Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

SELECT /*+ set_var(use_secondary_engine=forced) */   
    c_custkey,
    c_name,
    SUM(l_extendedprice * (1 - l_discount)) AS revenue,
    c_acctbal,
    n_name,
    c_address,
    c_phone,
    c_comment
FROM
    ORDERS
        STRAIGHT_JOIN
    LINEITEM
        STRAIGHT_JOIN
    CUSTOMER
        STRAIGHT_JOIN
    NATION
WHERE
    c_custkey = o_custkey
        AND l_orderkey = o_orderkey
        AND o_orderdate >= DATE '1993-10-01'
        AND o_orderdate < DATE '1993-10-01' + INTERVAL '3' MONTH
        AND l_returnflag = 'R'
        AND c_nationkey = n_nationkey
GROUP BY c_custkey , c_name , c_acctbal , c_phone , n_name , c_address , c_comment
ORDER BY revenue DESC
LIMIT 20;