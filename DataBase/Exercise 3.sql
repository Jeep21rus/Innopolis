/*
Найти самую часто встречающуюся локации среди всех заказчиков.
Вывести: location, count
*/

-- 1 вариант (производная таблица)
select
	cu.location
	,count(*) as count
from customer as cu
group by cu.location
having count(*) = (
	select max(q1.count)
	from (
		select count(*) as count
		from customer as cu
		group by cu.location
		) as q1
	);

-- 2 вариант (обобщённое табличное выражение)
with cte as (
	select
		cu.location
		,count(*) as count
	from customer as cu
	group by cu.location)
	
select
	cu.location
	,count(*) as count
from customer as cu
group by cu.location
having count(*) = (
	select max(cte.count)
	from cte);

-- 3 вариант (оператор all)
select
	cu.location
	,count(*) as count
from customer as cu
group by cu.location
having count(*) >= all (
	select count(*) as count
	from customer as cu
	group by cu.location);

-- 4 вариант (присоединение таблицы самой к себе)
select
	q1.location
	,q1.count
from (
	select
		cu.location
		,count(*) as count
	from customer as cu
	group by cu.location
	) as q1
		inner join (
			select max(q2.count) as max_count
			from (
				select count(*) as count
				from customer as cu
				group by cu.location
				) as q2
			) as q3 on q1.count = q3.max_count;

-- 5 вариант (оконная функция)
select
	cu.location
	,count(*) as count
from customer as cu
group by cu.location
having count(*) = (
	select distinct max(count(*)) over() as max_count
	from customer as cu
	group by cu.location);
