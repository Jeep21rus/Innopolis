/*
Найти контракты одинаковой стоимости.
Вывести count, amount
*/

select
	count(*) as count
	,c.amount
from contract as c
group by c.amount
having count(*) > 1;
