-- inserting the same specimen in different overlapping exhibitions
CREATE OR REPLACE FUNCTION prevent_duplicates1()
RETURNS TRIGGER AS $$
DECLARE
    existing_exhibition_record RECORD;
    existing_exhibition_start TIMESTAMP;
    existing_exhibition_end TIMESTAMP;
    inserted_exhibition_start TIMESTAMP;
    inserted_exhibition_end TIMESTAMP;
    zone_name_u exhibition_zone_enum;
    specimen_id_u uuid;
	idd uuid;
BEGIN
-- selecting the start and end date of existing exhibitions if zone name is the same to the one being inserted
    SELECT e.start_at, e.end_at, z.zone_name, z.specimen_id, z.id INTO existing_exhibition_start, existing_exhibition_end, zone_name_u, specimen_id_u, idd
    FROM Exhibitions_zones z
    JOIN Exhibitions e ON z.exhibition_id = e.id
    WHERE z.specimen_id = NEW.specimen_id;
-- the same select but for new record
    SELECT start_at, end_at INTO inserted_exhibition_start, inserted_exhibition_end
    FROM Exhibitions
    WHERE id = NEW.exhibition_id;
-- check if dates are overlapping and their specimens are the same
    IF (existing_exhibition_start, existing_exhibition_end) OVERLAPS (inserted_exhibition_start, inserted_exhibition_end)
    AND specimen_id_u = NEW.specimen_id and new.id != idd THEN
        RAISE EXCEPTION 'Cannot add a specimen with overlapping exhibitions';
    END IF;
	
	IF EXISTS (
        SELECT 1
        FROM Exhibitions_zones
        WHERE exhibition_id = NEW.exhibition_id
          AND zone_name = NEW.zone_name
          AND specimen_id != NEW.specimen_id
    ) THEN
        RETURN NEW;
	end if;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_duplicates1
BEFORE INSERT OR UPDATE ON Exhibitions_zones
FOR EACH ROW
EXECUTE FUNCTION prevent_duplicates1();