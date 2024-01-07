/*Опис:
Створити PL-SQL блок, який по department_id=80 виводить імʼя та прізвище, через крапку з комою виводить прибавку до зарплати 
і через крапку з комою опис процента(мінімальний, середній або максимальний). 
Для прикладу, повинно вийти так: "Співробітник - Ellen Abel; процент до зарплати - 30%; опис процента - середній"

Деталі: Завести змінну v_def_percent типу даних VARCHAR2(30) та змінну v_percent типу даних VARCHAR2(5). 

В середині PL-SQL блоку, через цикл FOR обробити кожен рядок з таблиці співробітників (зробити сортування по імені) з департаменту 80
таким чином:
В селекті створити стовпчик percent_of_salary (це буде прибавка до зарплати), по такій формулі - commission_pct*100

В селекті створити обʼєднаний стовпчик emp_name - first_name + last_name 

Далі в середині LOOP зробити перше розгалуження через IF, таким чином:
Якщо manager_id = 100, тоді вивести текст в такому форматі - "Співробітник - < emp_name>, процент до зарплати на зараз заборонений", 
та завершити поточну ітерацію 

Зробити друге розгалуження через IF, таким чином: 
Якщо percent_of_salary в інтервалі між 10 та 20, тоді змінній v_def_percent присвоїти значення "мінімальний"
Якщо percent_of_salary в інтервалі між 25 та 30, тоді змінній v_def_percent присвоїти значення "середній"
Якщо percent_of_salary в інтервалі між 35 та 40, тоді змінній v_def_percent присвоїти значення "максимальний"
Змінній v_percent присвоїти значення, по такій формулі - CONCAT(percent_of_salary, '%')
Вивести текст в такому форматі: "Співробітник - <emp_name>; процент до зарплати - <v_percent>; опис процента - <v_def_percent>".

Зберегти PL-SQL блок у файл під назвою H_02_02_tvoji_inichialy.sql. Загрузити в LMS Moodle.
*/

DECLARE
    v_def_percent  VARCHAR2(30);
    v_percent VARCHAR2(5);

BEGIN
FOR cc IN (SELECT em.first_name || ' ' || em.last_name as emp_name, em.commission_pct*100 as percent_of_salary, em.manager_id FROM hr.employees em
    WHERE em.department_id = 80
    ORDER BY em.first_name)LOOP
    
    IF cc.manager_id = 100 THEN
        dbms_output.put_line('Співробітник - '|| cc.emp_name ||', процент до зарплати на зараз заборонений');
        CONTINUE;
    END IF;
    
    IF  cc.percent_of_salary BETWEEN 10 and 20 THEN
        v_def_percent:= 'мінімальний';
        ELSIF  cc.percent_of_salary BETWEEN 25 and 30 THEN
            v_def_percent:= 'середній';
        ELSIF  cc.percent_of_salary BETWEEN 35 and 40 THEN
            v_def_percent:= 'максимальний';
    END IF;
    
    v_percent:= CONCAT(cc.percent_of_salary, '%');
    dbms_output.put_line('Співробітник - '|| cc.emp_name ||', процент до зарплати - '|| v_percent|| ' опис процента - '|| v_def_percent);
END LOOP;
END;
/
