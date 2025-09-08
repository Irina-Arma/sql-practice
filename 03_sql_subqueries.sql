/*
*/


--Вывести информацию о самых дешевых книгах, хранящихся на складе
SELECT title, author, price, amount
FROM book
WHERE price = (
         SELECT MIN(price)
         FROM book
);


--Книги с ценой ниже или равной средней, сортировка по убыванию цены
SELECT author, title, price
FROM book
WHERE price <= (
         SELECT AVG(price)
         FROM book)
ORDER BY price DESC;


--Функция ABS
--Книги, у которых количество экземпляров отличается от среднего более чем на 3
SELECT title, author, amount
FROM book
WHERE ABS(amount - (SELECT AVG(amount) FROM book)) >3;


--Книги с ценой на складе не более чем на 150 выше минимальной, сортировка по возрастанию цены
SELECT author, title, price
FROM book
    WHERE (price - (SELECT MIN(price) FROM book)) <= 150
ORDER BY price ASC;
--Другой вариант решения через BETWEEN
SELECT author, title, price
FROM book
WHERE price BETWEEN (SELECT MIN(price) FROM book)
                AND (SELECT MIN(price) FROM book) + 150
ORDER BY price ASC;


--Оператор IN
--Вывести информацию о книгах тех авторов, общее количество экземпляров книг которых не менее 12
SELECT title, author, amount, price
FROM book
WHERE author IN (
        SELECT author
        FROM book
        GROUP BY author
        HAVING SUM(amount) >= 12
);


--Книги, у которых количество экземпляров уникально (не повторяется)
SELECT author, title, amount
FROM book
WHERE amount IN (
        SELECT amount
        FROM book
        GROUP BY amount
        HAVING COUNT(amount)=1
);


--Оператор ALL
--Вывести информацию о тех книгах, количество которых меньше среднего количества книг у каждого автора
SELECT title, author, amount, price
FROM book
WHERE amount < ALL (
        SELECT AVG(amount)
        FROM book
        GROUP BY author
);


--
