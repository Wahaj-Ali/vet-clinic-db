/* Database schema to keep the structure of entire database. */

 CREATE TABLE animals(
    id INT,
    name VARCHAR(25)
    date_of_birth DATE
    escape_attempts INT
    neutered BOOLEAN
    weight_kg DECIMAL
 );

 ALTER TABLE animals
 ADD COLUMN species VARCHAR(30);