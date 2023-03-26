WITH Rutetabell AS (
    SELECT R.togrute_ID, S.*, R.ankomsttid, R.avgangstid
    FROM Stasjon S
    INNER join (SELECT SS.togrute_ID, SS.stasjon_ID, NULL as ankomsttid, SS.avgangstid
        FROM StartStasjon SS
        UNION
        SELECT MS.togrute_ID, MS.stasjon_ID, MS.ankomsttid, MS.avgangstid
        FROM MellomStasjon MS
        UNION
        SELECT ES.togrute_ID, ES.stasjon_ID, ES.ankomsttid, NULL as avgangstid
        FROM Endestasjon ES
    ) R ON R.stasjon_ID = S.stasjon_ID
    WHERE S.stasjon_ID = ?1 OR S.stasjon_ID = ?2
)
SELECT RS.togrute_ID, RS.stasjon_navn, RE.stasjon_navn, RS.avgangstid, RE.ankomsttid
FROM Rutetabell RS
LEFT OUTER JOIN Rutetabell RE ON RE.togrute_ID = RS.togrute_ID
INNER JOIN Togrute TR ON TR.rute_ID = RS.togrute_ID
WHERE RS.stasjon_ID = ?1
  AND RE.stasjon_ID = ?2
  AND RS.avgangstid IS NOT NULL
  AND RE.ankomsttid IS NOT NULL
  AND ((TR.hovedretning = 'true' AND RS.stasjon_ID < RE.stasjon_ID) OR
       (TR.hovedretning = 'false' AND RE.stasjon_ID < RS.stasjon_ID));