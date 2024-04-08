create table subscriptions_plans(
  id                      serial primary key,
  application_id          bigint,
  product_id              bigint,
  name                    varchar(256),
  description             text,
  price                   numeric(20,5),
  data                    JSONB,
  status                  varchar(32),
  last_modification_date  timestamp,
  creation_date           timestamp
);
create table subscriptions_types(
    id                      serial primary key,
    name                    varchar(128),
    description             text,
    status                  varchar(32),
    discount                numeric(10,2),
    days                    integer,
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table subscriptions_customer_plans(
  id                      serial primary key,
  plan_id                 bigint not null,
  customer_id             bigint not null,
  type_id                   bigint not null,
  user_id                 bigint not null,
  status                  varchar(32),
  init_date               timestamp,
  end_date                timestamp,
  notes                     text,
  last_modification_date  timestamp,
  creation_date           timestamp
);
create table subscriptions_payments(
  id                      serial primary key,
  user_plan_id            bigint not null,
  payment_method          varchar(32),
  amount_paid             numeric(20,5),
  payment_type              varchar(64),
  last_modification_date  timestamp,
  creation_date           timestamp
);
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO jerry;
-- grant all privileges on schema public to devudb;
-- grant all privileges on ALL SEQUENCES in schema public to devudb;
-- grant all privileges on ALL FUNCTIONS in schema public to devudb;
