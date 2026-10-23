-- 1. Create the schema if it does not exist.
CREATE DATABASE IF NOT EXISTS mysql_shorts;

-- 2. Switch to the schema.
USE mysql_shorts;

-- 3. Create the ticket table with priorities in a declared ENUM order.
CREATE TABLE field_ticket (
    id INT UNSIGNED NOT NULL,
    subject VARCHAR(80) NOT NULL,
    priority ENUM(
        'Coffee Emergency',
        'House on Fire',
        'Mild Inconvenience',
        'Slight Annoyance'
    ) NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_bin;

-- 4. Add tickets with different priorities.
INSERT INTO field_ticket (id, subject, priority)
VALUES
    (1, 'Button is one pixel off', 'Slight Annoyance'),
    (2, 'Production server is smoking', 'House on Fire'),
    (3, 'Coffee machine only makes decaf', 'Coffee Emergency'),
    (4, 'Report needs an extra click', 'Mild Inconvenience'),
    (5, 'Backup server also smoking', 'House on Fire'),
    (6, 'Someone finished the coffee', 'Coffee Emergency');

-- 5. Show tickets sorted by the declared ENUM order.
SELECT id, 
       subject, 
       priority
FROM field_ticket
ORDER BY priority, id;

-- 6. Show tickets sorted by the preferred urgency order using FIELD().
SELECT
    id,
    subject,
    priority
FROM field_ticket
ORDER BY FIELD(
        priority,
        'House on Fire',
        'Coffee Emergency',
        'Mild Inconvenience',
        'Slight Annoyance'
    ), id;
