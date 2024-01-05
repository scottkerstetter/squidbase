/****** process and insert input data ******/

-- load data from csv
.import --csv splatoon3weapons.csv temp
.import --csv splatoon3updates.csv updates



/****** clean loaded data ******/
-- clean temp table
-- remove p char from special points and convert to INTEGER
UPDATE "temp" SET "special points" = SUBSTR("special points", 1, 3);
UPDATE "temp" SET "special points" = CAST("special points" AS INTEGER);
-- get version number with substring
ALTER TABLE "temp" ADD "version";
ALTER TABLE "temp" ADD "year";
ALTER TABLE "temp" ADD "season_name";
-- extract game version
UPDATE "temp" SET "version" = SUBSTR("introduced", 9, 5);
-- extract year and cast as INTEGER
UPDATE "temp" SET "year" = SUBSTR("introduced", INSTR("introduced", '20'), 4);
UPDATE "temp" SET "year" = CAST("year" AS INTEGER);
-- extract season name
UPDATE "temp" SET "season_name" = SUBSTR(
    "introduced"
    , INSTR("introduced", '(') + 1
    , INSTR("introduced", '20') - INSTR("introduced", '(') - 2
    );
-- replace version 1.0.0 with 1.1.0 because the game launched at version 1.1.0
UPDATE "temp" SET "version" = '1.1.0' WHERE "version" = '1.0.0';

-- clean updates temp table
-- convert release as DATE
UPDATE "updates" SET "release" = DATE("release");
-- create temporary version_id that can be used to join with temp
ALTER TABLE "updates" ADD "version_id";
UPDATE "updates" SET "version_id" = SUBSTR("version",1,2) || '0.0';
UPDATE "updates" SET "version_id" = '1.1.0' WHERE "version_id" = '1.0.0';



/****** insert data into tables ******/
-- season table first
-- initially insert season.number as zero and update afterwards
INSERT INTO "season"("name", "year", "number")
    SELECT DISTINCT "season_name", "year", 0 FROM "temp";
UPDATE "season" SET "number" = 1 WHERE "year" = 2022 AND "name" LIKE 'drizzle%';
UPDATE "season" SET "number" = 2 WHERE "year" = 2022 AND "name" LIKE 'chill%';
UPDATE "season" SET "number" = 3 WHERE "year" = 2023 AND "name" LIKE 'fresh%';
UPDATE "season" SET "number" = 4 WHERE "year" = 2023 AND "name" LIKE 'sizzle%';
UPDATE "season" SET "number" = 5 WHERE "year" = 2023 AND "name" LIKE 'drizzle%';
UPDATE "season" SET "number" = 6 WHERE "year" = 2023 AND "name" LIKE 'chill%';

-- insert version info into game_version
INSERT INTO "game_version"("season_id", "number", "release", "notes")
    SELECT DISTINCT "season"."id", "updates"."version", "updates"."release", "updates"."notes"
    FROM "updates"
    JOIN "temp" ON "updates"."version_id" = "temp"."version"
    JOIN "season" ON "temp"."season_name" = "season"."name" AND "temp"."year" = "season"."year";



/****** drop temp tables ******/
DROP TABLE IF EXISTS "temp";
DROP TABLE IF EXISTS "updates";