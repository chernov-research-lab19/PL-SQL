/*1. Опис:
Створіть тригер, який автоматично оновлює поле EMPLOYEES.HIRE_DATE.
Деталі:
Створіть тригер (подія - BEFORE UPDATE) hire_date_update, який автоматично оновлює поле "HIRE_DATE" в таблиці "EMPLOYEES", якщо значення поля "JOB_ID" змінюється (
:OLD.job_id !=:NEW.job_id). 
Нове значення "HIRE_DATE" має бути поточною датою усічене до дня.
Для зміни старого значення в полі "HIRE_DATE" НЕ вийди використовувати звичайний UPDATE, тому, що буде помилка "
ORA-00060: deadlock detected while waiting for resource " і це нормально поведінка транзакційної БД, так як ми одночасно пробуємо змінити значення в однійтаблиці в двох різних стовпчиках.
Для зміни старого значення в полі "HIRE_DATE треба використовувати функціонал тригера, через присвоєння новому значенню, ось так -
:NEW.hire_date := TRUNC(SYSDATE).
Перевірити роботу тригера.
Зберегти код створення тригера, у файл під назвою H_05_01_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/
CREATE OR REPLACE TRIGGER hire_date_update
BEFORE UPDATE ON employees
FOR EACH ROW
DECLARE
PRAGMA autonomous_transaction;
BEGIN
IF :OLD.job_id != :NEW.job_id THEN
    :NEW.hire_date := TRUNC(SYSDATE);
END IF;
COMMIT;
END hire_date_update;
/

select * from employees em;

ROLLBACK;

UPDATE employees em
SET em.hire_date = TRUNC(SYSDATE);