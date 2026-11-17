# Library Management System (MySQL)

A beginner-friendly relational database project that manages **books**, **users**, and **transactions**. It includes stored procedures for issuing and returning books, plus queries for tracking them.

## Tech Used

- MySQL 8.0.16 or newer (needed so `CHECK` constraints are enforced)
- MySQL Workbench (or the `mysql` command line)
- Git and GitHub

## Database Design

Three tables, connected with foreign keys:

| Table | Purpose |
|---|---|
| `Books` | Stores every book, with total and available copies |
| `Users` | Stores people who borrow books |
| `Transactions` | Records each issue and return (links a user to a book) |

### Relationships

```
Users (1) ────< Transactions >──── (1) Books
```

- One user can have many transactions.
- One book can appear in many transactions.
- `Transactions` holds two foreign keys: `UserID` and `BookID`.

## Project Structure

```
library-management-mysql/
├── 01_create_database.sql
├── 02_create_tables.sql
├── 03_insert_data.sql
├── 04_issue_book.sql
├── 05_return_book.sql
├── 06_tracking_queries.sql
└── README.md
```

## How to Run

Run each file **in this order** (Workbench: File > Open SQL Script > lightning icon):

1. `01_create_database.sql` creates the `LibraryDB` database.
2. `02_create_tables.sql` creates the Books, Users and Transactions tables.
3. `03_insert_data.sql` adds sample books and users.
4. `04_issue_book.sql` creates the `IssueBook` stored procedure.
5. `05_return_book.sql` creates the `ReturnBook` stored procedure.
6. `06_tracking_queries.sql` contains queries to track books.

Or from the command line:

```bash
mysql -u root -p < 01_create_database.sql
mysql -u root -p < 02_create_tables.sql
# ...and so on
```

## Usage Examples

**Issue a book** (BookID 1 to UserID 1, for 14 days):

```sql
CALL IssueBook(1, 1, 14);
```

**Return a book** (using the TransactionID):

```sql
CALL ReturnBook(1);
```

**See currently issued books:**

```sql
SELECT t.TransactionID, b.Title, u.FullName, t.IssueDate, t.DueDate
FROM Transactions t
JOIN Books b ON t.BookID = b.BookID
JOIN Users u ON t.UserID = u.UserID
WHERE t.Status = 'Issued';
```

## Features

- Primary keys, foreign keys, `UNIQUE`, `CHECK` and `DEFAULT` constraints
- Issue and return handled with transactions (all-or-nothing) using the InnoDB engine
- Row locking (`FOR UPDATE`) so the last copy cannot be issued twice
- Error handler that rolls back if something fails
- Tracking queries: currently issued, overdue, user history, availability, most borrowed

## Concepts Practiced

- Normalization and table relationships (one-to-many)
- INNER JOIN, GROUP BY, ORDER BY
- Stored procedures (`IN` parameters, `DELIMITER`, exit handlers)
- Transactions and ACID properties
- Constraints and data integrity

## SQL Server vs MySQL (what changed)

| SQL Server | MySQL |
|---|---|
| `IDENTITY(1,1)` | `AUTO_INCREMENT` |
| `GETDATE()` | `CURDATE()` / `CURRENT_DATE` |
| `DATEADD(DAY, n, d)` | `DATE_ADD(d, INTERVAL n DAY)` |
| `DATEDIFF(DAY, a, b)` = b - a | `DATEDIFF(b, a)` = b - a |
| `GO` | `DELIMITER $$ ... DELIMITER ;` (for procedures) |
| `@BookID INT = 14` default param | no defaults, pass every value |
| `PRINT 'msg'` | `SELECT 'msg' AS Message` |
| `EXEC IssueBook ...` | `CALL IssueBook(...)` |
| `BEGIN TRANSACTION` | `START TRANSACTION` |

## Future Improvements

- Add a `Fines` table for late returns
- Add a `Staff` table to record who issued each book
- Add a view for overdue books

## Author

Shagun Nichant  
GitHub: https://github.com/shagunnichant93

## GitHub Practice

- Created a feature branch.
- Practiced creating a pull request.
- Learning GitHub collaboration.
