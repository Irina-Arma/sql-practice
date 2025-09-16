/*
Примеры использования агрегатных функций SQL (SUM, COUNT, COUNT DISTINCT, MIN, MAX, AVG, ROUND)
и группировки (GROUP BY, HAVING, DISTINCT) для анализа таблицы book:
подсчёт количества, стоимости, цен, уникальных авторов и книг, фильтрация по условиям и сортировка
*/


--Операторы DROP и EXISTS
--Сбросить таблицу и пересоздать заново
DROP TABLE IF EXISTS book;
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8,2),
    amount INT
);
INSERT INTO book (title, author, price, amount)
VALUES
    ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3),
    ('Белая гвардия', 'Булгаков М.А.', 540.50, 5),
    ('Идиот', 'Достоевский Ф.М.	', 460.00, 10),
    ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 3),
    ('Игрок', 'Достоевский Ф.М.', 480.50, 10),
    ('Стихотворения и поэмы', 'Есенин С.А.', 650.00, 15);
SELECT * FROM book;


--Операторы DISTINCT и GROUP BY
--Выбрать уникальных авторов из таблицы book (без дубликатов)
SELECT DISTINCT author
FROM book;
--Другой способ через GROUP BY
SELECT  author
FROM book
GROUP BY author;


--Уникальные значения количества книг из таблицы book
SELECT DISTINCT amount
FROM book;


--Функция SUM и COUNT
--Группировка по авторам: общее количество экземпляров книг каждого автора и
--сколько записей (строк) относится к группе (автору)
SELECT author,
        SUM(amount),
        COUNT(amount)
FROM book
GROUP BY author;


--Группировка по авторам: подсчёт общего количества книг у каждого автора
SELECT author,
        SUM(amount) AS total_amount
FROM book
GROUP BY author;


--Подсчёт количества различных книг и общего числа экземпляров для каждого автора
--COUNT(DISTINCT title) точно считает уникальные названия книг, даже если есть дубликаты
SELECT author AS Автор,
        COUNT(DISTINCT title) AS Различных_книг,
        SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY author;


--Функции MIN, MAX и AVG
--Подсчёт минимальной, максимальной и средней цены книг для каждого автора
SELECT author AS Автор,
       MIN(price) AS Минимальная_цена,
       MAX(price) AS Максимальная_цена,
       AVG(price) AS Средняя_цена
FROM book
GROUP BY author;


--Подсчёт общей стоимости всех экземпляров книг каждого автора
SELECT author,
    SUM(price * amount) AS Стоимость
FROM book
GROUP BY author;


--Функция ROUND
--Найти среднюю цену книг каждого автора и округлить до 2 знаков после запятой
SELECT author,
    ROUND(AVG(price),2) AS Средняя_цена
FROM book
GROUP BY author;


--Суммарная стоимость книг каждого автора, расчет НДС (18%) и стоимости без НДС
SELECT author,
    ROUND(SUM(price * amount), 2) AS Стоимость,
    ROUND((SUM(price * amount) * 18 / 100) / (1 + 18.0 / 100), 2) AS НДС,
    ROUND(SUM(price * amount) / (1 + 18.0 / 100), 2) AS Стоимость_без_НДС
FROM book
GROUP BY author;


--Посчитать общее количество экземпляров книг на складе и их стоимость
SELECT  SUM(amount) AS Количество,
        SUM(price * amount) AS Стоимость
FROM book;


--Находит минимальную, максимальную и среднюю цену всех книг на складе.
--Средняя цена округляется до двух знаков после запятой.
SELECT
    MIN(price) AS Минимальная_цена,
    MAX(price) AS Максимальная_цена,
        ROUND(AVG(price),2) AS Средняя_цена
FROM book;


--Найти минимальную и максимальную цену книг всех авторов, общая стоимость книг которых больше 5000.
--Результат вывести по убыванию минимальной цены.
SELECT author,
    MIN(price) AS Минимальная_цена,
    MAX(price) AS Максимальная_цена
FROM book
GROUP BY author
    HAVING SUM(price * amount) > 5000
ORDER BY Минимальная_цена DESC;


--Считаем среднюю цену одной книги и общую стоимость всех книг,
--где количество экземпляров от 5 до 14 включительно
SELECT
    ROUND(AVG(price),2) AS Средняя_цена,
    ROUND(SUM(price * amount), 2) AS Стоимость
FROM book
WHERE amount >= 5 AND amount <= 14;


--Оператор HAVING
--Считаем общую стоимость книг каждого автора,
--исключая книги «Идиот» и «Белая гвардия», только для авторов с суммой > 5000, сортируем по убыванию
SELECT author,
    SUM(amount * price) AS Стоимость
FROM book
WHERE title NOT IN ("Идиот", "Белая гвардия")
GROUP BY author
HAVING SUM(price * amount) > 5000
ORDER BY Стоимость DESC;
