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
SELECT COUNT(*) as pokemon FROM animals AS a
JOIN species AS s
ON a.species_id=s.id
WHERE s.name='Pokemon';

SELECT COUNT(*) as digimon FROM animals AS a
JOIN species AS s
ON a.species_id=s.id
WHERE s.name='Digimon';

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