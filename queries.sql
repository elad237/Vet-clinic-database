/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered IS true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered IS true;
SELECT * FROM animals WHERE name NOT LIKE 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;
  UPDATE animals
  SET species = 'unspecified';
  SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;

-- How many animals are there?
SELECT COUNT(id) FROM animals;
-- How many animals have never tried to escape?
SELECT COUNT(id) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;
-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

-- What animals belong to Melody Pond?
SELECT A.name 
FROM animals A
JOIN owners O 
ON A.owner_id = O.id AND O.full_name = 'Melody Pond';
-- List of all animals that are pokemon (their type is Pokemon).
SELECT A.name, S.name
FROM animals A
JOIN species S
ON A.species_id = S.id AND S.name = 'Pokemon';
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT O.full_name, A.name
FROM owners O
LEFT JOIN animals A
ON A.owner_id = O.id;
-- How many animals are there per species?
SELECT S.name, COUNT(A.id)
FROM animals A
JOIN species S
ON A.species_id = S.id 
GROUP BY S.name;
-- List all Digimon owned by Jennifer Orwell.
SELECT A.name
FROM animals A
JOIN owners O
ON A.owner_id = O.id AND O.full_name = 'Jennifer Orwell'
JOIN species S
ON S.id = A.species_id AND s.name = 'Digimon';
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT A.name
FROM animals A
JOIN owners O
ON A.owner_id = O.id 
AND O.full_name = 'Dean Winchester'
AND escape_attempts = 0;
-- Who owns the most animals?
SELECT O.full_name, COUNT(A.id)
FROM animals A
JOIN owners O
ON A.owner_id = O.id
GROUP BY O.full_name
ORDER BY COUNT(A.id) DESC
LIMIT 1;

-- Write queries to answer the following:

-- Who was the last animal seen by William Tatcher?
SELECT vets.name, animals.name, visits.visit_date
FROM visits
JOIN animals
ON visits.animals_id = animals.id
JOIN vets
ON visits.vets_id = vets.id AND vets.name = 'William Tatcher'
ORDER BY visits.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(animals.id)
FROM visits
JOIN animals
ON visits.animals_id = animals.id
JOIN vets
ON visits.vets_id = vets.id AND vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name
FROM vets
LEFT JOIN specializations
ON specializations.vets_id = vets.id
LEFT JOIN species
ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT vets.name, animals.name, visits.visit_date
FROM visits
JOIN animals
ON visits.animals_id = animals.id
JOIN vets
ON visits.vets_id = vets.id AND vets.name = 'Stephanie Mendez'
WHERE visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.name, COUNT(id)
FROM visits
JOIN animals
ON visits.animals_id = animals.id
GROUP BY animals.name
ORDER BY COUNT(id) DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT vets.name, animals.name, visits.visit_date
FROM visits
JOIN animals
ON visits.animals_id = animals.id
JOIN vets
ON visits.vets_id = vets.id AND vets.name = 'Maisy Smith'
ORDER BY visits.visit_date ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT visits.visit_date, animals.name, vets.name
FROM visits
JOIN animals
ON visits.animals_id = animals.id
JOIN vets
ON visits.vets_id = vets.id
ORDER BY visits.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits
JOIN animals
ON visits.animals_id = animals.id
JOIN species
ON animals.species_id = species.id
JOIN vets
ON visits.vets_id = vets.id
LEFT JOIN specializations
ON specializations.vets_id = vets.id
WHERE specializations.species_id != animals.species_id OR specializations.species_id IS NULL;


-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name, COUNT(species.name)
FROM visits
JOIN vets
ON visits.vets_id = vets.id AND vets.name = 'Maisy Smith'
JOIN animals
ON visits.animals_id = animals.id
JOIN species
ON animals.species_id = species.id
GROUP BY(species.name)
ORDER BY COUNT(species.name) DESC
LIMIT 1;
