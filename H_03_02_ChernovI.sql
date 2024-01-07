/*Опис:
Створити функцію яка буде повертати назву департаменту по співробітнику

Деталі:
Створити функцію get_dep_name, яка (залежно від ІД співробітника), повертала би назву департаменту, це працює співробітник. 
Перед цим створити у своїй схемі копію таблиці HR.DEPARTMENTS.

Після створення функції, написати SQL запит з таблиці співробітників і замість полів
JOB_ID, виводити назву посади за допомогою функції get_job_﻿title (ми її вже створили напрактиці),
замість поля department_id виводити назву департаменту за допомогою функції get_dep_name.

Зберегти код для створення функції (та селект із другої крапочки) у файл під назвою H_03_02_tvoji_inichialy.sql.
*/

create table igor.DEPARTMENTS as
select *
from hr.DEPARTMENTS dp;

--обьявление функции
CREATE FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR IS v_dp_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
    SELECT dp.department_name
    INTO v_dp_name
    FROM DEPARTMENTS dp
    JOIN employees em
    ON em.department_id = dp.department_id
    WHERE em.employee_id = p_employee_id;
    RETURN v_dp_name;
END get_dep_name;
/

--вызов функции

DECLARE -- не работет если запускать все выражение DECLARE....END, только селект

BEGIN
    SELECT em.employee_id,
        em.first_name,
        em.last_name,
        get_job_title(p_employee_id => em.employee_id) as job_title,
        get_dep_name(p_employee_id => em.employee_id) as dep_name
    FROM employees em;

END;
/
