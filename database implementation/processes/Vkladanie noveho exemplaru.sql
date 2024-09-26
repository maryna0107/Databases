----------Vkladanie noveho exemplaru----------------------------

INSERT INTO Specimen (name, description, status)
VALUES 
    ('David', 'David is a masterpiece of Italian Renaissance sculpture, created from 1501 to 1504 by Michelangelo. With a height of 5.17 metres (17 ft 0 in), the David was the first colossal marble statue made in the early modern period following classical antiquity', 'own');
	
	
select * from specimen;
select * from categories;
		
Insert into Specimen_Categories(specimenid, categoriesid)
values('ace2fe3b-642e-403c-831b-ee5c318d3ed4', 'c3a576f1-d835-4395-97ab-31a0335c86e5');