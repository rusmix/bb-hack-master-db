BEGIN;
SET SEARCH_PATH to main;

CREATE TABLE providers (
    provider_id BIGSERIAL PRIMARY KEY,
    label VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE providers_countries (
    provider_id BIGINT REFERENCES providers(provider_id),
    country CHAR(2) NOT NULL,
    PRIMARY KEY (provider_id, country)
);

-- Enum for volatility
CREATE TYPE volatility_type AS ENUM ('low', 'mid', 'mid-high', 'high', 'mid-low');

CREATE TABLE games (
    game_id BIGSERIAL PRIMARY KEY,
    provider_id BIGINT REFERENCES providers(provider_id),
    label VARCHAR(255) NOT NULL,
    config JSON,
    scatter BOOLEAN,
    bonus_game BOOLEAN,
    bonus_game_purchase BOOLEAN,
    free_spins BOOLEAN,
    wild_symbol BOOLEAN,
    wild_multiplier BOOLEAN,
    gamble_feature BOOLEAN,
    auto_play BOOLEAN,
    rtp_percentage FLOAT,
    volatility volatility_type,
    max_win_multiplier FLOAT,
    min_bet FLOAT,
    max_bet FLOAT,
    coins_per_line INT,
    number_of_reels INT,
    number_of_lines INT
);


-- Custom ENUM types need to be created before creating the tables that use them
CREATE TYPE VOLATILITY_LEVEL AS ENUM ('low', 'mid', 'high');
CREATE TYPE GAME_STATE AS ENUM ('enabled', 'disabled');
CREATE TYPE TRANSACTION_TYPE AS ENUM ('bet_in', 'bet_out');

CREATE TABLE tags (
    tag_id BIGSERIAL PRIMARY KEY,
    label VARCHAR(255) UNIQUE NOT NULL,
    l10n JSON
);

CREATE TABLE games_tags (
    game_id BIGINT REFERENCES games(game_id),
    tag_id BIGINT REFERENCES tags(tag_id),
    PRIMARY KEY (game_id, tag_id)
);

CREATE TABLE themes (
    theme_id BIGSERIAL PRIMARY KEY,
    label VARCHAR(255) UNIQUE NOT NULL,
    l10n JSON
);

CREATE TABLE games_themes (
    game_id BIGINT REFERENCES games(game_id),
    theme_id BIGINT REFERENCES themes(theme_id),
    PRIMARY KEY (game_id, theme_id)
);

CREATE TABLE partners (
    partner_id BIGSERIAL PRIMARY KEY,
    label VARCHAR(255) NOT NULL
);

CREATE TABLE partner_games (
    partner_id BIGINT REFERENCES partners(partner_id),
    game_id BIGINT REFERENCES games(game_id),
    external_game_id BIGINT,
    img_src VARCHAR,
    game_href VARCHAR,
    state GAME_STATE DEFAULT 'enabled'::GAME_STATE,
    PRIMARY KEY (partner_id, game_id, external_game_id)
);

CREATE TABLE gamblers (
    gambler_id BIGSERIAL PRIMARY KEY,
    country CHAR(2) NOT NULL,
    locale CHAR(2) NOT NULL,
    partner_id BIGINT REFERENCES partners(partner_id)
);

CREATE TABLE gamblers_transactions (
    transaction_id BIGSERIAL PRIMARY KEY,
    gambler_id BIGINT REFERENCES gamblers(gambler_id),
    partner_id BIGINT REFERENCES partners(partner_id),
    game_id BIGINT,
    external_game_id BIGINT,
    type TRANSACTION_TYPE,
    usd_amount FLOAT,
    end_datetime TIMESTAMP WITHOUT TIME ZONE,
    FOREIGN KEY (partner_id, game_id, external_game_id) REFERENCES partner_games(partner_id, game_id, external_game_id)
);


COMMIT;



BEGIN;
SET SEARCH_PATH to main;

INSERT INTO partners (partner_id, label)
VALUES (1, 'Test Partner');

INSERT INTO gamblers (gambler_id, country, locale, partner_id)
VALUES
(1, 'US', 'EN', 1),
(2, 'CA', 'EN', 1),
(3, 'GB', 'EN', 1),
(4, 'FR', 'FR', 1),
(5, 'DE', 'DE', 1),
(6, 'JP', 'JP', 1),
(7, 'CN', 'CN', 1),
(8, 'IN', 'HI', 1),
(9, 'BR', 'PT', 1),
(10, 'MX', 'ES', 1);

COMMIT;
