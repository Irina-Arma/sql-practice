/*
Создание таблиц fine и traffic_violation, вставка данных с использованием CREATE TABLE и INSERT INTO.
Используются функции IF для условной проверки, DATEDIFF для вычисления количества дней между датами,
а также агрегатная функция COUNT с GROUP BY и HAVING для поиска повторных нарушений.
Применяются операторы UPDATE для изменения данных, SELECT с JOIN и псевдонимами таблиц (AS),
а также DELETE для удаления записей по условию.
*/


--Создание таблицы fine - штрафы за нарушение ПДД
CREATE TABLE fine (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8,2),
    date_violation DATE,
    date_payment DATE
);
INSERT INTO fine (name, number_plate, violation, sum_fine, date_violation, date_payment) VALUES
('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', 500.00, '2020-01-12', '2020-01-17'),
('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', 1000.00, '2020-01-14', '2020-02-27'),
('Яковлев Г.Р.', 'Т330ТТ', 'Превышение скорости(от 20 до 40)', 500.00, '2020-01-23', '2020-02-23'),
('Яковлев Г.Р.', 'М701АА', 'Превышение скорости(от 20 до 40)', NULL, '2020-01-12', NULL),
('Колесов С.П.', 'К892АХ', 'Превышение скорости(от 20 до 40)', NULL, '2020-02-01', NULL),
('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', NULL, '2020-02-14', NULL),
('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', NULL, '2020-02-23', NULL),
('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', NULL, '2020-03-03', NULL);
SELECT * FROM fine;

--Создание таблицы traffic_violation - нарушения ПДД и соответствующие штрафы
CREATE TABLE traffic_violation (
    violation_id INT PRIMARY KEY AUTO_INCREMENT,
    violation VARCHAR(50),
    sum_fine DECIMAL(8,2)
);
INSERT INTO traffic_violation (violation, sum_fine) VALUES
('Превышение скорости(от 20 до 40)', 500.00),
('Превышение скорости(от 40 до 60)', 1000.00),
('Проезд на запрещающий сигнал', 1000.00);
SELECT * FROM traffic_violation;


--Временное название (алиас) для таблицы
--Для тех, кто уже оплатил штраф, вывести информацию о том, изменялась ли стандартная сумма штрафа
SELECT  f.name, f.number_plate, f.violation,
    if(f.sum_fine = tv.sum_fine, "Стандартная сумма штрафа",
            if(f.sum_fine < tv.sum_fine, "Уменьшенная сумма штрафа", "Увеличенная сумма штрафа")
      ) AS description
FROM  fine AS f, traffic_violation AS tv
WHERE tv.violation = f.violation and f.sum_fine IS NOT Null;


--Заполняем пустые суммы штрафов в таблице fine значениями
--из таблицы traffic_violation по совпадающим нарушениям
UPDATE fine AS f, traffic_violation AS tv
SET f.sum_fine = tv.sum_fine
WHERE f.violation = tv.violation AND f.sum_fine IS NULL;


--Группировка данных по нескольким столбцам
--Водители, которые на одной машине нарушили одно и то же правило два и более раз,
--сортировка по имени, номеру машины и нарушению
SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING count(*) > 1
ORDER BY name ASC, number_plate ASC, violation ASC;


--Увеличение суммы неоплаченных повторных штрафов в 2 раза
--для водителей с одинаковым нарушением на одной машине
UPDATE fine,
        (SELECT name, number_plate, violation
        FROM fine
        GROUP BY name, number_plate, violation
        HAVING count(*) > 1) AS query_in
SET sum_fine = sum_fine*2
WHERE   fine.date_payment IS NULL
        AND fine.name = query_in.name
        AND fine.number_plate = query_in.number_plate
        AND fine.violation = query_in.violation;


--Обновляем fine: ставим дату оплаты из таблицы payment и
--уменьшаем штраф вдвое, если оплата была не позднее 20 дней после нарушения
UPDATE fine f, payment p
SET     f.date_payment=p.date_payment,
        f.sum_fine = IF(DATEDIFF(p.date_payment, p.date_violation)<=20, f.sum_fine/2, f.sum_fine)
WHERE   f.date_payment IS NULL
        AND f.name = p.name
        AND f.number_plate = p.number_plate
        AND f.violation = p.violation;


--Создаём таблицу back_payment с информацией о неоплаченных штрафах из fine
CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine WHERE date_payment IS NULL;


--Удаляем из fine все нарушения, совершённые до 1 февраля 2020 года
DELETE FROM fine
WHERE date_violation < '2020-02-01';
