/* Database schema to keep the structure of entire database. */

 CREATE TABLE animals(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(25)
    date_of_birth DATE
    escape_attempts INT
    neutered BOOLEAN
    weight_kg DECIMAL
 );

 ALTER TABLE animals
 ADD COLUMN species VARCHAR(30);

 /*Owners Table*/
 CREATE TABLE owners(
   id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   full_name VARCHAR(30),
    age INT);

/*Species Table*/
CREATE TABLE species(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name VARCHAR(30));

/*Alter animals table*/
ALTER TABLE animals
DROP COLUMN species

ALTER TABLE animals
ADD COLUMN species_id INT;

ALTER TABLE animals
ADD CONSTRAINT animal_specie
FOREIGN KEY (species_id)
REFERENCES species(id);

ALTER TABLE animals
ADD COLUMN owner_id INT;

ALTER TABLE animals
ADD CONSTRAINT animal_owner
FOREIGN KEY (owner_id)
REFERENCES owners(id);