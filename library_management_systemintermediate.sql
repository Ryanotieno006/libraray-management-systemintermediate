USE library_management_intermediate_system;

CREATE TABLE books(
book_id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(100) NOT NULL,
author VARCHAR(50) NOT NULL,
isbn VARCHAR(20) UNIQUE,
published_year INT,
available BOOLEAN DEFAULT TRUE
);

CREATE TABLE borrowers(
borrower_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
email VARCHAR(50) UNIQUE,
phone VARCHAR(20)
);

CREATE TABLE loans (
loan_id INT AUTO_INCREMENT PRIMARY KEY,
book_id INT NOT NULL,
borrower_id INT NOT NULL,
checkout_date DATE DEFAULT (CURRENT_DATE),  -- Parentheses added
due_date DATE DEFAULT (CURRENT_DATE + INTERVAL 14 DAY),  -- Valid for MySQL 8.0+
returned BOOLEAN DEFAULT FALSE,
FOREIGN KEY (book_id) REFERENCES books(book_id),
FOREIGN KEY (borrower_id) REFERENCES borrowers(borrower_id)
);

INSERT INTO books (title, author, isbn, published_year, available) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 1925, TRUE),
('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 1960, TRUE),
('1984', 'George Orwell', '9780451524935', 1949, FALSE),
('Pride and Prejudice', 'Jane Austen', '9781503290563', 1813, TRUE),
('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 1937, TRUE),
('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 1951, FALSE),
('The Lord of the Rings', 'J.R.R. Tolkien', '9780544003415', 1954, TRUE),
('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', '9780590353427', 1997, FALSE),
('The Da Vinci Code', 'Dan Brown', '9780307474278', 2003, TRUE),
('The Alchemist', 'Paulo Coelho', '9780062315007', 1988, TRUE),
('The Hunger Games', 'Suzanne Collins', '9780439023481', 2008, FALSE),
('The Book Thief', 'Markus Zusak', '9780375831003', 2005, TRUE),
('Gone Girl', 'Gillian Flynn', '9780307588364', 2012, TRUE),
('The Silent Patient', 'Alex Michaelides', '9781250301697', 2019, FALSE),
('Educated', 'Tara Westover', '9780399590504', 2018, TRUE),
('Sapiens', 'Yuval Noah Harari', '9780062316097', 2011, TRUE),
('Atomic Habits', 'James Clear', '9780735211292', 2018, FALSE),
('Dune', 'Frank Herbert', '9780441172719', 1965, TRUE),
('The Midnight Library', 'Matt Haig', '9780525559474', 2020, TRUE),
('Project Hail Mary', 'Andy Weir', '9780593135204', 2021, FALSE);

INSERT INTO borrowers (name, email, phone) VALUES
('Emma Johnson', 'emma.j@email.com', '555-0101'),
('Michael Chen', 'michael.c@email.com', '555-0102'),
('Sophia Rodriguez', 'sophia.r@email.com', '555-0103'),
('James Wilson', 'james.w@email.com', '555-0104'),
('Olivia Smith', 'olivia.s@email.com', '555-0105');

INSERT INTO loans (book_id, borrower_id, checkout_date, due_date, returned) VALUES
(3, 1, '2023-06-15', '2023-06-29', FALSE),  -- 1984 checked out by Emma (overdue)
(6, 3, '2023-07-01', '2023-07-15', FALSE),  -- Catcher in the Rye by Sophia
(8, 2, '2023-06-20', '2023-07-04', FALSE),  -- Harry Potter by Michael (overdue)
(11, 5, '2023-07-05', '2023-07-19', FALSE), -- Hunger Games by Olivia
(17, 4, '2023-06-25', '2023-07-09', FALSE), -- Atomic Habits by James (overdue)
(20, 1, '2023-07-10', '2023-07-24', FALSE); -- Project Hail Mary by Emma

SELECT title FROM books
WHERE author LIKE '%Tolkien%' AND available= TRUE;

SELECT b.title, br.name, br.email, l.due_date
FROM loans l
JOIN books b ON l.book_id=b.book_id
JOIN borrowers br ON l.borrower_id=br.borrower_id
WHERE l.returned= FALSE AND l.due_date < CURDATE();

SELECT b.author, SUM(loan_id) AS loans_count
FROM loans l
JOIN books b ON l.book_id=b.book_id
GROUP BY b.author
ORDER BY loans_count DESC
LIMIT 3;

WITH book_loans AS(
SELECT book_id, SUM(loan_id) AS times_borrowed
FROM loans
GROUP BY book_id
)
SELECT b.title, bl.times_borrowed
FROM books b
JOIN book_loans bl ON b.book_id=bl.book_id
ORDER BY bl.times_borrowed DESC;

SELECT br.name, br.email
FROM borrowers br
WHERE br.borrower_id NOT IN (
SELECT DISTINCT borrower_id
FROM loans
WHERE checkout_date > CURDATE() - INTERVAL 6 MONTH
);

START TRANSACTION;
UPDATE loans SET returned= TRUE WHERE loan_id=5;
UPDATE books SET available= TRUE WHERE book_id=(SELECT book_id FROM loans WHERE loan_id= 5);
COMMIT;

CREATE INDEX idx_loans_dates ON loans(checkout_date, due_date);
CREATE INDEX idx_books_author ON books(author);




