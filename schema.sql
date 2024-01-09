-- create database architecture of Splatoon 3 weapons

-- no need for a class table because it would only contain class name

-- contains season data
-- connects to main, sub and special tables and version table
CREATE TABLE IF NOT EXISTS "season"(
    "id" INTEGER
    , "name" TEXT NOT NULL
    , "year" INTEGER NOT NULL
    , "number" INTEGER NOT NULL
    , PRIMARY KEY("id")
);

-- contains version data
-- connects to season table
CREATE TABLE IF NOT EXISTS "game_version"(
    "id" INTEGER
    , "season_id" INTEGER
    , "number" TEXT NOT NULL -- formatted like '1.0.0' so can't be stored as INTEGER, FLOAT or REAL
    , "release" DATE
    , "notes" TEXT
    , PRIMARY KEY("id")
    , FOREIGN KEY("season_id") REFERENCES "season"("id")
);

-- contains main weapon data
-- connects to sub and special tables, season table
CREATE TABLE IF NOT EXISTS "main"(
    "id" INTEGER
    , "season_id" INTEGER
    , "sub_id" INTEGER
    , "special_id" INTEGER
    , "name" TEXT NOT NULL -- base name of weapon type
    , "level" INTEGER NOT NULL -- player level required to purchase weapon
    , "special_charge" INTEGER NOT NULL
    , "class" TEXT NOT NULL CHECK(
        "class" IN ("Blaster", "Brella", "Brush", "Charger", "Dualie", 
        "Roller", "Shooter", "Slosher", "Splatana", "Splatling", "Stringer")
        )
    , PRIMARY KEY("id") 
    , FOREIGN KEY("season_id") REFERENCES "season"("id")
    , FOREIGN KEY("sub_id") REFERENCES "sub"("id")
    , FOREIGN KEY("special_id") REFERENCES "special"("id")
);

-- contains sub weapon data
-- connects to main table
CREATE TABLE IF NOT EXISTS "sub"(
    "id" INTEGER
    , "season_id" INTEGER
    , "name" TEXT NOT NULL
    , PRIMARY KEY("id")
    , FOREIGN KEY("season_id") REFERENCES "season"("id")
);

-- contains special data
-- connects to main table
CREATE TABLE IF NOT EXISTS "special"(
    "id" INTEGER
    , "season_id" INTEGER
    , "name" TEXT NOT NULL
    , PRIMARY KEY("id")
    , FOREIGN KEY("season_id") REFERENCES "season"("id")
);



-- Views

-- number of main weapons in each class
CREATE VIEW IF NOT EXISTS "class_count" AS 
    SELECT "class", COUNT(id) AS "number_of_weapons"
    FROM "main"
    GROUP BY "class"
    ORDER BY "number_of_weapons" DESC;

-- lowest special charge for each class
CREATE VIEW IF NOT EXISTS "special_efficiency" AS
    -- Blaster
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Blaster" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Blaster")
    UNION
    -- Brella
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Brella" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Brella")
    UNION
    -- Brush
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Brush" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Brush")
    UNION
    -- Charger
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Charger" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Charger")
    UNION
    -- Dualie
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Dualie" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Dualie")
    UNION
    -- Roller
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Roller" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Roller")
    UNION
    -- Shooter
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Shooter" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Shooter")
    UNION
    -- Slosher
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Slosher" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Slosher")
    UNION
    -- Splatana
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Splatana" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Splatana")
    UNION
    -- Splatling
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Splatling" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Splatling")
    UNION
    -- Stringer
    SELECT "main"."class" AS "class", "main"."name" AS "main_weapon", "special"."name" AS "special", "main"."special_charge" AS "special_charge"
    FROM "main"
    JOIN "special" ON "main"."special_id" = "special"."id"
    WHERE "main"."class" = "Stringer" AND "main"."special_charge" = (SELECT MIN("special_charge") FROM "main" WHERE "class" = "Stringer")

    ORDER BY "special_charge", "special" ASC;


-- patch notes form latest update (provide all patch notes within the current season)
CREATE VIEW IF NOT EXISTS "current_season_patch_notes" AS
    SELECT "number" AS "version", "release" AS "release_date", "notes" AS "patch_notes"
    FROM "game_version"
    WHERE SUBSTR("number", 1, 1) = (
        SELECT MAX(SUBSTR("number", 1, 1)) FROM "game_version"
    )
    ORDER BY "version" ASC;