/*
Создание и заполнение таблицы штрафов, корректировка сумм (удвоение/уменьшение),
работа с алиасами, выборка неоплаченных и удаление по дате.
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
