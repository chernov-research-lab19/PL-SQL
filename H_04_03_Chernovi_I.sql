/*3. Опис:
На основі першого PL-SQL блоку з практики по темі "Динамічний SQL", написати функцію в пакеті util, яка б повертала суму зі схеми HR, з таблиці produ﻿cts або produ﻿cts_old.
Деталі:
Створити функцію util.get_sum_price_sales з одним вхідним параметром p_table
(цей параметр повинен працювати тільки із значеннями - produ﻿cts або produ﻿cts_old) 

- якщо передати в параметр p_table, будь-яке інше значення, яке відрізняється від produ﻿cts або produ﻿cts_old, 
тоді відразу генерувати помилку з текстом "неприпустиме значення! очікується produ﻿cts або produ﻿cts_old" (код помилки-20001). якщо перевірка пройшла, тоді функція повинна вивести суму по полю
price_sales з потрібної таблиці.
також, якщо перевірка не пройшла, перед викликом raise_application_error, викликати процедуру to_log для запису в лог про не успішний виклик функції.
в параметр p_message передати точно такий же текст як і в raise_application_error.
Зберегти код оголошеної функції у файл під назвою H_04_03_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/

CREATE OR REPLACE PACKAGE  UTIL AS function get_sum_price_sales (p_table IN VARCHAR2) RETURN number;
END UTIL;

CREATE OR REPLACE PACKAGE BODY UTIL AS  function get_sum_price_sales (p_table IN VARCHAR2) RETURN number IS 
    v_sum_price number;
    input_err EXCEPTION;
    v_dynamic_sql VARCHAR2(500);
    BEGIN
        BEGIN
            dbms_output.put_line(p_table);
            IF p_table <> 'products' /* or p_table <> 'products_old'*/ THEN
                RAISE input_err;
            END IF;
            ----
            v_dynamic_sql := 'SELECT SUM(pr.PRICE_SALES) FROM hr.' || p_table || ' pr';
            dbms_output.put_line(v_dynamic_sql);
            EXECUTE IMMEDIATE v_dynamic_sql INTO v_sum_price;
            RETURN v_sum_price;
        EXCEPTION
            WHEN input_err THEN
                    to_log(p_appl_proc => 'util.get_sum_price_sales', p_message => 'Неприпустиме значення! Очікується produ﻿cts або produ﻿cts_old');
                    raise_application_error(-20001, 'Неприпустиме значення! Очікується produ﻿cts або produ﻿cts_old');
        END;
    END get_sum_price_sales;
END UTIL;




CREATE PROCEDURE to_log(
    p_appl_proc IN VARCHAR2,
    p_message IN VARCHAR2) IS PRAGMA autonomous_transaction;
BEGIN
    INSERT INTO logs(id, appl_proc, message)
    VALUES(log_seq.NEXTVAL, p_appl_proc, p_message);
    COMMIT;
END;
/



-------

BEGIN
     dbms_output.put_line(util.get_sum_price_sales (p_table=> 'products1'));
END;
/


