-- https://leetcode.com/problems/rising-temperature/

select w2.id
from Weather w1 --previous
join Weather w2 --current
    on Datediff(day, w1.recordDate ,w2.recordDate) = 1
    and w2.temperature > w1.temperature
;
