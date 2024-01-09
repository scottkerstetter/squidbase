SELECT "number" AS "version", "release" AS "release_date", "notes" AS "patch_notes"
FROM "game_version"
WHERE SUBSTR("number", 1, 1) = (
    SELECT MAX(SUBSTR("number", 1, 1)) FROM "game_version"
)
ORDER BY "version" ASC;