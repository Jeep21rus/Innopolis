/*
Найти отдел, заключивший контрактов на наибольшую сумму.
Вывести: department_name, sum
*/

-- 1 вариант (производная таблица)
select
	d.name as department_name
	,sum(c.amount) as sum
from department as d
	inner join employees as e on d.id = e.department_id
	inner join executor as ex on e.id = ex.tab_no
	inner join contract as c on ex.contract_id = c.id
group by d.name
having sum(c.amount) = (
	select max(q1.sum)
	from (
		select sum(c.amount) as sum
		from department as d
			inner join employees as e on d.id = e.department_id
			inner join executor as ex on e.id = ex.tab_no
			inner join contract as c on ex.contract_id = c.id
		group by d.name
		) as q1);

-- 2 вариант (обобщённое табличное выражение)
with cte as(
	select sum(c.amount) as sum
	from department as d
		inner join employees as e on d.id = e.department_id
		inner join executor as ex on e.id = ex.tab_no
		inner join contract as c on ex.contract_id = c.id
	group by d.name)
	
select
	d.name as department_name
	,sum(c.amount) as sum
from department as d
	inner join employees as e on d.id = e.department_id
	inner join executor as ex on e.id = ex.tab_no
	inner join contract as c on ex.contract_id = c.id
group by d.name
having sum(c.amount) = (
	select max(sum)
	from cte);

-- 3 вариант (оператор all)
select
	d.name as department_name
	,sum(c.amount) as sum
from department as d
	inner join employees as e on d.id = e.department_id
	inner join executor as ex on e.id = ex.tab_no
	inner join contract as c on ex.contract_id = c.id
group by d.name
having sum(c.amount) >= all (
	select sum(c.amount) as sum
	from department as d
		inner join employees as e on d.id = e.department_id
		inner join executor as ex on e.id = ex.tab_no
		inner join contract as c on ex.contract_id = c.id
	group by d.name);

-- 4 вариант (присоединение таблицы самой к себе)
select
	q1.department_name
	,q1.sum
from (
	select
		d.name as department_name
		,sum(c.amount) as sum
	from department as d
		inner join employees as e on d.id = e.department_id
		inner join executor as ex on e.id = ex.tab_no
		inner join contract as c on ex.contract_id = c.id
	group by d.name
	) as q1 
		inner join (
			select max(q2.sum) as max_sum
			from (
				select sum(c.amount) as sum
				from department as d
					inner join employees as e on d.id = e.department_id
					inner join executor as ex on e.id = ex.tab_no
					inner join contract as c on ex.contract_id = c.id
				group by d.name
				) as q2
			) as q3 on q1.sum = q3.max_sum;

-- 5 вариант (оконная функция)
select
	d.name as department_name
	,sum(c.amount) as sum
from department as d
	inner join employees as e on d.id = e.department_id
	inner join executor as ex on e.id = ex.tab_no
	inner join contract as c on ex.contract_id = c.id
group by d.name
having sum(c.amount) = (
	select
	distinct max(sum(c.amount)) over()
	from department as d
		inner join employees as e on d.id = e.department_id
		inner join executor as ex on e.id = ex.tab_no
		inner join contract as c on ex.contract_id = c.id
	group by d.name);
