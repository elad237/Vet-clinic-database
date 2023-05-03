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

-- Create a table named vets with the following columns:
-- id: integer (set it as autoincremented PRIMARY KEY)
-- name: string
-- age: integer
-- date_of_graduation: date
CREATE TABLE vets(
    id                  INT GENERATED ALWAYS AS IDENTITY,
    name                VARCHAR(250),
    age                 INT,
    date_of_graduation  DATE
);

ALTER TABLE vets ADD CONSTRAINT uniq_vets_id_constraint PRIMARY KEY(id);

-- There is a many-to-many relationship between the tables species and vets: 
-- a vet can specialize in multiple species, and a species can have multiple 
-- vets specialized in it. Create a "join table" called specializations 
-- to handle this relationship.
CREATE TABLE specializations(
    species_id      INT,
    vets_id         INT.
    PRIMARY KEY (species_id, vets_id),
    CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id),
    CONSTRAINT fk_vets FOREIGN KEY(vets_id) REFERENCES vets(id)
);

-- There is a many-to-many relationship between the tables animals and vets: 
-- an animal can visit multiple vets and one vet can be visited by multiple 
-- animals. Create a "join table" called visits to handle this relationship, 
-- it should also keep track of the date of the visit.
CREATE TABLE visits(
    animals_id  INT,
    vets_id     INT,
    visit_date  DATE,
    PRIMARY KEY (animals_id, vets_id, visit_date),
    CONSTRAINT fk_animals FOREIGN KEY(animals_id) REFERENCES animals(id),
    CONSTRAINT fk_vets FOREIGN KEY(vets_id) REFERENCES vets(id)
);