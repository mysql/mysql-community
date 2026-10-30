-- 1. Create the schema if it does not exist.
CREATE DATABASE IF NOT EXISTS mysql_shorts;

-- 2. Switch to the schema.
USE mysql_shorts;

-- 3. Remove the demo tables before recreating them.

DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS agent;

-- 4. Create the related tables.
CREATE TABLE agent (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE ticket (
    id INT PRIMARY KEY,
    subject VARCHAR(100) NOT NULL,
    agent_id INT NULL,
    INDEX agent_id (agent_id),
    CONSTRAINT agent_id_agent_id
        FOREIGN KEY (agent_id)
        REFERENCES agent (id)
) ENGINE = InnoDB;

-- 5. Add the agents.
INSERT INTO agent (id, name)
VALUES
    (10, 'Alex'),
    (20, 'Sam');

-- 6. Add tickets with assigned and unassigned agents.
INSERT INTO ticket (id, subject, agent_id)
VALUES
    (1, 'Password reset', 10),
    (2, 'Invoice question', 20),
    (3, 'Login error', NULL),
    (4, 'Export request', NULL),
    (5, 'Billing address', 20),
    (6, 'Account access', 10);

-- 7. Compare ordinary equality with NULL-safe equality.
SELECT
    NULL = NULL AS test_1,
    NULL <=> NULL AS test_2;

-- 8. Show tickets for a specific agent using ordinary equality.
SET @selected_agent_id = 20;

SELECT id, subject, agent_id
FROM ticket
WHERE agent_id = @selected_agent_id
ORDER BY id;

-- 9. Show that ordinary equality does not match NULL to NULL.
SET @selected_agent_id = NULL;

SELECT id, subject, agent_id
FROM ticket
WHERE agent_id = @selected_agent_id
ORDER BY id;

-- 10. Show unassigned tickets using NULL-safe equality.
SELECT id, subject, agent_id
FROM ticket
WHERE agent_id <=> @selected_agent_id
ORDER BY id;

-- 11. Show tickets for a specific agent using NULL-safe equality.
SET @selected_agent_id = 20;

SELECT id, subject, agent_id
FROM ticket
WHERE agent_id <=> @selected_agent_id
ORDER BY id;
