/*2. Опис:
Зробити потрібний звіт і сформувати CSV файл на диску.
Деталі:
Зробити звіт на основі CSV файлу PROJECTS.csv (у файлі три рядка, тобто три проєкти), файл знаходиться у директорії FILES_FROM_SERVER, 
структура: project_id NUMBER, project_name VARCHAR2, department_id NUMBER).

Необхідний групований звіт в рамках трьох проєктів, 
де треба показати назву департаментів, кількість співробітників, кількість унікальних менеджерів та сумарна зарплата.
SQL запит який формує остаточний звіт, треба завернути у
VIEW rep_project_dep_v і в середині цикла FOR, обовʼязково використовувати запит з
rep_project_dep_v (просто селект в середині FOR через механізм
"FROM EXTERNAL" в середині PL-SQL блока буде сприйматися як синтаксична помилка. А через оболонку VIEW - НІ ). 
Отриманий звіт треба завантажити в директорію FILES_FROM_SERVER під назвою TOTAL_PROJ_INDEX _tvoji_inichialy.csv
Зберегти PL-SQL блок у файл під назвою H_05_02_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/



CREATE view  total_rep_project_dep_v2 as
SELECT ext_f1.project_id, ext_f1.project_name, ext_f1.department_id
FROM EXTERNAL ( 
(   project_id NUMBER,
    project_name VARCHAR2(100),
     department_id NUMBER
) TYPE oracle_loader DEFAULT DIRECTORY FILES_FROM_SERVER
-- вказуємо назву директорії в БД
ACCESS PARAMETERS ( records delimited BY newline nologfile nobadfile fields terminated BY ',' missing field VALUES are NULL ) LOCATION('PROJECTS.csv')
-- вказуємо назву файлу
REJECT LIMIT UNLIMITED
/*немає обмежень для відкидання рядків*/
) ext_f1;

select * from total_rep_project_dep_v2;


/*Write file*/
CREATE OR REPLACE PROCEDURE WRITE_FILE_TO_DISK IS
    file_handle UTL_FILE.FILE_TYPE;
    file_location VARCHAR2(200) := 'FILES_FROM_SERVER';
    -- Назва створеної директорії
    file_name VARCHAR2(200) := 'TOTAL_PROJ_INDEX_ChernovIO.csv';
    -- Ім'я файлу, який буде записаний
    file_content VARCHAR2(4000);
-- Вміст файлу
    BEGIN
    -- Отримати вміст файлу з бази даних
    FOR cc IN (SELECT rp.project_name ||','|| dp.department_name ||','|| COUNT(DISTINCT dp.manager_id) ||','|| count(em.employee_id) ||','||  sum(em.salary) as file_content
                from hr.employees em
                inner join hr.departments dp
                on em.department_id = dp.department_id
                join igor.total_rep_project_dep_v2 rp
                on rp.department_id = dp.department_id
                group by rp.project_name, dp.department_name) LOOP
                file_content := file_content || cc.file_content||CHR(10);
    END LOOP;
    -- Відкрити файл для запису
    file_handle := UTL_FILE.FOPEN(file_location, file_name, 'W');
    -- Записати вміст файлу в файл на диск
    UTL_FILE.PUT_RAW(file_handle, UTL_RAW.CAST_TO_RAW(file_content));
    -- Закрити файл
    UTL_FILE.FCLOSE(file_handle);
    EXCEPTION
    WHEN OTHERS THEN
    -- Обробка помилок, якщо необхідно
    RAISE;
    END;
/



begin
  igor.write_file_to_disk;
end;
/

CREATE view  read_file_total_rep_project_dep_v2 as
SELECT ext_f2.project_name, ext_f2.department_name, ext_f2.count_manager_id, ext_f2.count_employee_id, ext_f2.sum_salary
FROM EXTERNAL ( 
(  
    project_name VARCHAR2(100),
    department_name VARCHAR2(100),
    count_manager_id NUMBER,
    count_employee_id NUMBER,
    sum_salary NUMBER
) TYPE oracle_loader DEFAULT DIRECTORY FILES_FROM_SERVER
-- вказуємо назву директорії в БД
ACCESS PARAMETERS ( records delimited BY newline nologfile nobadfile fields terminated BY ',' missing field VALUES are NULL ) LOCATION('TOTAL_PROJ_INDEX_ChernovIO.csv')
-- вказуємо назву файлу
REJECT LIMIT UNLIMITED
/*немає обмежень для відкидання рядків*/
) ext_f2;

select *from read_file_total_rep_project_dep_v2;






--

SELECT rp.project_name ||','|| dp.department_name ||','|| COUNT(DISTINCT dp.manager_id) ||','|| count(em.employee_id) ||','||  sum(em.salary) as file_content
from hr.employees em
inner join hr.departments dp
on em.department_id = dp.department_id
join igor.rep_project_dep_v rp
on rp.department_id = dp.department_id
group by rp.project_name, dp.department_name;



SELECT rp.project_name, dp.department_name, COUNT(DISTINCT dp.manager_id), count(em.employee_id),  sum(em.salary)
from hr.employees em
inner join hr.departments dp
on em.department_id = dp.department_id
join igor.rep_project_dep_v rp
on rp.department_id = dp.department_id
group by rp.project_name, dp.department_name;
