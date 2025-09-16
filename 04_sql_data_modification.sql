/*

*/

--Создание таблицы supply
CREATE TABLE supply (
    supply_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);


--Добавление записей в таблицу supply
INSERT INTO supply (title, author, price, amount)
VALUES
    ('Лирика', 'Пастернак Б.Л.', 518.99, 2),
    ('Черный человек', 'Есенин С.А.', 570.20, 6),
    ('Белая гвардия', 'Булгаков М.А.', 540.50, 7),
    ('Идиот', 'Достоевский Ф.М.', 360.80, 3);
SELECT * FROM supply;


--Добавляем все книги из таблицы supply в таблицу book
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount FROM supply;
SELECT * FROM book;


--Добавляем в таблицу book только те книги из supply,
--автор которых не Булгаков М.А. и не Достоевский Ф.М.
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply WHERE author NOT IN ('Булгаков М.А.', 'Достоевский Ф.М.');
SELECT * FROM book;


--Добавляем в таблицу book только те книги из supply,
--которых ещё нет в book (сравнение идёт по названию)
--применяется вложенный запрос
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE title NOT IN (
        SELECT title
        FROM book
      );
SELECT * FROM book;


--Добавляем в таблицу book только те книги из supply,
--которых ещё нет в book (сравнение идёт по авторам)
--применяется вложенный запрос
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN (
        SELECT author
        FROM book
      );
SELECT * FROM book;


--Оператор UPDATE и команда SET
--Уменьшаем цену всех книг в таблице book на 30% (оставляем 70% от текущей)
UPDATE book
SET price = 0.7 * price;
SELECT * FROM book;


--Уменьшаем цену на 30% только для тех книг в таблице book,
--у которых количество (amount) меньше 5
UPDATE book
SET price = 0.7 * price
WHERE amount < 5;
SELECT * FROM book;


--Уменьшаем цену на 10% для книг, у которых количество (amount) равно от 5 до 10 включительно
UPDATE book
SET price = 0.9 * price
WHERE amount >= 5 AND amount <= 10;
SELECT * FROM book;


-- Удаляем книгу "Игрок"
DELETE FROM book
WHERE title = 'Игрок';

-- Добавляем новый столбец buy с типом INT
ALTER TABLE book
ADD COLUMN buy INT DEFAULT 0;
UPDATE book
SET buy = 3
WHERE title = 'Белая гвардия';
UPDATE book
SET buy = 8
WHERE title = 'Идиот';
UPDATE book
SET buy = 18
WHERE title = 'Стихотворения и поэмы';
UPDATE book
SET book_id = 5
WHERE title = 'Стихотворения и поэмы';
UPDATE book
SET amount = 2
WHERE title = 'Братья Карамазовы';
SELECT * FROM book;


--Если покупатель хочет больше книг, чем есть на складе, корректируем buy до количества на складе.
--Для книг, которые никто не заказал (buy = 0), снижаем цену на 10%.
UPDATE book
SET buy = IF(buy >= amount, amount, buy),
    price = IF(buy = 0, price * 0.9, price);
SELECT * FROM book;


--Запрос на обновление нескольких таблиц
--Для каждой книги в book, которая есть в supply с таким же названием и автором,
--увеличиваем её количество (amount) на количество из supply
UPDATE book, supply
SET book.amount = book.amount + supply.amount
WHERE book.title = supply.title AND book.author = supply.author;
SELECT * FROM book;


--Для книг, которые есть в обеих таблицах, увеличиваем количество на поступившие из supply
--и пересчитываем цену как среднее между старой и новой
UPDATE book, supply
SET book.amount = book.amount + supply.amount,
book.price = (book.price + supply.price) / 2
WHERE book.title = supply.title AND book.author = supply.author;
SELECT * FROM book;

