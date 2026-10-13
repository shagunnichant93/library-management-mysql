USE LibraryDB;

DROP PROCEDURE IF EXISTS IssueBook;

DELIMITER $$

CREATE PROCEDURE IssueBook(
    IN p_BookID INT,
    IN p_UserID INT,
    IN p_DaysAllowed INT      -- MySQL has no default values, so pass 14 yourself
)
BEGIN
    DECLARE v_available INT;

    -- If anything goes wrong, undo everything
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: could not issue the book (check BookID and UserID).' AS Message;
    END;

    START TRANSACTION;

    -- Lock this book's row so two people cannot take the last copy together
    SELECT AvailableCopies INTO v_available
    FROM Books
    WHERE BookID = p_BookID
    FOR UPDATE;

    IF v_available IS NULL THEN
        ROLLBACK;
        SELECT 'Book not found.' AS Message;
    ELSEIF v_available <= 0 THEN
        ROLLBACK;
        SELECT 'Sorry, no copies available.' AS Message;
    ELSE
        INSERT INTO Transactions (BookID, UserID, IssueDate, DueDate)
        VALUES (p_BookID, p_UserID, CURDATE(), DATE_ADD(CURDATE(), INTERVAL p_DaysAllowed DAY));

        UPDATE Books
        SET AvailableCopies = AvailableCopies - 1
        WHERE BookID = p_BookID;

        COMMIT;
        SELECT 'Book issued successfully.' AS Message;
    END IF;
END$$

DELIMITER ;

/* Testing */
-- CALL IssueBook(1, 1, 14);
-- CALL IssueBook(2, 2, 14);
