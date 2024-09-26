-- check if the specimen is not already promissed
CREATE OR REPLACE FUNCTION update_exhibition_trigger_function_loans()
RETURNS TRIGGER AS $$
DECLARE
    conflict_exists BOOLEAN;
BEGIN
    conflict_exists := FALSE;
-- if the specimen i try to insert is already in the table and the deal is still opened do not allow inserting new record
    SELECT EXISTS (
        SELECT 1
        FROM loans_borrows lb
        WHERE lb.specimen_id = NEW.specimen_id
        AND closed_date is null
        LIMIT 1
    ) INTO conflict_exists;

    IF conflict_exists THEN
        RAISE EXCEPTION 'Cannot plan loan. Specimen is already on loan during the requested period.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creating the trigger
CREATE OR REPLACE TRIGGER update_exhibition_trigger_loans
BEFORE INSERT ON loans_borrows
FOR EACH ROW
EXECUTE FUNCTION update_exhibition_trigger_function_loans();