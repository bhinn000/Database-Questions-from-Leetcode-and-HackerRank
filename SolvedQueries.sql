-- https://www.hackerrank.com/challenges/symmetric-pairs/

SELECT X1, Y1 FROM 
(SELECT F1.X AS X1, F1.Y AS Y1, F2.X AS X2, F2.Y AS Y2 FROM Functions F1 
INNER JOIN Functions F2 ON F1.X=F2.Y AND F1.Y=F2.X 
ORDER BY F1.X) AS A
GROUP BY X1, Y1 
HAVING COUNT(X1)>1 OR X1<Y1 
ORDER BY X1;

-- https://www.hackerrank.com/challenges/sql-projects/

with isNewProject as(
    select  task_id, start_date, end_date,
    case when start_date=lag(end_date) over (order by start_date) then 0
    else 1
    end as isNewPro
    from Projects
),
projectIDCol as(
    select task_id , start_date, end_date, sum(isNewPro) over (order by start_date) as projectID
    from isNewProject
)

select MIN(Start_date), MAX(End_date) from projectIDCol
group by projectID
order by  MAX(end_date) - MIN(start_date) , MIN(Start_date)

with person as(
    select s.id as sid , s.Name, f.friend_id as bestFriend
    from students s 
    join friends f  on s.id=f.id
),
 salary as(
    select s.id  as sid,  p.salary
    from  students s 
    join Packages p
    on s.id=p.id   
)

select p.Name
from person p
join salary s on p.sid=s.sid
join salary fs on p.bestFriend=fs.sid
where s.salary< fs.salary
order by fs.salary


-- https://www.hackerrank.com/challenges/placements/

with person as(
    select s.id as sid , s.Name, f.friend_id as bestFriend
    from students s 
    join friends f  on s.id=f.id
),
 salary as(
    select s.id  as sid,  p.salary
    from  students s 
    join Packages p
    on s.id=p.id   
)

select p.Name
from person p
join salary s on p.sid=s.sid
join salary fs on p.bestFriend=fs.sid
where s.salary< fs.salary
order by fs.salary


-- https://www.hackerrank.com/challenges/the-report/

SELECT 
    CASE
        WHEN g.grade < 8 THEN NULL
        ELSE s.name
    END AS name,
    g.grade, s.marks 
FROM 
    grades g
JOIN 
    students s ON s.marks >= g.min_mark AND s.marks <= g.max_mark
ORDER BY 
    g.grade desc,
    CASE
        WHEN g.grade >= 8 and g.grade<=10 THEN s.name
    END ASC,
    CASE
        WHEN g.grade < 8 THEN s.marks
    END ASC;
 
-- https://www.hackerrank.com/challenges/full-score/
select h.hacker_id,name
from hackers h
join submissions s on  h.hacker_id=s.hacker_id
join challenges c on c.challenge_id=s.challenge_id
join difficulty d on d.difficulty_level=c.difficulty_level 
where s.score=d.score
GROUP BY h.hacker_id, h.name
HAVING COUNT(DISTINCT c.challenge_id) > 1
order by COUNT(DISTINCT c.challenge_id) desc,  h.hacker_id 

-- https://www.hackerrank.com/challenges/the-company/
select C.company_code , C.founder, 
count(distinct lm.lead_manager_code) as lm_count, 
count(distinct sm.senior_manager_code) as sm_count,
count(distinct m.manager_code) as m_count,
count(distinct e.employee_code)  as e_count
from Company C 
join Lead_Manager lm 
on lm.company_code=C.company_code
join Senior_Manager sm
on sm.lead_manager_code=lm.lead_manager_code
join Manager m
on m.senior_manager_code=sm.senior_manager_code
join Employee e
on e.manager_code=m.manager_code
group by C.company_code, C.founder

-- https://www.hackerrank.com/challenges/contest-leaderboard/

WITH max_score_achieved as(
    select  
    s.hacker_id ,s.challenge_id,
    max(s.score) as max_score
    from submissions s
    group by challenge_id ,hacker_id
)
select 
msa.hacker_id, h.name, sum(max_score)
from max_score_achieved msa  
join hackers h 
on h.hacker_id = msa.hacker_id 
group by msa.hacker_id ,h.name
having sum(max_score) <> 0
order by sum(msa.max_score) desc,msa.hacker_id asc;

-- https://www.hackerrank.com/challenges/challenges/

WITH challenge_created AS(
    select ch.hacker_id , h.name  ,count(ch.hacker_id) as chall_created_num
    from challenges ch join hackers h
    on ch.hacker_id = h.hacker_id
    group by ch.hacker_id , h.name 
)
, repeated_chll_num as(
    select chall_created_num, count(chall_created_num) as rpted_cnum
    from challenge_created
    group by chall_created_num
)
select cc.hacker_id ,cc.name , cc.chall_created_num
from challenge_created cc join repeated_chll_num rcn
on cc.chall_created_num= rcn.chall_created_num
where rpted_cnum<=1 
or
cc.chall_created_num>1 and cc.chall_created_num =
        (
            select max(chall_created_num) from challenge_created
        )
order by chall_created_num desc, hacker_id asc;


-- https://www.hackerrank.com/challenges/harry-potter-and-wands/

select
W.id,
P.age,
W.coins_needed,
W.power
from wands  W 
JOIN wands_property  P on W.code = P.code
where P.is_evil = 0 
and W.coins_needed = (
                        select min(a.coins_needed) 
                        from wands a
                        join wands_property b on a.code = b.code
                        where a.code = W.code and
                        a.power = W.power
                      )
order by W.power desc, P.age desc;


-- https://www.hackerrank.com/challenges/weather-observation-station-20/
select round(median(lat_n),4) from station;


-- https://www.hackerrank.com/challenges/weather-observation-station-13/
select round(sum(lat_n),4) from station where lat_n>38.7880 and lat_n<137.2345 ;


-- https://www.hackerrank.com/challenges/occupations/
select doc,prof,sing,act from(
(select name,occupation, row_number() over(partition by occupation order by name ) from occupations o)
pivot(
max(name)
for occupation in ('Doctor' as doc,'Professor' as prof,'Singer' as sing,'Actor' as act)
))order by doc , prof,sing,act;


-- https://www.hackerrank.com/challenges/the-pads/
select 
concat(name,
case when upper(occupation)='DOCTOR' then '(D)'
when upper(occupation)='ACTOR' then '(A)'
when upper(occupation)='PROFESSOR' then '(P)'
else '(S)' 
end)
from occupations 
union
select concat(concat('There are a total of ' , count(*)) , ' doctors.') from occupations where UPPER(occupation)='DOCTOR'
union
select concat(concat('There are a total of ' , count(*)) , ' actors.') from occupations where UPPER(occupation)='ACTOR'
union
select concat(concat('There are a total of ' , count(*)) , ' professors.') from occupations where UPPER(occupation)='PROFESSOR'
union
select concat(concat('There are a total of ' , count(*)) , ' singers.') from occupations where UPPER(occupation)='SINGER';













