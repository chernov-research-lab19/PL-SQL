/*
Опис: Видалити потрібні обʼєкти з корня своєї схеми та перед цим перенести їх в пакет UTIL.
Деталі:
Оголосити функції get_job_﻿title, get_dep_name та процедуру del_jobs в спеціфікації та тіла пакета UTIL.
Потім ці 3 обʼєкта які оголосили в пакеті - видалити в корні своєї схеми.
Докласти виклик процедури та функції (які вже в пакеті) із домашнього завдання.

Зберегти код оголошення та виклик функції і процедури у файл під назвою H_03_03_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/

create or replace PACKAGE util AS
    FUNCTION get_job_title(p_employee_id IN NUMBER) RETURN VARCHAR;
    FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR;
    PROCEDURE DEL_JOBS(P_JOB_ID IN VARCHAR2, PO_RESULT OUT VARCHAR2);
END util;

create or replace PACKAGE BODY util AS 
    FUNCTION get_job_title(p_employee_id IN NUMBER) RETURN VARCHAR IS v_job_title jobs.job_title%TYPE;
        BEGIN
        SELECT j.job_title
        INTO v_job_title
        FROM employees em
        JOIN jobs j
        ON em.job_id = j.job_id
        WHERE em.employee_id = p_employee_id;
        RETURN v_job_title;
    END get_job_title;
    ----------
    FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR IS v_dp_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    BEGIN
        SELECT dp.department_name
        INTO v_dp_name
        FROM DEPARTMENTS dp
        JOIN employees em
        ON em.department_id = dp.department_id
        WHERE em.employee_id = p_employee_id;
        RETURN v_dp_name;
    END get_dep_name;
    ----------
    PROCEDURE DEL_JOBS(P_JOB_ID IN VARCHAR2, PO_RESULT OUT VARCHAR2) IS v_is_exist_job NUMBER;
    BEGIN
        SELECT COUNT(j.job_id) INTO v_is_exist_job
        FROM igor.jobs j
        WHERE j.job_id = P_JOB_ID;
        IF (v_is_exist_job < 1) THEN
            PO_RESULT := 'Посада '||P_JOB_ID||' не існує';
            RETURN;
        ELSE
           DELETE FROM igor.jobs j
           WHERE j.job_id =  P_JOB_ID; 
           --COMMIT;
           PO_RESULT := 'Посада '||P_JOB_ID||' успішно видалена';
        END IF;
    END DEL_JOBS;
    -----------
END util;
/***************************/



------- запуск пакетов
---Приклад виклику функції add﻿_years, яказнаходиться в пакеті util через SQL:
SELECT em.employee_id,
        em.first_name,
        em.last_name,
        em.job_id,
        igor.util.get_job_title(p_employee_id => em.employee_id) as job_title,
        igor.util.get_dep_name(p_employee_id => em.employee_id) as dep_name
FROM employees em;


---не запкускается процедура
DECLARE
v_err VARCHAR2(100);
BEGIN
    util.DEL_JOBS (P_JOB_ID=> 'IT_QA3',
              PO_RESULT => v_err);
    dbms_output.put_line(v_err);
   -- commit; -- зафіксувати DML зміни
   -- rollback; -- скасувати DML зміни
END;
/
