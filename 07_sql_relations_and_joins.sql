/*
Работа с связанными таблицами и внешними ключами.
Используются INNER JOIN, LEFT/RIGHT JOIN, CROSS JOIN,
выборки из нескольких таблиц с группировкой и подзапросами,
каскадное удаление и корректировка данных связанных таблиц.
*/


--Создание и наполнение таблицы author
CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50));

INSERT INTO author (name_author) VALUES
('Булгаков М.А.'),
('Достоевский Ф.М.'),
('Есенин С.А.'),
('Пастернак Б.Л.');
SELECT * FROM author;



--Создание таблицы с внешними ключами (FOREIGN KEY)
--Создаём таблицу book с полями для названия, цены, количества книг
--и связываем её с таблицами author и genre через внешние ключи
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2),
    amount INT,
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id),
    FOREIGN KEY (author_id) REFERENCES author (author_id)
);


--Создаём таблицу book:
--если удалить автора, все его книги удалятся автоматически (ON DELETE CASCADE);
--если удалить жанр, в книгах этого жанра значение genre_id станет NULL (ON DELETE SET NULL)
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2),
    amount INT,
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE SET NULL
);
