DROP TABLE IF EXISTS petstoreproductservice_db.public.product_tag CASCADE;
DROP TABLE IF EXISTS petstoreproductservice_db.public.product CASCADE;
DROP TABLE IF EXISTS petstoreproductservice_db.public.tag CASCADE;
DROP TABLE IF EXISTS petstoreproductservice_db.public.category CASCADE;

CREATE TABLE IF NOT EXISTS petstoreproductservice_db.public.category
(
    id   BIGSERIAL   NOT NULL PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS petstoreproductservice_db.public.tag
(
    id   BIGSERIAL   NOT NULL PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS petstoreproductservice_db.public.product
(
    id          BIGSERIAL    NOT NULL PRIMARY KEY,
    name        VARCHAR(64)  NOT NULL UNIQUE,
    category_id BIGSERIAL    NOT NULL,
    photoURL    VARCHAR(255) NOT NULL,
    status      VARCHAR(64)  NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category (id)
);

CREATE TABLE IF NOT EXISTS petstoreproductservice_db.public.product_tag
(
    product_id BIGSERIAL NOT NULL REFERENCES product (id) ON DELETE CASCADE,
    tag_id     BIGSERIAL NOT NULL REFERENCES tag (id) ON DELETE CASCADE,
    CONSTRAINT product_tag_pkey PRIMARY KEY (product_id, tag_id)
);