-- while planning the loan/borrow, check if the specimen is not on the exhibition or examination

CREATE OR REPLACE FUNCTION update_exhibition_trigger_function()
RETURNS TRIGGER AS $$
DECLARE
    conflict_exists BOOLEAN;
BEGIN
    conflict_exists := FALSE;
-- check if the specimen to be added to the loans_borrows table is on the exhibition during the requested period
    SELECT EXISTS (
        SELECT 1
        FROM Specimen s 
        JOIN Exhibitions_Zones z ON s.id = z.specimen_id
        JOIN Exhibitions e ON z.exhibition_id = e.id
        WHERE z.specimen_id = NEW.specimen_id
        AND NEW.started_at <= e.end_at -- chech if the start date of the loan is after the end date of the exhibition
        LIMIT 1
    ) INTO conflict_exists;

    IF conflict_exists THEN
        RAISE EXCEPTION 'Cannot plan loan. Specimen is part of an exhibition during the requested loan period.';
    END IF;
	
	
	--------------------------------------------------------------------
	-- check if the specimen to be added to the loans_borrows table is on examination during the requested period
	 SELECT EXISTS (
        SELECT 1
        FROM Specimen s 
        JOIN Examinations x ON x.specimen_id = s.id
        WHERE x.specimen_id = NEW.specimen_id
        AND NEW.started_at <= x.enddate -- chech if the start date of the loan is after the end date of the examination
        LIMIT 1
    ) INTO conflict_exists;

    -- If conflict exists, raise an error
    IF conflict_exists THEN
        RAISE EXCEPTION 'Cannot plan loan. Specimen is on examination during the requested loan period.';
    END IF;
	
	-----------------------------------------------------------------------

    -- If no conflict, return NEW for further actions
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creating the trigger
CREATE OR REPLACE TRIGGER update_exhibition_trigger
BEFORE INSERT or update ON loans_borrows
FOR EACH ROW
EXECUTE FUNCTION update_exhibition_trigger_function();