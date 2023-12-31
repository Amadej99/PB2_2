CREATE VIEW IN_SPANISH AS
SELECT 
    F.ID_FILMA,
    F.NASLOV,
    F.LETO_IZDAJE,
    F.OCENA
FROM FILM F
INNER JOIN JE_V_JEZIKIH JJ ON F.ID_FILMA = JJ.ID_FILMA
INNER JOIN JEZIK J ON JZ.ID_JEZIKA = J.ID_JEZIKA
WHERE J.ID_JEZIKA = 3;

CREATE VIEW COMEDIES AS
SELECT 
    F.ID_FILMA,
    F.NASLOV,
    F.LETO_IZDAJE,
    F.OCENA
FROM FILM F
INNER JOIN JE_ZANRA JZ ON F.ID_FILMA = JZ.ID_FILMA
INNER JOIN ZANR Z ON JZ.ID_ZANRA = Z.ID_ZANRA
WHERE Z.ID_ZANRA = 3;