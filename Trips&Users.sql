-- https://leetcode.com/problems/trips-and-users/

with 
users_list as
(
    select distinct u.users_id
    from users u
    where u.banned = 'No'
),
unbanned_trip as
(
    select 
       t.id, 
        t.client_id, 
        t.driver_id, 
        t.city_id, 
        t.status, 
        t.request_at
    from trips t
    join users_list c on t.client_id=c.users_id
    join users_list d on t.driver_id = d.users_id
),
total_request_per_day
as
(
    select count(*) as total_request, request_at from unbanned_trip group by request_at
),
cancelled_trip as
(
    select count(status) as num_of_cancelled_trip , request_at from
    unbanned_trip
    where status <> 'completed' group by request_at
)

select t.request_at as Day , 
Round( COALESCE (CAST(c.num_of_cancelled_trip AS FLOAT) , 0) / t.total_request ,2) AS [Cancellation Rate]
FROM total_request_per_day t
LEFT JOIN cancelled_trip c ON t.request_at = c.request_at;

