/*
Найти среднюю стоимость контрактов, заключенных сотрудников Ivan Ivanov.
Вывести: среднее значение amount
*/

-- 1 вариант
select
	avg(c.amount) as avg_amount
from employees as e
	inner join executor as ex on e.id = ex.tab_no
	inner join contract as c on ex.contract_id = c.id
where e.name = 'Ivan Ivanov';

-- 2 вариант (вместо одного соединения - подзапрос)
select
	avg(c.amount) as avg_amount
from contract as c
	inner join executor as ex on c.id = ex.contract_id
where ex.tab_no = (
	select 
		e.id
	from employees as e
	where e.name = 'Ivan Ivanov'
	);

-- 3 вариант (where сразу же прописано в условиях соединения таблицы)
select
	avg(c.amount) as avg_amount
from contract as c
	inner join executor as ex on c.id = ex.contract_id
	inner join employees as e on ex.tab_no = e.id
		and e.name = 'Ivan Ivanov';
