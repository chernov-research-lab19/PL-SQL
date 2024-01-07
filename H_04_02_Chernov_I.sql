/*2. Опис:
Доробити існуючу процедуру util.del_jobs через використання EXCEPTION-нів.
Деталі:
Шматок коду з DELETE обернути в
BEGIN
..
EXCEPTION
..
END. 
Оголосити змінну v_delete_no_data_found типу даних EXCEPTION.

Відразу після виконання DELETE, зробити якщо SQL%ROWCOUNT = 0 тоді запускати RAISE v_delete_no_data_found. 
В блоці EXCEPTION написати якщо наступила наша користувацька помилка v_delete_no_data_found, тоді генерувати помилку (через
raise_application_error) "Посада <p_job_id> не існує" (код помилки -20004).

В конструкції через EXCEPTION, нам НЕ потрібна змінна v_is_exist_job та SELECT INTO, де ми записуємо в цю змінну кількість. 
Також в підсумку НЕ потрібен IF..ELSE де ми шось шукали в змінній v_is_exist_job.

Тобто все НЕ потрібне треба прибрати.
В піддсумку, якщо посада видалена успішно, залишити як і було запис тексту "Посада <p_job_id> успішно видалена" у вихідний параметр po_result.

Також перед блоком з видаленням посади, з початку треба перевірити чи робочий сьогодні день. Це зробити просто за допомогою виклику процедури
check_work_time.
Зберегти код доробленої оголошеної функції у файл під назвою H_04_02_tvoji_inichialy.sql. Загрузити в LMS Moodle.*/


CREATE OR REPLACE PACKAGE  UTIL AS PROCEDURE DEL_JOBS (P_JOB_ID IN VARCHAR2,
                                                        PO_RESULT OUT VARCHAR2);
END UTIL;

CREATE OR REPLACE PACKAGE BODY UTIL AS  PROCEDURE DEL_JOBS (P_JOB_ID IN VARCHAR2,
                                                            PO_RESULT OUT VARCHAR2) IS
v_delete_no_data_found EXCEPTION;

BEGIN
        --igor.util.check_work_time; --вызов процедуры чи робочий сьогодні день
        BEGIN
            DELETE FROM jobs j
            WHERE j.job_id =  P_JOB_ID; 
                   --COMMIT;
            
               
            IF SQL%ROWCOUNT = 0 THEN
               raise v_delete_no_data_found;
            else   
                PO_RESULT := 'Посада '||P_JOB_ID||' успішно видалена'; 
            END IF;
            
        EXCEPTION
            WHEN v_delete_no_data_found  THEN
                dbms_output.put_line('Посада ' ||P_JOB_ID|| ' не існує (код помилки -20004)');
        END;
        
END DEL_JOBS;
END UTIL;



CREATE PROCEDURE check_work_time IS
    BEGIN
        IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') IN ('SAT', 'SUN') THEN
            raise_application_error (-20205, 'Ви можете вносити зміни лише у робочі дні');
        END IF;
       
    END check_work_time;


DECLARE
v_err VARCHAR2(100);
BEGIN
    --igor.check_work_time; --вызов процедуры чи робочий сьогодні день
    util.DEL_JOBS (P_JOB_ID=> 'IT_QA3',
              PO_RESULT => v_err);
    dbms_output.put_line(v_err);
   -- commit; -- зафіксувати DML зміни
   -- rollback; -- скасувати DML зміни
END;
/



