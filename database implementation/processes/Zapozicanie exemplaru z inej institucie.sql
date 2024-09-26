-----------------Zapozicanie exemplaru z inej institucie----------------------------------
INSERT INTO Specimen (name, description, status)
VALUES 
    ('Girl with a Pearl Earring', 'Girl with a Pearl Earring is an oil painting by Dutch Golden Age painter Johannes Vermeer, dated c. 1665.', 'borrowed');
	
	
select * from specimen;
select * from categories;
		
Insert into Specimen_Categories(specimenid, categoriesid)
values('367006e2-a5e8-4e35-a082-56dae61b1e20', 'a9f52c83-dbf9-43de-96c5-120fcab499ed');


insert into loans_borrows (institution_id, specimen_id, started_at, return_date, duration, status)
values
('32b5c6e9-ff51-453f-b269-6ffbda8dc22e', 
 '367006e2-a5e8-4e35-a082-56dae61b1e20', 
 '2024-12-01', '2024-12-25', '15 days', 'planned');
