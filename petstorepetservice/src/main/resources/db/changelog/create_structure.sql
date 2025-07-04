DROP TABLE IF EXISTS petstorepetservice_db.public.pet_tag CASCADE;
DROP TABLE IF EXISTS petstorepetservice_db.public.pet CASCADE;
DROP TABLE IF EXISTS petstorepetservice_db.public.tag CASCADE;
DROP TABLE IF EXISTS petstorepetservice_db.public.category CASCADE;

CREATE TABLE IF NOT EXISTS petstorepetservice_db.public.category
(
    id   BIGSERIAL   NOT NULL PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS petstorepetservice_db.public.tag
(
    id   BIGSERIAL   NOT NULL PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS petstorepetservice_db.public.pet
(
    id          BIGSERIAL    NOT NULL PRIMARY KEY,
    name        VARCHAR(64)  NOT NULL UNIQUE,
    category_id BIGSERIAL    NOT NULL,
    photoURL    VARCHAR(255) NOT NULL,
    status      VARCHAR(64)  NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category (id)
);

CREATE TABLE IF NOT EXISTS petstorepetservice_db.public.pet_tag
(
    pet_id BIGSERIAL NOT NULL REFERENCES pet (id) ON DELETE CASCADE,
    tag_id BIGSERIAL NOT NULL REFERENCES tag (id) ON DELETE CASCADE,
    CONSTRAINT pet_tag_pkey PRIMARY KEY (pet_id, tag_id)
);
