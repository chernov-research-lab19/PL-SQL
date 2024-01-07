/*Створити PL-SQL блок, який по employee_id визначає посаду співробітника.
Деталі: Завести змінну v_employee_id з типом даних, як у стовпчика employee_id
в таблиці hr.employees, відразу присвоїти цій змінній якесь значення (наприклад 110). 
Також завести змінну v_job_id типу даних, як стовпчик job_id в таблиці hr.employees 
та змінну v_job_title типу даних, як стовпчик job_title в таблиці hr.jobs.

Далі в середині PL-SQL блоку, через окремі два запити (без JOIN-нів) визначити посаду. 
Відразу по v_employee_id знаходимо ід посади, значення через INTO записуємо в змінну v_job_id. 

Наступним кроком по v_job_id, знаходимо job_title і записуємо значення в змінну v_job_title через оператор INTO. 

В кінці PL-SQL блоку, виводимо інформацію на екран із зміною v_job_title.

Зберегти PL-SQL блок у файл під назвою H_02_01_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/
DECLARE
v_employee_id  hr.employees.employee_id%TYPE := 110;
v_job_id       hr.employees.job_id%TYPE;
v_job_title    hr.jobs.job_title%TYPE;

BEGIN

SELECT em.job_id
INTO v_job_id
FROM hr.employees em
WHERE em.employee_id = v_employee_id;

SELECT jb.job_title
INTO v_job_title
FROM hr.jobs jb
WHERE jb.job_id = v_job_id;

dbms_output.put_line('Посада співробітника з employee_id ='  || v_employee_id || ' - '||  v_job_title);

END;
/