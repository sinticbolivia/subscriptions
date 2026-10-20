create table tags(
    id                      serial primary key,
    name                    varchar(128),
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table tag2object(
    tag_id          bigint not null,
    object_id       bigint not null,
    object_type     varchar(256),
);
