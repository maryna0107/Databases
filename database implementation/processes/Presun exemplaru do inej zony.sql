--------Presun exemplaru do inej zony-----------------------------
select * from exhibitions_zones

-- updating specimen The starry night that is currently on exhibition 'Oil paintings' in 'Zone B' into 'Zone C' 

update exhibitions_zones 
set zone_name = 'Zone C'
where id = 'a12dc263-6791-42b0-8101-ffbb48420b27'