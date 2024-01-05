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
        "Roller", "Shooter", "Slosher", "Splatling", "Stringer")
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