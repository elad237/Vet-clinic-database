/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id              INT GENERATED ALWAYS AS IDENTITY,
    name            VARCHAR(250),
    date_of_birth   DATE,
    escape_attempts INT,
    neutered        BOOLEAN,
    weight_kg       DECIMAL,
    PRIMARY KEY(id)
);

ALTER TABLE animals ADD COLUMN species VARCHAR(250);

CREATE TABLE owners(
	id			INT GENERATED ALWAYS AS IDENTITY,
	full_name	VARCHAR(250),
	age			INT
);

CREATE TABLE species(
	id			INT GENERATED ALWAYS AS IDENTITY,
	name		VARCHAR(250)
);

ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE species ADD CONSTRAINT uniq_species_id_constraint PRIMARY KEY(id);
ALTER TABLE animals
ADD CONSTRAINT fk_species
FOREIGN KEY (species_id)
REFERENCES species(id)
ON DELETE CASCADE;

ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE owners ADD CONSTRAINT uniq_owner_id_constraint PRIMARY KEY(id);
ALTER TABLE animals
ADD CONSTRAINT fk_owners
FOREIGN KEY (owner_id)
REFERENCES owners(id)
ON DELETE CASCADE;