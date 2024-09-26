-- do not allow insert if the inserted specimen is on loan during the period of exhibition
CREATE OR REPLACE FUNCTION exhibition_overlaps_loan()
RETURNS TRIGGER AS $$
DECLARE
    conflict_exists BOOLEAN;
    loan_start TIMESTAMP;
    exhibition_end TIMESTAMP;
	specimen_id_use uuid;
	loan_close_date TIMESTAMP;
BEGIN
    conflict_exists := FALSE;

    SELECT lb.started_at, lb.specimen_id
    INTO loan_start, specimen_id_use
    FROM loans_borrows lb
    WHERE lb.specimen_id = NEW.specimen_id
    AND lb.closed_date IS NULL;
	
	select e.end_at from exhibitions e
	into exhibition_end
	where e.id = new.exhibition_id
	and loan_close_date is null;
-- for open deals check if the end date of the exhibition is before the start date of the deal
    IF loan_start IS NOT NULL THEN
        IF exhibition_end >= loan_start THEN
            RAISE EXCEPTION 'Cannot plan exhibition. Specimen is on loan during the requested period.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER exhibition_overlaps_loan_trigger
BEFORE INSERT or update ON Exhibitions_zones
FOR EACH ROW
EXECUTE FUNCTION exhibition_overlaps_loan();