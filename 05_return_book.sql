USE LibraryDB;

DROP PROCEDURE IF EXISTS ReturnBook;

DELIMITER $$

CREATE PROCEDURE ReturnBook(
    IN p_TransactionID INT
)
BEGIN
    DECLARE v_BookID INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: could not return the book.' AS Message;
    END;

    START TRANSACTION;

    -- Find the book, but only if this transaction is still 'Issued'
    SELECT BookID INTO v_BookID
    FROM Transactions
    WHERE TransactionID = p_TransactionID AND Status = 'Issued'
    FOR UPDATE;

    IF v_BookID IS NULL THEN
        ROLLBACK;
        SELECT 'Invalid transaction or book already returned.' AS Message;
    ELSE
        UPDATE Transactions
        SET ReturnDate = CURDATE(), Status = 'Returned'
        WHERE TransactionID = p_TransactionID;

        UPDATE Books
        SET AvailableCopies = AvailableCopies + 1
        WHERE BookID = v_BookID;

        COMMIT;
        SELECT 'Book returned successfully.' AS Message;
    END IF;
END$$

DELIMITER ;

/* Testing */
-- CALL ReturnBook(1);
