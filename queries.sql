-- The following queries are taking too much time (1 sec = 1000ms can be considered as too much time for database query). Try them on your machine to confirm it:


SELECT COUNT(*) FROM visits where animal_id = 4;
SELECT * FROM visits where vet_id = 2;
SELECT * FROM owners where email = 'owner_18327@mail.com';