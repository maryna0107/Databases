-- automatic setting of the edit date when chanding zones within the exhibition
CREATE OR REPLACE FUNCTION update_edited_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.edited_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_edited_at
BEFORE UPDATE ON exhibitions_zones
FOR EACH ROW
EXECUTE FUNCTION update_edited_at();