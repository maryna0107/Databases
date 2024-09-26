-------------Naplanovanie expozicie-------------------------
INSERT INTO Exhibitions (name, start_at, end_at)
VALUES 
    ('From The Other Side', '2024-08-01', '2024-08-30');
	
select * from exhibitions where name = 'From The Other Side';
	
INSERT INTO Exhibitions_zones (exhibition_id, zone_name, specimen_id)
VALUES 
    ('f6526562-63b5-4149-bcee-2d4a99e30745', 'Zone A', '7a2d5095-8a81-4fd6-8665-d916f42a9b4e'),
	('f6526562-63b5-4149-bcee-2d4a99e30745', 'Zone A', 'b78c12c5-4353-426e-9bd8-17685e36b992');
	
	









