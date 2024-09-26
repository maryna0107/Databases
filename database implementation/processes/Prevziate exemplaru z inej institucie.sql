
-----------Prevziate exemplaru z inej institucie--------------------------

select * from loans_borrows

update loans_borrows
set closed_date = '2024-12-24' --the date is used for illustrating the implemented scenatio
where id = 'ebaea508-3192-4c43-a0fe-ebb4fc8775f7';

update specimen
set location = 'on examination'
where id = '367006e2-a5e8-4e35-a082-56dae61b1e20';

insert into examinations (startdate, enddate, specimen_id)
values('2024-12-24', '2024-12-31', '367006e2-a5e8-4e35-a082-56dae61b1e20');
