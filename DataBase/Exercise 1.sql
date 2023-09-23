/*
Найти информацию о всех контрактах, связанных с сотрудниками департамента «Logistic».
Вывести: contract_id, employee_name
*/

-- 1 вариант
select
	ex.contract_id
	,e.name as employee_name
from department as d
	inner join employees as e on d.id = e.department_id
	inner join executor as ex on e.id = ex.tab_no
where d.name = 'Logistic';

-- 2 вариант (where сразу же прописано в условиях соединения таблицы)
select
	ex.contract_id
	,e.name as employee_name
from executor as ex
	inner join employees as e on ex.tab_no = e.id
	inner join department as d on e.department_id = d.id
		and d.name = 'Logistic';

-- 3 вариант (вместо одного соединения - подзапрос)
select
	ex.contract_id
	,e.name as employee_name
from executor as ex
	inner join employees as e on ex.tab_no = e.id
where e.department_id = (
	select
		d.id
	from department as d
	where d.name = 'Logistic'
	);
