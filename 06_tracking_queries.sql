USE LibraryDB;

-- Which books are currently issued, and to whom?
SELECT t.TransactionID, b.Title, u.FullName, t.IssueDate, t.DueDate
FROM Transactions t
JOIN Books b ON t.BookID = b.BookID
JOIN Users u ON t.UserID = u.UserID
WHERE t.Status = 'Issued';

-- Overdue books
-- (MySQL DATEDIFF(a, b) = a - b, so today comes first)
SELECT b.Title, u.FullName, t.DueDate,
       DATEDIFF(CURDATE(), t.DueDate) AS DaysOverdue
FROM Transactions t
JOIN Books b ON t.BookID = b.BookID
JOIN Users u ON t.UserID = u.UserID
WHERE t.Status = 'Issued' AND t.DueDate < CURDATE();

-- Borrowing history of one user
SELECT b.Title, t.IssueDate, t.ReturnDate, t.Status
FROM Transactions t
JOIN Books b ON t.BookID = b.BookID
WHERE t.UserID = 1;

-- Books that are available right now
SELECT Title, Author, AvailableCopies
FROM Books
WHERE AvailableCopies > 0;

-- Most borrowed books
SELECT b.Title, COUNT(*) AS TimesIssued
FROM Transactions t
JOIN Books b ON t.BookID = b.BookID
GROUP BY b.BookID, b.Title
ORDER BY TimesIssued DESC;
