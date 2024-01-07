/*3. Опис:

Зробити потрібний звіт і відправити його собі на пошту, знайшовши при цьому свою пошту в таблиці employees.
Деталі:
Зробити собі в схемі копію таблиці hr.employees та додати себе в цю таблицю, де в поле EMAIL треба
додати свій реальний логін від своєї пошти.
Далі зробити звіт про кількість працівників в розрізі департаменту. Результат цього звіту відправити поштою у виді таблиці, де буде два стовпчика - "Ід департаменту" 
та "Кількість співробітників". 
Відправник повинен автоматично вичитуватися з таблиці employees твоєї схеми де, по EMPLOYEE_ID треба знайти свій логін і далі при контактувати
свій домен пошти (наприклад @GMAIL.COM)
Зберегти PL-SQL блок у файл під назвою H_05_03_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/



create table employees2 as
select *
from hr.employees em;


insert into igor.employees2
select 208, 'Igor', 'Chernov', 'ic1882377@gmail.com', '222.336.3332', trunc(sysdate,'dd'), 'IT_DB', 10000, null, 124, 80
from dual;
commit; -- зафіксувати DML зміни
rollback; -- скасувати DML зміни

select * from employees2 em;

select em.email
from employees2 em
where em.EMPLOYEE_ID=208;




DECLARE
 -- v_recipient VARCHAR2(50) := 'ic1882377@gmail.com';
  v_subject   VARCHAR2(50) := 'test_subject';
  v_mes       VARCHAR2(5000) := 'Вітаю шановний! </br> Ось звіт з нашої компанії: </br></br>';
  v_dynamic_sql VARCHAR2(500);
  v_email VARCHAR2(50);
BEGIN

    v_dynamic_sql := 'select em.email from employees2 em where em.EMPLOYEE_ID=206';
   -- dbms_output.put_line(v_dynamic_sql);
    EXECUTE IMMEDIATE v_dynamic_sql INTO v_email;
    
  SELECT v_mes || '<!DOCTYPE html>
    <html>
    <head>
    <title></title>
    <style>
    table, th, td {border: 1px solid;}
    .center{text-align: center;}
    </style>
    </head>
    <body>
    <table border=1 cellspacing=0 cellpadding=2 rules=GROUPS frame=HSIDES>
    <thead>
    <tr align=left>
    <th>Ід департаменту</th>
    <th>Кількість співробітників</th>
    </tr>
    </thead>
    <tbody>
    ' || list_html || '
    </tbody>
    </table>
    </body>
    </html>' AS html_table
    INTO v_mes
    FROM (
    SELECT LISTAGG('<tr align=left>
                        <td>' || department_id || '</td>' || '
                        <td class=''center''> ' || employee_count||'</td>
                    </tr>', '<tr>')
        WITHIN GROUP(ORDER BY employee_count) AS list_html
    FROM ( SELECT department_id, count(employee_id) AS employee_count
            FROM employees
            WHERE department_id is not null
            GROUP BY department_id
            ORDER BY department_id -- ne rabotaet
            ));
  v_mes := v_mes || '</br></br> З повагою, Igor';
  sys.sendmail(p_recipient => v_email, p_subject   => v_subject, p_message   => v_mes || ' ');
END;
/







