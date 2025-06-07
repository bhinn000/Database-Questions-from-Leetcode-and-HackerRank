--https://leetcode.com/problems/reformat-department-table/

/* Write your T-SQL query statement below */

select id, 
    [Jan] as Jan_Revenue ,
    [Feb] as Feb_Revenue,
    [Mar] as Mar_Revenue,
    [Apr] as Apr_Revenue,
    [May] as May_Revenue,
    [Jun] as Jun_Revenue,
    [Jul] as Jul_Revenue,
    [Aug] AS Aug_Revenue,
    [Sep] AS Sep_Revenue,
    [Oct] AS Oct_Revenue,
    [Nov] AS Nov_Revenue,
    [Dec] AS Dec_Revenue
from
    (
        select id,revenue ,month from department
    ) as source_table
pivot(
    sum(revenue)
    for month in ([Jan],[Feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[Sep],[Oct],[Nov],[Dec])
) as pivot_table;