/*Queries that provide answers to the questions from all projects.*/

 SELECT * FROM animals WHERE name LIKE '%mon%';
 SELECT name FROM animals WHERE date_of_birth>= '2016-01-01' AND date_of_birth<= '2019-12-31';
 SELECT name FROM animals WHERE neutered IS TRUE AND escape_attempts<3;
 SELECT date_of_birth FROM animals WHERE name='Agumon' OR name='Pikachu';
 SELECT name,escape_attempts FROM animals WHERE weight_kg<10.5;
 SELECT * FROM animals WHERE neutered IS TRUE;
 SELECT * FROM animals WHERE name!='Gabumon';
 SELECT name,escape_attempts FROM animals WHERE weight_kg>10.5;

BEGIN;
UPDATE animals
SET
species = 'unspecified'
WHERE
id>0;
ROLLBACK;

BEGIN;
UPDATE animals
SET
species='digimon'
WHERE
name LIKE '%mon%';
UPDATE animals
SET
species='pokemon'
WHERE
species IS NULL;
COMMIT;
SELECT * FROM animals; /*To verify the changes*/

BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals; /*To verify the changes*/

BEGIN;
DELETE FROM animals
WHERE date_of_birth>'2022-01-01';
SAVEPOINT SP1;
UPDATE animals
SET
weight_kg = weight_kg*-1;
ROLLBACK TO SP1;
UPDATE animals
SET
weight_kg = weight_kg*-1
WHERE
weight_kg<0;
COMMIT;

/*How many animals are there?*/
SELECT COUNT(*) FROM animals;

/*How many animals have never tried to escape?*/
SELECT COUNT(*) FROM animals
WHERE escape_attempts=0;

/*What is the average weight of animals?*/
SELECT AVG(weight_kg) FROM animals;

/*Who escapes the most, neutered or not neutered animals?*/
SELECT neutered,MAX(escape_attempts) as max_escapes FROM animals
GROUP BY neutered;

/*What is the minimum and maximum weight of each type of animal?*/
SELECT species,MAX(weight_kg),MIN(weight_kg) FROM animals
GROUP BY species;

/*What is the average number of escape attempts per animal type of those born between 1990 and 2000?*/
SELECT species, AVG(escape_attempts) as avg_escapes FROM animals
WHERE date_of_birth>='1990-01-01' AND date_of_birth<='2000-12-31'
GROUP BY species;

-- What animals belong to Melody Pond?
SELECT name FROM animals AS a
JOIN owners AS o ON o.id = a.owner_id
WHERE o.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon)
SELECT a.name FROM animals AS a
JOIN species AS s ON s.id = a.species_id
WHERE s.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT a.name, o.full_name FROM animals AS a
RIGHT JOIN owners AS o
ON a.owner_id=o.id;

-- How many animals are there per species?
SELECT s.name, COUNT(*) FROM animals AS a
LEFT JOIN species AS s
ON a.species_id = s.species.id
GROUP BY s.name

-- List all Digimon owned by Jennifer Orwell.
SELECT a.name FROM animals AS a
JOIN owners AS o
ON a.owner_id=o.id
JOIN species AS s
ON a.species_id=s.id
WHERE o.full_name='Jennifer Orwell' AND s.name='Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name FROM animals AS a
JOIN owners AS o
ON a.owner_id=o.id
WHERE a.escape_attempts=0 AND o.full_name='Dean Winchester';

-- Who owns the most animals?
SELECT o.full_name FROM owners AS o
JOIN animals AS a
ON o.id=a.owner_id
GROUP BY o.full_name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher? 
SELECT a.name AS last_visited FROM vets AS v
JOIN visits AS vi
ON v.id=vi.vets_id
JOIN animals AS a
ON a.id=vi.animals_id
WHERE v.name='William Tatcher'
ORDER BY vi.date_of_vist DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see? 
SELECT COUNT(a.name) FROM visits
JOIN vets AS v
ON visits.vets_id=v.id
JOIN animals AS a
ON visits.animals_id=a.id
WHERE v.name='Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties. 
SELECT v.name, sp.name FROM vets AS v
JOIN specializations AS s
ON v.id=s.vets_id
JOIN species AS sp
ON s.species_id=sp.id

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. 
SELECT a.name FROM visits AS vi
JOIN animals AS a
ON vi.animals_id=a.id
JOIN vets AS v
ON vi.vets_id=v.id
WHERE date_of_vist>='2020-04-01' AND date_of_vist<='2020-08-30' AND v.name='Stephanie Mendez';

-- What animal has the most visits to vets? 
SELECT a.name, COUNT(vi.date_of_vist) AS number_of_visits
FROM visits AS vi
JOIN animals AS a
ON vi.animals_id=a.id
GROUP BY a.name
ORDER BY number_of_visits DESC
LIMIT 1;

-- Who was Maisy Smith's first visit? 
SELECT a.name AS first_visit,vi.date_of_vist 
FROM visits AS vi
JOIN animals AS a
On vi.animals_id=a.id
JOIN vets AS v
On vi.vets_id=v.id
WHERE v.name='Maisy Smith'
ORDER BY vi.date_of_vist ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit. 
SELECT a.name, a.date_of_birth, a.escape_attempts, a.neutered, a.weight_kg, v.name, v.age, v.date_of_graduation, vi.date_of_vist FROM animals AS a
JOIN visits AS vi
ON a.id=vi.animals_id
JOIN vets AS v
On vi.vets_id=v.id
ORDER BY vi.date_of_vist DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species? 
SELECT COUNT(*) AS visits
FROM (
SELECT sp.species_id AS vetsp, v.name, vi.date_of_vist, a.species_id AS animal_special FROM vets AS v
LEFT JOIN specializations AS sp
ON v.id = sp.vets_id
JOIN visits AS vi
ON vi.vets_id = v.id
JOIN animals AS a
ON vi.animals_id = a.id
WHERE (sp.species_id<>a.species_id OR sp.species_id IS NULL)
) visits;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most. 
SELECT sp.name, COUNT(sp.name) AS speciality
FROM vets AS v
JOIN visits AS vi
On v.id=vi.vets_id
JOIN animals AS a
On vi.animals_id=a.id
JOIN species AS sp
ON a.species_id=sp.id
WHERE v.name='Maisy Smith'
GROUP BY sp.name
ORDER BY speciality DESC
LIMIT 1;