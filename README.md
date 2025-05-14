# libraray-management-systemintermediate
A simple Library Management System that handles book borrowing, returns, and availability tracking using SQL
# 📚 Library Management System (Intermediate Project)

This is an intermediate-level **Library Management System** built using **MySQL**. The system allows you to manage books, borrowers, and book loans, including tracking due dates and returns.

## 🚀 Features

- 📖 Add and manage books with availability status
- 👥 Register borrowers with contact details
- 🔄 Track book checkouts and due dates
- ✅ Handle book returns and update availability
- 📊 Run useful queries like:
  - Overdue loans
  - Most borrowed books
  - Top authors by loan count
  - Inactive borrowers (no loans in the last 6 months)

## 🗃️ Database Structure

### 1. `books`
Stores book details.

| Column         | Type           | Description                      |
|----------------|----------------|----------------------------------|
| `book_id`      | INT (PK)       | Unique book identifier           |
| `title`        | VARCHAR(100)   | Book title                       |
| `author`       | VARCHAR(50)    | Author name                      |
| `isbn`         | VARCHAR(20)    | Unique ISBN                      |
| `published_year` | INT         | Year of publication              |
| `available`    | BOOLEAN        | Availability status              |

### 2. `borrowers`
Stores borrower information.

| Column         | Type           | Description                      |
|----------------|----------------|----------------------------------|
| `borrower_id`  | INT (PK)       | Unique borrower ID               |
| `name`         | VARCHAR(50)    | Full name                        |
| `email`        | VARCHAR(50)    | Unique email                     |
| `phone`        | VARCHAR(20)    | Phone number                     |

### 3. `loans`
Tracks borrowing activity.

| Column         | Type           | Description                      |
|----------------|----------------|----------------------------------|
| `loan_id`      | INT (PK)       | Unique loan ID                   |
| `book_id`      | INT (FK)       | Linked book                      |
| `borrower_id`  | INT (FK)       | Linked borrower                  |
| `checkout_date`| DATE           | When the book was borrowed       |
| `due_date`     | DATE           | When the book is due             |
| `returned`     | BOOLEAN        | If the book has been returned    |

## 📦 Sample Queries

- Find books by Tolkien that are available:
  ```sql
  SELECT title FROM books WHERE author LIKE '%Tolkien%' AND available = TRUE;
List all overdue books:

sql
Copy
Edit
SELECT b.title, br.name, br.email, l.due_date
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN borrowers br ON l.borrower_id = br.borrower_id
WHERE l.returned = FALSE AND l.due_date < CURDATE();
Top 3 most borrowed authors:

sql
Copy
Edit
SELECT b.author, COUNT(*) AS loans_count
FROM loans l
JOIN books b ON l.book_id = b.book_id
GROUP BY b.author
ORDER BY loans_count DESC
LIMIT 3;
🔄 Return Process (Atomic Transaction)
Ensures both the loan is marked returned and the book is made available:

sql
Copy
Edit
START TRANSACTION;
UPDATE loans SET returned = TRUE WHERE loan_id = 5;
UPDATE books SET available = TRUE WHERE book_id = (
  SELECT book_id FROM loans WHERE loan_id = 5
);
COMMIT;
⚡ Performance
Indexes added to optimize query speed:

sql
Copy
Edit
CREATE INDEX idx_loans_dates ON loans(checkout_date, due_date);
CREATE INDEX idx_books_author ON books(author);





