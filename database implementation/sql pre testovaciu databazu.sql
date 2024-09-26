----------pre filling of the database-----------------------------------------------------------------------------
INSERT INTO Specimen (name, description, status)
VALUES 
    ('Mona Lisa', 'The Mona Lisa is a half-length portrait painting by Italian artist Leonardo da Vinci.', 'own'),
    ('The Starry Night', 'The Starry Night is an oil-on-canvas painting by the Dutch Post-Impressionist painter Vincent van Gogh painted in June 1889.', 'own'),
    ('The Scream', 'The Scream by Edvard Munch. The Scream is the famous name for a composition by Norwegian artist Edvard Munch, which was produced in 1893. ', 'own');
------------------------------------------------------------------------------------------------------------------
INSERT INTO Institutions (name, address, type)
VALUES 
	('Private Gallery', '4567 Backer str., London', 'private collection'),
    ('National museum', '123 Backer str., London', 'museum');
------------------------------------------------------------------------------------------------------------------	
Insert into Categories (name)
	values('Paintings'),
	('Sculptures'),
	('Drawings'),
	('Photography');
-----------------------------------------------------------------------------------------------------------------	
	
select * from specimen;
select * from categories;
		
Insert into Specimen_Categories(specimenid, categoriesid)
values('7a2d5095-8a81-4fd6-8665-d916f42a9b4e', 'a9f52c83-dbf9-43de-96c5-120fcab499ed'),
('b78c12c5-4353-426e-9bd8-17685e36b992', 'a9f52c83-dbf9-43de-96c5-120fcab499ed'),
('6609e083-03d9-4c10-bed7-38d759d79a08', 'a9f52c83-dbf9-43de-96c5-120fcab499ed');
----------------------------------------------------------------------------------------------------------------------

INSERT INTO Exhibitions (name, start_at, end_at)
VALUES 
    ('History of art', '2024-05-01', '2024-05-30'),
	('Nature', '2024-08-11', '2024-10-30'),
	('Oil paintings', '2024-05-15', '2024-06-25');
----------------------------------------------------------------------------------------------------------------------
select * from exhibitions
select * from specimen


--- Mona Lisa is on exhibition 'HIstory of art' from the 1st of May to the 30th of May in Zone A
INSERT INTO Exhibitions_zones (exhibition_id, zone_name, specimen_id)
VALUES 
    ('ff24285c-3abc-4bd7-bca3-0dcf3d562b35', 'Zone A', '7a2d5095-8a81-4fd6-8665-d916f42a9b4e');
----------------------------------------------------------------------------------------------------------------------
	
--- THe starry night is on Exhibition 'Oil paintings' from the 15th of May to the 25th of June
INSERT INTO Exhibitions_zones (exhibition_id, zone_name, specimen_id)
VALUES 
    ('11913983-2be9-40de-9b55-986e9e794282', 'Zone B', 'b78c12c5-4353-426e-9bd8-17685e36b992');
----------------------------------------------------------------------------------------------------------------------	
	
--- THe Starry Night is on examination from the 1st of September to the 5th of September	
insert into examinations (startdate, enddate, specimen_id)
values('2024-09-01', '2024-09-05', 'b78c12c5-4353-426e-9bd8-17685e36b992');
----------------------------------------------------------------------------------------------------------------------
select * from examinations
select * from institutions

--The Scream has planned loan from the 1st of October in institution 'Nation museum'
	
insert into loans_borrows (institution_id, specimen_id, started_at, return_date, duration, status)
values
	('32b5c6e9-ff51-453f-b269-6ffbda8dc22e', 
	 '6609e083-03d9-4c10-bed7-38d759d79a08', 
	 '2024-10-01', '2024-11-03', '15 days', 'planned');
----------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
 --                                    The invalid scenarious                               --
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------------------	
-- 	Try to plan the exhibition with a specimen that is on examination during the exhibition period

select * from exhibitions
select * from specimen

-- insert the starry night(on examination '2024-09-01', '2024-09-05') to the Nature exhibition('2024-08-11', '2024-10-30')

INSERT INTO Exhibitions_zones (exhibition_id, zone_name, specimen_id)
VALUES 
    ('db31a2e4-eb0e-4106-bc06-e53f4aad7ffa', 'Zone A', 'b78c12c5-4353-426e-9bd8-17685e36b992');
	
-- The error message is raised 'Cannot plan exhibition. Specimen is on examination during the requested period.'

-------------------------------------------------------------------------------------------------------------------

-- Try to plan the exhibition with a specimen that is on loan during the exhibition period

select * from specimen

-- insert the scream(on loan since 2024-10-01) to the Nature exhibition('2024-08-11', '2024-10-30')

INSERT INTO Exhibitions_zones (exhibition_id, zone_name, specimen_id)
VALUES 
    ('db31a2e4-eb0e-4106-bc06-e53f4aad7ffa', 'Zone A', '6609e083-03d9-4c10-bed7-38d759d79a08');
	
-- The error message is raised 'Cannot plan exhibition. Specimen is on loan during the requested period.'

------------------------------------------------------------------------------------------------------------------------

-- Try to insert two overlapping exhibitions in the same zone
select * from exhibitions


-- exhibition 'History of art'('2024-05-01', '2024-05-30') and 'Oil paintings' ('2024-05-15', '2024-06-25')
-- Mona Lisa is in 'History of art exhibition' in 'Zone A'
-- inserting The starry night in exhibition 'Oil paintings' from the 15th of May to the 25th of June in zone 'Zone A'
INSERT INTO Exhibitions_zones (exhibition_id, zone_name, specimen_id)
VALUES 
    ('11913983-2be9-40de-9b55-986e9e794282', 'Zone A', 'b78c12c5-4353-426e-9bd8-17685e36b992');
	
-- The error message is raised ' Cannot add a zone with overlapping exhibitions'

----------------------------------------------------------------------------------------------------------------

-- try to insert the same specimen into two overlapping exhibitions

select * from specimen

-- exhibition 'History of art'('2024-05-01', '2024-05-30') and 'Oil paintings' ('2024-05-15', '2024-06-25')
-- Mona Lisa is in 'History of art' exhibition in 'Zone A'
-- inserting Mona Lisa in exhibition 'Oil paintings' from the 15th of May to the 25th of June in zone 'Zone B'
INSERT INTO Exhibitions_zones (exhibition_id, zone_name, specimen_id)
VALUES 
    ('11913983-2be9-40de-9b55-986e9e794282', 'Zone B', '7a2d5095-8a81-4fd6-8665-d916f42a9b4e');

-- The error message is raised 'Cannot add a specimen with overlapping exhibitions'

--------------------------------------------------------------------------------------------------------------------

-- try to update the specimen into the zone where the overlaping exhibition takes place 
select * from exhibitions_zones

-- updating specimen The starry night that is currently on exhibition 'Oil paintings' in 'Zone B' into 'Zone A' 
-- where the overlapping exhibition 'History of art' takes place

update exhibitions_zones 
set zone_name = 'Zone A'
where id = 'a12dc263-6791-42b0-8101-ffbb48420b27'

-- The error message is raised 'Cannot add a zone with overlapping exhibitions'

update exhibitions_zones 
set zone_name = 'Zone C'
where id = 'a12dc263-6791-42b0-8101-ffbb48420b27'

-- successful update
--------------------------------------------------------------------------------------------------------------------
-- Try to plan a deal with the specimen that is on exhibition during the requested period

select * from specimen

-- try to plan a loan of Mona Lisa from the 15th of May if this specimen is on exhibition from 2024-05-01 to 2024-05-30

insert into loans_borrows (institution_id, specimen_id, started_at, return_date, duration, status)
values
('32b5c6e9-ff51-453f-b269-6ffbda8dc22e', 
 '7a2d5095-8a81-4fd6-8665-d916f42a9b4e', 
 '2024-05-15', '2024-05-20', '15 days', 'planned');

-- The error message is raised 'Cannot plan loan. Specimen is part of an exhibition during the requested loan period.'
-------------------------------------------------------------------------------------------------------------------
-- Try to plan a deal with the specimen that is on examination during the requested period

select * from specimen

-- try to plan a loan of The Starry Night from the 2nd of September if this specimen is on examination from 2024-09-01 to 2024-09-05

insert into loans_borrows (institution_id, specimen_id, started_at, return_date, duration, status)
values
('32b5c6e9-ff51-453f-b269-6ffbda8dc22e', 
 'b78c12c5-4353-426e-9bd8-17685e36b992', 
 '2024-09-02', '2024-12-01', '15 days', 'planned');

-- The error message is raised 'Cannot plan loan. Specimen is on examination during the requested loan period.'

----------------------------------------------------------------------------------------------------------------------
-- Try to plan a loan with a specimen that is olready has planned loan

select * from loans_borrows
select * from institutions

-- trying to make a deal on 'The Scream' painting to another institution if i already have planned deal with this artefact

insert into loans_borrows (institution_id, specimen_id, started_at, return_date, duration, status)
values
('d1f13ffd-dbae-4eed-b51b-7b2332a414d6', 
 '6609e083-03d9-4c10-bed7-38d759d79a08', 
 '2024-09-02', '2024-12-01', '15 days', 'planned');
 
-- The error message is raised 'Cannot plan loan. Specimen is already on loan during the requested period.'

-----------------------------------------------------------------------------------------------------------------------------------
