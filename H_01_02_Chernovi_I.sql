/*2
Опис:
Створити PL-SQL блок, який в залежності від дати, показує нам чи буде сьогодні виплата зарплати, авансу або взагалі треба ще почекати.

Деталі:
Допустимо виплата зарплати у нас в останній день кожного місяця, а виплата авансу кожного 15-го числа. 

Заведіть змінну v_date типу date і відразу присвойте цій змінній якусь дату (наприклад TO_DATE('30.04.2023', 'DD.MM.YYYY')).
Також заведіть змінну v_day типу number. 
Далі в середині блоку, змінній v_day присвойте значення по формулі - to_number(to_char(v_date, 'dd')). 
Далі по коду, зробіть розгалуження через оператора IF, і якщо змінна v_date дорівнює останньому дню в місяці (last_day(trunc(SYSDATE))), 
то виведіть текст "Виплата зарплати", якщо змінна v_day дорівнює 15, то виведіть текст "Виплата авансу", 
якщо змінна v_day меньша за 15, то виведіть текст "Чекаємо на аванс", а якщо змінна v_day більша за 15, то виведіть текст "Чекаємо на зарплату". Блок інакше нам не потрібен. Перевірте як працює ваш PL-SQL блок з різною датою в змінній v_date.

Зберегти PL-SQL блок у файл під назвою H_01_02_tvoji_inichialy.sql. Загрузити в LMS Moodle.

TO_DATE('31.07.2023', 'DD.MM.YYYY');
*/

SET SERVEROUTPUT ON

DECLARE
v_date date:= SYSDATE;
v_day number;

BEGIN
dbms_output.put_line('v_date=' || v_date);
v_day:= to_number(to_char(v_date, 'dd'));
dbms_output.put_line('v_day=' || v_day);

IF v_date = last_day(trunc(SYSDATE))  THEN
dbms_output.put_line(v_day || ' - Виплата зарплати');
ElSIF v_day = 15 THEN
dbms_output.put_line(v_day || ' - Виплата авансу');
ElSIF v_day < 15 THEN
dbms_output.put_line(v_day || ' - Чекаємо на аванс');
ElSIF v_day > 15 THEN
dbms_output.put_line(v_day || ' - Чекаємо на зарплату');
END IF;
END;
/