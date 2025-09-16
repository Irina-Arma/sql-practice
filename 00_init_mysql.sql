-- Создаём чистую БД и базовые таблицы под MySQL
DROP DATABASE IF EXISTS library;
CREATE DATABASE library CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE library;

CREATE TABLE IF NOT EXISTS book (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  title   VARCHAR(50)  NOT NULL,
  author  VARCHAR(30)  NOT NULL,
  price   DECIMAL(8,2) NOT NULL,
  amount  INT          NOT NULL
);

CREATE TABLE IF NOT EXISTS supply (
  supply_id INT AUTO_INCREMENT PRIMARY KEY,
  title     VARCHAR(50)  NOT NULL,
  author    VARCHAR(30)  NOT NULL,
  price     DECIMAL(8,2) NOT NULL,
  amount    INT          NOT NULL
);
