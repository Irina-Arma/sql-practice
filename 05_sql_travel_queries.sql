/*

*/


--Тип данных DATE
--Создание и наполнение новой таблицы trip
CREATE TABLE trip (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    city VARCHAR(25),
    per_diem DECIMAL(8,2),
    date_first DATE,
    date_last DATE
);
INSERT INTO trip (name, city, per_diem, date_first, date_last) VALUES
("Баранов П.Е.", "Москва", 700, "2020-01-12", "2020-01-17"),
("Абрамова К.А.", "Владивосток", 450, "2020-01-14", "2020-01-27"),
("Семенов И.В.", "Москва", 700, "2020-01-23", "2020-01-31"),
("Ильиных Г.Р.", "Владивосток", 450, "2020-01-12", "2020-02-02"),
("Колесов С.П.", "Москва", 700, "2020-02-01", "2020-02-06"),
("Баранов П.Е.", "Москва", 700, "2020-02-14", "2020-02-22"),
("Абрамова К.А.", "Москва", 700, "2020-02-23", "2020-03-01"),
("Лебедев Т.К.", "Москва", 700, "2020-03-03", "2020-03-06"),
("Колесов С.П.", "Новосибирск", 450, "2020-02-27", "2020-03-12"),
("Семенов И.В.", "Санкт-Петербург", 700, "2020-03-29", "2020-04-05"),
("Абрамова К.А.", "Москва", 700, "2020-04-06", "2020-04-14"),
("Баранов П.Е.", "Новосибирск", 450, "2020-04-18", "2020-05-04"),
("Лебедев Т.К.", "Томск", 450, "2020-05-20", "2020-05-31"),
("Семенов И.В.", "Санкт-Петербург", 700, "2020-06-01", "2020-06-03"),
("Абрамова К.А.", "Санкт-Петербург", 700, "2020-05-28", "2020-06-04"),
("Федорова А.Ю.", "Новосибирск", 450, "2020-05-25", "2020-06-04"),
("Колесов С.П.", "Новосибирск", 450, "2020-06-03", "2020-06-12"),
("Федорова А.Ю.", "Томск", 450, "2020-06-20", "2020-06-26"),
("Абрамова К.А.", "Владивосток", 450, "2020-07-02", "2020-07-13"),
("Баранов П.Е.", "Воронеж", 450, "2020-07-19", "2020-07-25");
SELECT * FROM trip;


--Выбор командировок сотрудников, фамилия которых оканчивается на "а",
--сортировка по убыванию даты последнего дня командировки
SELECT name, city, per_diem, date_first, date_last
FROM trip
WHERE name LIKE '%а %'
ORDER BY date_last DESC;
SELECT * FROM trip;


--Выборка уникальных сотрудников, побывавших в Москве, в алфавитном порядке
SELECT DISTINCT name
FROM trip
WHERE city = "Москва"
ORDER BY name;


--Подсчёт количества поездок в каждом городе, сортировка по алфавиту
SELECT city, COUNT(city) as 'Количество'
FROM trip
GROUP BY city
ORDER BY city;


--Оператор LIMIT
--Вывести информацию о первой командировке из таблицы trip
--"Первой" считать командировку с самой ранней датой начала
SELECT * FROM trip
ORDER BY  date_first
LIMIT 1;


--Два города с наибольшим числом командировок сотрудников
SELECT city, COUNT(city) as 'Количество'
FROM trip
GROUP BY city
ORDER BY Количество DESC
LIMIT 2;


--Функция DATEDIFF
--Выбор командировок в города кроме Москвы и СПб с длительностью в днях,
--сортировка по самой длинной командировке и городам в обратном алфавитном порядке
SELECT name, city, DATEDIFF(date_last, date_first)+1 AS 'Длительность'
FROM trip
WHERE city NOT IN ('Москва', 'Санкт-Петербург')
ORDER BY Длительность DESC, city DESC;


--Командировки с минимальной длительностью среди всех поездок
SELECT name, city, date_first, date_last
FROM trip
WHERE (DATEDIFF(date_last, date_first)) = (SELECT MIN(DATEDIFF(date_last, date_first)) FROM trip);


--Функция MONTH(дата)
--Выбираем командировки, где дата начала и конца в одном месяце (год не учитывается)
SELECT name, city, date_first, date_last
FROM trip
WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city ASC, name ASC;


--Функция MONTHNAME(дата)
--Счёт командировок по месяцам начала с сортировкой по убыванию количества и по алфавиту месяца
SELECT MONTHNAME(date_first) AS Месяц,
COUNT(date_first) AS Количество
FROM trip
GROUP BY MONTHNAME(date_first)
ORDER BY Количество DESC, Месяц ASC;


--Функции MONTH(дата) и YEAR(дата)
--Сумма суточных за командировки, начавшиеся в феврале или марте 2020, сортировка по фамилии и убыванию суммы
SELECT name, city, date_first,
(DATEDIFF(date_last, date_first)+1)*per_diem AS Сумма
FROM trip
WHERE YEAR (date_first) = 2020 AND (MONTH(date_first) = 2 OR MONTH(date_first) = 3)
ORDER BY name ASC, Сумма DESC;


-- Общая сумма суточных сотрудников с более чем 3 командировками, сортировка по убыванию суммы
SELECT name, SUM ((DATEDIFF(date_last, date_first)+1)*per_diem) AS Сумма
FROM trip
GROUP BY name
HAVING COUNT(name) > 3
ORDER BY Сумма DESC;
