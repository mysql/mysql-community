-- 1. Create the schema.
CREATE SCHEMA mysql_shorts;

-- 2. Switch to the schema.
USE mysql_shorts;

-- 3. Return the first non-NULL value using COALESCE().
SELECT COALESCE(NULL, NULL, 'Scott') AS player_name;

-- 4. Create the related tables.
CREATE TABLE player (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE game_result (
    id INT PRIMARY KEY,
    player_id INT NOT NULL,
    sub_id INT NULL,
    score INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES player(id),
    FOREIGN KEY (sub_id) REFERENCES player(id)
);

-- 5. Add the players.
INSERT INTO player (id, name) VALUES
    (1, 'Scott'),
    (2, 'Lenka'),
    (3, 'Lilly'),
    (4, 'Kailas'),
    (5, 'Henrik'),
    (6, 'Heather'),
    (7, 'Miguel'),
    (8, 'Gopal');

-- 6. Add game results with optional substitute players.
INSERT INTO game_result (id, player_id, sub_id, score)
VALUES
    (101, 1, NULL, 42), -- Scott played
    (102, 2, 3,    39), -- Lilly substituted for Lenka
    (103, 4, NULL, 44), -- Kailas played
    (104, 5, 6,    41), -- Heather substituted for Henrik
    (105, 7, NULL, 38), -- Miguel played
    (106, 2, NULL, 43), -- Lenka played
    (107, 1, 8,    40), -- Gopal substituted for Scott
    (108, 5, NULL, 45), -- Henrik played
    (109, 4, 3,    37), -- Lilly substituted for Kailas
    (110, 7, NULL, 41); -- Miguel played

-- 7. Show the player who played using COALESCE().
SELECT
    id AS game_id,
    player_id as scheduled_player,
    COALESCE(sub_id, player_id) AS player_who_played,
    score
FROM game_result
ORDER BY id;

-- 8. Show the assigned and actual player names using joins.
SELECT
    r.id AS game_id,
    assigned.name AS assigned_player,
    played.name AS player_who_played,
    r.score
FROM game_result AS r
JOIN player AS assigned
    ON assigned.id = r.player_id
JOIN player AS played
    ON played.id = COALESCE(r.sub_id, r.player_id)
ORDER BY r.id;
