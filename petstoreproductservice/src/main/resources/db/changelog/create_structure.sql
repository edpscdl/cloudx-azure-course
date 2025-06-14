drop table petstoredb.public.category CASCADE;
drop table petstoredb.public.tag CASCADE;
drop table petstoredb.public.product CASCADE;
drop table petstoredb.public.product_tag CASCADE;

create table petstoredb.public.category
(
    id                bigserial     not null primary key,
    name              varchar(64)   not null unique
);

create table petstoredb.public.tag
(
    id                bigserial     not null primary key,
    name              varchar(64)   not null unique
);

create table petstoredb.public.product
(
    id                bigserial     not null primary key,
    name              varchar(64)   not null unique,
    category_id       bigserial     not null,
    photoURL          varchar(255)  not null,
    status            varchar(64)   not null,
    constraint fk_category foreign key (category_id) references category(id)
);

create table petstoredb.public.product_tag
(
    product_id        bigserial     not null references product (id) on delete cascade,
    tag_id            bigserial     not null references tag (id) on delete cascade,
    constraint product_tag_pkey primary key (product_id, tag_id)
);
