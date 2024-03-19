BEGIN;
SET SEARCH_PATH to main;



DROP TABLE if exists main.gamblers_transactions;

CREATE TABLE main.gamblers_transactions (
  gambler_id int8 NULL,
  external_game_id int8 NULL,
  bet_cnt int8 NULL,
  usd_value int8 NULL,
  start_time timestamp NULL,
  end_time timestamp NULL,
  "time" float8 NULL
);


DROP TABLE if exists main.games;

CREATE TABLE main.games (
  theme_id int8 NULL,
  tag_id int8 NULL,
  game_id int8 NULL,
  provider_id int8 NULL,
  partner_id float8 NULL,
  country text NULL
);


DROP TABLE if exists main.gamblers_preference;

CREATE TABLE main.gamblers_preference (
  external_game_id int8 NULL,
  gambler_id int8 NULL,
  value float8 NULL
);


DROP TABLE if exists main.gamblers_clicks;

CREATE TABLE main.gamblers_clicks (
  gambler_id int8 NULL,
  partner_id int8 NULL,
  external_game_id int8 NULL,
  "action" public.gambler_action NULL,
  end_datetime timestamptz NOT NULL DEFAULT now()
);


DROP TABLE if exists main.df_agg;

CREATE TABLE main.df_agg (
  gambler_id int8 NULL,
  external_game_id int8 NULL,
  bet_cnt int8 NULL,
  usd_value int8 NULL,
  start_time timestamp NULL,
  end_time timestamp NULL,
  "time" float8 NULL
);


commit;
