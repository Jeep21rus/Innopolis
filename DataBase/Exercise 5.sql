/*
Найти заказчика с наименьшей средней стоимостью контрактов.
Вывести customer_name, среднее значение amount
*/

-- 1 вариант (производная таблица)
select
	cu.customer_name
	,avg(c.amount) as avg_amount
from contract as c
	inner join customer as cu on c.customer_id = cu.id
group by cu.customer_name
having avg(c.amount) = (
	select min(q1.avg_amount)
	from (
		select
			avg(c.amount) as avg_amount
		from contract as c
			inner join customer as cu on c.customer_id = cu.id
		group by cu.customer_name
		) as q1);

-- 2 вариант (обобщённое табличное выражение)
with cte as (
	select avg(c.amount) as avg_amount
	from contract as c
		inner join customer as cu on c.customer_id = cu.id
	group by cu.customer_name)
	
select
	cu.customer_name
	,avg(c.amount) as avg_amount
from contract as c
	inner join customer as cu on c.customer_id = cu.id
group by cu.customer_name
having avg(c.amount) = (
	select min(cte.avg_amount)
	from cte);

-- 3 вариант (оператор all)
select
	cu.customer_name
	,avg(c.amount) as avg_amount
from contract as c
	inner join customer as cu on c.customer_id = cu.id
group by cu.customer_name
having avg(c.amount) <= all (
	select avg(c.amount) as avg_amount
	from contract as c
		inner join customer as cu on c.customer_id = cu.id
	group by cu.customer_name);

-- 4 вариант (присоединение таблицы самой к себе)
select
	q1.customer_name
	,q1.avg_amount
from (
	select
		cu.customer_name
		,avg(c.amount) as avg_amount
	from contract as c
		inner join customer as cu on c.customer_id = cu.id
	group by cu.customer_name
	) as q1
		inner join (
			select min(q2.avg_amount) as min_avg
			from (
				select avg(c.amount) as avg_amount
				from contract as c
					inner join customer as cu on c.customer_id = cu.id
				group by cu.customer_name
				) as q2
			) as q3 on q1.avg_amount = q3.min_avg;

-- 5 вариант (оконная функция)
select
	cu.customer_name
	,avg(c.amount) as avg_amount
from contract as c
	inner join customer as cu on c.customer_id = cu.id
group by cu.customer_name
having avg(c.amount) = (
	select distinct min(avg(c.amount)) over()
	from contract as c
		inner join customer as cu on c.customer_id = cu.id
	group by cu.customer_name);
