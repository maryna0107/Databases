-- do not allow insert if the inserted specimen is on examination during the period of exhibition

CREATE OR REPLACE FUNCTION exhibition_overlaps_examination()
RETURNS TRIGGER AS $$
DECLARE
    conflict_exists BOOLEAN;
    examination_start TIMESTAMP;
    examination_end TIMESTAMP;
	exhibition_start timestamp;
	exhibition_end timestamp;
	specimen_on_examination uuid;
BEGIN
    conflict_exists := FALSE;

    SELECT x.startdate, x.specimen_id, x.enddate 
    INTO examination_start, specimen_on_examination, examination_end
    FROM examinations x
    WHERE x.specimen_id = NEW.specimen_id;
	
	select e.start_at, e.end_at from exhibitions e
	into exhibition_start, exhibition_end
	where e.id = new.exhibition_id;
-- check if the examination overlaps the exhibition		 
	IF (examination_start, examination_end) overlaps (exhibition_start, exhibition_end) THEN
		RAISE EXCEPTION 'Cannot plan exhibition. Specimen is on examination during the requested period.';
	END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER exhibition_overlaps_examination_trigger
BEFORE INSERT ON Exhibitions_zones
FOR EACH ROW
EXECUTE FUNCTION exhibition_overlaps_examination();