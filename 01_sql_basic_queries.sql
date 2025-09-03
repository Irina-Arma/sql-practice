/*
SQL-файл демонстрирует работу с таблицей book: создание таблицы и вставка данных.
Используются SELECT, WHERE, ORDER BY, BETWEEN, IN для фильтрации и сортировки.
Вычисляемые поля с арифметикой и ROUND, условные выражения IF (MySQL) и CASE (SQLite),
псевдонимы колонок через AS.
*/


--Создание таблицы book, в которой будут храниться данные о книгах
CREATE TABLE book (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);


--Добавление 1 новой строки
INSERT INTO
    book (title, author, price, amount)
VALUES
    ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);

INSERT INTO
    book (title, author, price, amount)
VALUES
    ('Стихотворения и поэмы', 'Есенин С.А.', 650.00, 15);


--Добавление 3 новых строк
INSERT INTO book (title, author, price, amount)
VALUES
    ('Белая гвардия', 'Булгаков М.А.', 540.50 , 5),
    ('Идиот', 'Достоевский Ф.М.', 460, 10),
    ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);


--Вывод всех записей из таблицы book
SELECT * FROM book;


--Выборка отдельных столбцов (например: автор, название, цена)
SELECT author, title, price FROM book;


--Присвоение новых имен столбцам при формировании выборки (title и author на Название и Автор)
SELECT title AS 'Название',
author AS 'Автор'
FROM book;


--Выборка книг с общей стоимостью
SELECT title, author, price, amount,
     price * amount AS total
FROM book;


--Посчитать стоимость упаковки всех книг (1 упаковка = 1.65руб) и вывести отдельным столбцом
SELECT title, amount,
     1.65 * amount AS pack
FROM book;


--Вычисление налога на добавленную стоимость 18% (столбец tax) и цены книги без налога (столбец price_tax).
--Плюс округление полученных значений до двух знаков после запятой (ROUND)
SELECT title,
    price,
    ROUND((price*18/100)/(1+18/100),2) AS tax,
    ROUND(price/(1+18/100),2) AS price_tax
FROM book;


--Вычисление стоимости книг со скидкой 30% (столбец new_price)
--Плюс округление полученных значений до двух знаков после запятой
SELECT title, author, amount,
ROUND((price-price*0.3),2) AS new_price
FROM book;
--другой вариант решения
SELECT title, author, amount,
ROUND(price * 0.7, 2) AS new_price
FROM book;


--Если количество книг меньше 4, то скидка будет составлять 50% от цены, в противном случае 30%
--Вариант для MySQL
SELECT title, amount, price,
    IF(amount<4, price*0.5, price*0.7) AS sale
FROM book;
--Вариант для SQLite
SELECT title, amount, price,
    CASE
        WHEN amount < 4 THEN price * 0.5
        ELSE price * 0.7
    END AS sale
FROM book;


--Пересчёт цен: +10% для книг Булгакова, +5% для книг Есенина, остальные без изменений
--Вариант для MySQL
SELECT author, title,
    ROUND(
     IF(author = 'Булгаков М.А.', price * 1.1,
         IF(author = 'Есенин С.А.', price * 1.05, price * 1)),
     2) AS new_price
FROM book;
--Вариант для SQLite
SELECT
    author,
    title,
    ROUND(
        CASE
            WHEN author = 'Булгаков М.А.' THEN price * 1.1
            WHEN author = 'Есенин С.А.' THEN price * 1.05
            ELSE price
        END,
    2) AS new_price
FROM book;


--Вывести автора, название  и цены тех книг, количество которых меньше 10.
SELECT author, title, price
FROM book
WHERE amount < 10;


-- Книги с ценой <500 или >600 и общей стоимостью ≥5000
SELECT title, author, price, amount
FROM book
WHERE (price < 500 OR price > 600) AND price * amount >= 5000;


--Книги с ценой от 540.50 до 800 и количеством 2, 3, 5 или 7
SELECT title, author
FROM book
WHERE price BETWEEN 540.50 AND 800
  AND amount IN (2, 3, 5, 7);


--Книги с количеством от 2 до 14, сортировка по автору (по убыванию) и названию (по возрастанию)
SELECT author, title
FROM book
WHERE amount >= 2 AND amount <= 14
ORDER BY author DESC, title ASC;


--Книги с двумя и более словами в названии и инициалами автора с буквой С
SELECT title, author
FROM book
WHERE author LIKE "%С.%"
  AND title LIKE "_% _%"
ORDER BY title ASC;
