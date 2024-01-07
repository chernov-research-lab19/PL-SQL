/*
Опис:
Створити процедуру для видалення конкретної посад з таблиці JOBS, яка у власній схемі.
Деталі:
Створити процедуру під назвою DEL_JOBS, з двома параметрами, вхідний - P_JOB_ID, та вихідний параметр - PO_RESULT. 
Процедура повинна перевірити існування посади, щопередається в параметрі P_JOB_ID, якщо посади немає, 
то записуємо текст у вихідний параметр PO_RESULT= "Посада <p_job_id> не існує" 

і зупиняємо подальші дії, а інакше видаляємо посаду з таблиці JOBS із значенням з вхідного параметра P_JOB_ID та 
записуємо текст у вихідний параметр PO_RESULT = "Посада <p_job_id> успішно видалена".
Зберегти код для створення процедури у файл під назвою H_03_01_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/

create or replace PROCEDURE DEL_JOBS  (P_JOB_ID IN VARCHAR2,
                                       PO_RESULT OUT VARCHAR2) IS v_is_exist_job NUMBER;
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
/


DECLARE
v_err VARCHAR2(100);
BEGIN
    DEL_JOBS (P_JOB_ID=> 'IT_QA3',
              PO_RESULT => v_err);
    dbms_output.put_line(v_err);
   -- commit; -- зафіксувати DML зміни
   -- rollback; -- скасувати DML зміни
END;
/