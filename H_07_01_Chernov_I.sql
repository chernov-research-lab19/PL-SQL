/*Опис:
Створити pipelined функцію get_region_cnt_emp
Деталі:
Отримати список регіонів та кількість співробітників у кожному регіоні. Коли буде повністю готовий SQL запит, зробити такий хитрий фільтр
where (em.department_id = null or null is null).
Далі впакеті util створити pipelined функцію get_region_cnt_emp з потрібними типами RECORD та TABLE. 

Зробити вхідний параметр p_departm﻿ent_id default null і в середині функції передати цей параметр в SQL запит - where (em.department_id = p_departm﻿ent_id or p_departm﻿ent_id is null).
Таким чином якщо функцію викликати без значення у параметрі p_departm﻿ent_id, функціюповинна повернути дані по всім департаментом інфу, а якщо передамо конкретне значення у p_departm﻿ent_id, 
тоді функцію повинна повернути дані по переданому департаменту.
*/




BEGIN
    SELECT * FROM TABLE(util.get_region_cnt_emp(p_department_id => 80));
    SELECT * FROM TABLE(util.get_region_cnt_emp());
END;
/


-- select
select 
--rg.region_id,
nvl(rg.region_name,'Not defined') as "Name of the region",
count(em.employee_id) as "Count of employees"
from hr.regions rg

right outer join hr.countries cn
on rg.region_id = cn.region_id

right outer join hr.locations lc
on lc.country_id = cn.country_id

right outer join hr.departments dp
on lc.location_id = dp.location_id

right outer join hr.employees em
on em.department_id = dp.department_id
where (em.department_id = null or null is null)
group by rg.region_name;
