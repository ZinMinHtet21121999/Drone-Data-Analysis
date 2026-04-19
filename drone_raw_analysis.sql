--- view data set ---
SELECT *
From drone;
--- Total records ---
SELECT count(*) as total_records
From drone;
--- No of Drone's type---
SELECT drone_type,
	count(*) as no_of_drones
From drone
GROUP by drone_type;
--- null checks -- 
SELECT 
	sum(case when drone_type is null then 1 Else 0 END )as drone_type_check,
    sum(case when motor_count is null then 1 Else 0 END )as motor_count_check,
    sum(case when motor_current is null then 1 Else 0 END )as motor_current_check,
    sum(case when total_current is null then 1 Else 0 END )as total_current_check,
    sum(case when battery_capacity is null then 1 Else 0 END )as battery_capacity_check,
    sum(case when usable_battery is null then 1 Else 0 END )as usable_battery_check,
    sum(case when estimated_time is null then 1 Else 0 END )as estimated_time_check,
    sum(case when cruise_speed is null then 1 Else 0 END )as cruise_speed_check,
	sum(case when max_distance is null then 1 Else 0 END )as max_distance_check,
    sum(case when target_distance is null then 1 Else 0 END )as target_distance_check
From drone;

---- duplicate check ----
SELECT *,
	COUNT(*)over(partition by id) as duplicate_id
From drone;

--- Average distance by Drone Type ----
SELECT drone_type,
	avg(max_distance) over (partition by drone_type) as avg_distance
From drone
group by drone_type;

SELECT drone_type,
	avg(max_distance) as avg_distance
From drone
group by drone_type;

----Top 5 Longest Flight ---
SELECT id,
	max_distance
From drone 
group by id
order by max_distance desc
limit 5;

with ranked_flight as(
SELECT id,
	max_distance,
   	rank()over(ORDER by max_distance desc) as rnk
From drone )
SELECT *
From ranked_flight
where rnk <=5;

--- Drone Type Ranking ---
SELECT id,
	drone_type,
    max_distance,
    rank() over(partition by drone_type
                order by max_distance desc) as rnk_dre
From drone;

--- Distance vs Average Distance Comparison
SELECT drone_type,
	  avg(max_distance) over (partition by drone_type) as avg_distance
From drone
group by drone_type;

--- Distance above average ----
with avg_dist as (
SELECT avg(max_distance) as avg_distance
From drone )

SELECT * 
From drone 
where max_distance > (SELECT avg_distance
                      From avg_dist);
                      
--- Best efficiency drone ---
SELECT *,
	(max_distance / battery_capacity) as efficiency
From drone
order by efficiency DESC
limit 5;
with effi as( 
select id,
	(max_distance / battery_capacity) as efficiency
From drone),
ranked as(
SELECT *,
	rank() over (order by efficiency desc) as rnk
From effi)
SELECT * 
From ranked 
where rnk <=5;

--- Weight vs Average Distance ----
SELECT total_weight,
	avg(max_distance) as avg_distance
From drone
group by total_weight
order by avg_distance desc;

--- Running Average distance ---
select id,
	max_distance,
    avg(max_distance) over (order by id) as running_avg_distance
From drone;

--- Target Analysis ---
SELECT can_reach,
	count(*) as total
From drone
GROUP by can_reach;
	


