--- Check dataset ---
SELECT *
From analysis
limit 5;

SELECT count(*) as total_row
From analysis;

--- Drone Type Distribution ---
Select DISTINCT drone_type,
	count(*) as total_drones
From analysis
GROUP by drone_type
order by total_drones desc;

--- Average Performance by Drone Type ----
SELECT drone_type,
	avg(performance_scor) as avg_per_score
	
from analysis
group by drone_type
order by avg_per_score desc;

--- Average Battery Efficiency Comparison by Drone Type---
Select drone_type,
	avg(battery_efficien) as avg_batt_effi
from analysis
GROUP by drone_type
order by avg_batt_effi desc;

--- Target Distance Success Rate ---
SELECT drone_type,
	sum( case when can_reach = 'YES' then 1 else 0 End) as success_rate,
    sum( case when can_reach = 'NO' then 1 else 0 End) as fail_rate
From analysis
GROUP by drone_type
order by success_rate desc,fail_rate desc;

-- Top 10 Performing Drones --
with ranked as (SELECT id,
	drone_type,
    performance_scor,
    rank() over (order by performance_scor desc) as rnk
 from analysis
 group by id,drone_type)
SELECT * 
From ranked
where rnk <=10;

select id,
	drone_type,
    performance_scor
From analysis
GROUP by id,drone_type
order by performance_scor desc;

--- Distance Above Average ---
with avg_dist as(
SELECT avg(max_distance) as avg_distance
From analysis)
SELECT id,drone_type
From analysis
where max_distance > (SELECT avg_distance
                     From avg_dist);
-- Weight Impact on Average Flight Distance --- 
SELECT total_weight,avg(max_distance) as avg_distance
From analysis
GROUP by total_weight
order by avg_distance desc;

--- Performance Category Distribution ---
SELECT performance_cate,
	count(*) as total_record
    
 from analysis
 GROUP by performance_cate;

--- Running Average ---
SELECT id,
	max_distance,
    avg(max_distance) over(order by id) as running_total
From analysis;

--- Performance Score vs Drone Type Ranking ---
SELECT drone_type,
	performance_scor,
    dense_rank() over(partition by drone_type
                     order by performance_scor desc) den_rnk
From analysis;

--- Battery Drain Analysis ---
SELECT drone_type,
	avg(battery_drain_ra) as average_drain_rate, 
    row_number()over(order by avg(battery_drain_ra) desc) as rank
From analysis
GROUP by drone_type;

SELECT drone_type,
	avg(battery_drain_ra) as average_drain_rate
From analysis
GROUP by drone_type
order by average_drain_rate;

--- Efficiency vs Performance ---
SELECT id,
	battery_efficien,
    performance_scor
From analysis
order by battery_efficien desc;

--- Speed Impact on Distance ---
SELECT avg(avg_speed) as avg_speed,
	avg(max_distance) as avg_distance
From analysis;

--- Distance Percentile ---
SELECT id,
	drone_type,
    max_distance,
    NTILE(4) over (order by max_distance desc) as distance_quartile
   
From analysis;
    



