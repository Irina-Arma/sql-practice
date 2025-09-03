


--Сбросить таблицу и пересоздать заново
DROP TABLE IF EXISTS book;
CREATE TABLE book (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
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
    ('Братья Карамазовы', 'Достоевский Ф.М.	', 799.01, 3),
    ('Игрок', 'Достоевский Ф.М.	', 480.50, 10),
    ('Стихотворения и поэмы', 'Есенин С.А.', 650.00, 15);
SELECT * FROM book;


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
