/*1. Опис:
Створити окрему процедуру перевірки робочих днів. Для використання її в потрібних місцях, щоб не дублювати код.
Деталі:
Створити окрему процедуру (без вхідних чи вихідних параметрів) в check_work_time, взяти готовий код з процедури util.add_new_jobs.
Тобто, при виклику процедури, повинно перевірятися який сьогодні день, і якщо сьогодні субота або неділя процедура повинна генерувати код помилки -20205 та текст помилки
"Ви можете вносити зміни лише у робочі дні". 
Процедуру check_work_time помістити тільки вbody пакета util.

В процедурі util.add_new_jobs викорастити процедуру check_work_time
замість коду який був на місці перевірки робочих днів.
Зберегти код для оголошення процедури check_work_time в пакеті util, у файл під назвою H_04_01_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/

CREATE OR REPLACE PACKAGE  util AS PROCEDURE check_work_time;
END util;

CREATE OR REPLACE PACKAGE BODY util AS  PROCEDURE check_work_time IS
    BEGIN
        IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') IN ('SAT', 'SUN') THEN
            raise_application_error (-20205, 'Ви можете вносити зміни лише у робочі дні');
        END IF;
       
    END check_work_time;
END util;



create or replace PROCEDURE add_new_jobs(p_job_id IN VARCHAR2,
                       p_job_title IN VARCHAR2,
                       p_min_salary IN VARCHAR2,
                       p_max_salary IN NUMBER DEFAULT NULL,
                       po_err OUT VARCHAR2) IS
    v_max_salary jobs.max_salarY%TYPE;
    salary_err EXCEPTION;
    BEGIN
        /*IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') IN ('SAT', 'SUN') THEN
            raise_application_error (-20205, 'Ви можете вносити зміни лише у робочі дні');
        END IF;*/
        
        igor.util.check_work_time; --вызов процедуры
        
        IF p_max_salary IS NULL THEN
            v_max_salary := p_min_salary * 1.3;--c_percent_of_min_salary;
        ELSE
            v_max_salary := p_max_salary;
        END IF;
        BEGIN
            IF (p_min_salary < 2000 OR p_max_salary < 2000) THEN
                RAISE salary_err;
            END IF;
            INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
            VALUES (p_job_id, p_job_title, p_min_salary, v_max_salary);
            po_err := 'Посада '||p_job_id||' успішно додана';
        EXCEPTION
            WHEN salary_err THEN
                raise_application_error(-20001, 'Передана зарплата менша за 2000');
            WHEN dup_val_on_index THEN
                raise_application_error(-20002, 'Посада '||p_job_id||' вже існує');
            WHEN OTHERS THEN
                raise_application_error(-20003, 'Виникла помилка при додаванні нової посади. '|| SQLERRM);
    END;
    --COMMIT;
END add_new_jobs;


DECLARE
v_err VARCHAR2(100);
BEGIN
add_new_jobs(p_job_id=> 'IT_QA',
              p_job_title=> 'QA Engineer',
              p_min_salary => 3000,
              p_max_salary => 10000,
              po_err => v_err);
dbms_output.put_line(v_err);
commit; -- зафіксувати DML зміни
END;

