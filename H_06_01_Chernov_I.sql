/*Опис:
Зробити механізм який буде оновлювати кожний день в БД, Український індекс міжбанківських ставок овернайт. 
Деталі:
Для того щоб побачити Український індекс міжбанківських ставок овернайт, використовуємо API від НБУ:
https://bank.gov.ua/NBU_uonia?id_api=UONIA_UnsecLoansDepo&json
Далі створюємо таблиці interbank_index_ua_history
в БД під структуру відповіді JSON структури. 

Створюємо view interbank_index_ua_v на основі виклику API через функцію SYS.GET_NBU.
View interbank_index_ua_v повинна відразу парсити JSON структуру в окремі стовпчики зпотрібним типом даних. 

Далі створюємо процедуру download_ibank_index_ua, яка повинна вставляти дані з view interbank_index_ua_v
в таблицю interbank_index_ua_history.

Процедуру download_ibank_index_ua ставимо на шедулер з інтервалом кожен день в 9 ранку                            task_tax_overnight
Зберегти код створення всіх обʼєктів, у файл під назвою H_06_01_tvoji_inichialy.sql. Загрузити в LMS Moodle.*/


--SET DEFINE OFF; -- один раз запустити
SELECT SYS.GET_NBU(p_url => 'https://bank.gov.ua/NBU_uonia?id_api=UONIA_UnsecLoansDepo&json') AS res
FROM dual;


CREATE TABLE interbank_index_ua_history (   dt DATE,
                                            id_api VARCHAR2(100),
                                            value NUMBER,
                                            special VARCHAR2(1)
                                        );

CREATE view  interbank_index_ua_v as
SELECT TO_DATE(tt.dt, 'dd.mm.yyyy') as dt, tt.id_api, tt.value, tt.special
FROM (SELECT sys.get_nbu(p_url => 'bank.gov.ua/NBU_uonia?id_api=UONIA_UnsecLoansDepo&json') AS json_value FROM dual)
CROSS JOIN json_table
(
    json_value, '$[*]'
    COLUMNS
    (
            dt VARCHAR2(25) PATH '$.dt',
            id_api VARCHAR2(100) PATH '$.id_api',
            value NUMBER PATH '$.value',
            special VARCHAR2(1) PATH '$.special'
    )
) tt;

select * from interbank_index_ua_v;


CREATE OR REPLACE PROCEDURE download_ibank_index_ua IS
BEGIN
    INSERT INTO interbank_index_ua_history (dt, id_api, value, special)
    select * from interbank_index_ua_v;
    COMMIT;
END download_ibank_index_ua;
/


begin
  igor.download_ibank_index_ua;
end;
/
 -- check 
select * from interbank_index_ua_history;
truncate table interbank_index_ua_history;


BEGIN
    sys.dbms_scheduler.create_job(job_name => 'task_tax_overnight',
    job_type => 'PLSQL_BLOCK',
    job_action => 'begin download_ibank_index_ua; end;',
    start_date => SYSDATE,
    repeat_interval => 'FREQ=DAILY;BYHOUR=9;BYMINUTE=00',
    end_date => TO_DATE(NULL),
    job_class => 'DEFAULT_JOB_CLASS',
    enabled => TRUE,
    auto_drop => FALSE,
    comments => 'Оновлення кожний день в БД, Український індекс міжбанківських ставок овернайт');
END;
/


BEGIN
    DBMS_SCHEDULER.RUN_JOB(job_name => 'task_tax_overnight');
END;
/