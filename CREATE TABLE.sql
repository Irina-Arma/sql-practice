--Создание таблицы book, в которой будут храниться данные о книгах
CREATE TABLE book (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);
--Добавление 1 новой строки и вывод всех записей из таблицы book
INSERT INTO
    book (title, author, price, amount)
VALUES
    ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);

SELECT
    *
FROM
    book;

--Добавление 3 новых строк и вывод всех записей из таблицы book
INSERT INTO book (title, author, price, amount)
VALUES
    ('Белая гвардия', 'Булгаков М.А.', 540.50 , 5),
    ('Идиот', 'Достоевский Ф.М.', 460, 10),
    ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);
SELECT
    *
FROM
    book;

