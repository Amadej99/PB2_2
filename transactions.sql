-- 1
INSERT INTO FILM VALUES(4,'Film 4', 2001, '1:35:00', 7);
INSERT INTO JE_ZANRA VALUES(4,2),(4,3);
INSERT INTO IMA_REZISERJA VALUES(4,2);
INSERT INTO JE_V_JEZIKIH VALUES(4,1),(4,3);

-- 2
--INSERT INTO PREDSTAVA VALUES(4, 1, 1, '2023:10:11','20:00:00');
DELETE FROM PREDSTAVA
WHERE DATEDIFF(NOW(), DATUM) > 30;

-- 3
SELECT * FROM SEDEZ;
UPDATE SEDEZ
   SET AKTIVEN = FALSE
WHERE STEVILKA_SEDEZA = 102 
AND   STEVILKA_SEDEZA = 101;
-- 4
INSERT INTO PREDSTAVA VALUES(4,3,1,'2024-01-06','18:00:00');

-- 5
SELECT COUNT(*) FROM FILM;

-- 6
UPDATE FILM SET OCENA = 5 WHERE ID_FILMA=4;

-- 7
SELECT f.Naslov, p.Datum, p.Cas,d.Ime_dvorane, s.Vrsta, s.Stevilka_sedeza, k.Cena  FROM KARTA k
JOIN PREDSTAVA p ON k.ID_predstave = p.ID_predstave
JOIN SEDEZ s ON k.ID_sedeza = s.ID_sedeza
JOIN FILM f ON p.ID_filma = f.ID_filma
JOIN DVORANA d ON s.ID_dvorane = d.ID_dvorane;

-- 8 
SELECT j.ime_jezika, count(*) as Stevilo_FIlmov FROM FILM f
JOIN JE_V_JEZIKIH je ON f.ID_filma = je.ID_filma
JOIN JEZIK j ON je.ID_jezika = j.ID_jezika
GROUP BY j.ime_jezika;

-- 9
SELECT f.Naslov, count(*) as 'Stevilo prodanih kart' FROM FILM f
JOIN PREDSTAVA p ON f.ID_filma = p.ID_filma
JOIN KARTA k ON p.ID_predstave = k.ID_predstave
GROUP BY 1
ORDER BY 2 DESC;

-- 10

SELECT f.Naslov, 
       GROUP_CONCAT(DISTINCT j.Ime_jezika) AS Jeziki, 
       GROUP_CONCAT(DISTINCT z.Ime) AS Zanri, 
       p.Datum, 
       p.Cas, 
       d.Ime_dvorane
FROM PREDSTAVA p
JOIN FILM f ON p.ID_filma = f.ID_filma
JOIN JE_V_JEZIKIH je ON f.ID_filma = je.ID_filma
JOIN JEZIK j ON je.ID_jezika = j.ID_jezika
JOIN DVORANA d ON p.ID_dvorane = d.ID_dvorane
JOIN JE_ZANRA jz ON f.ID_filma = jz.ID_filma
JOIN ZANR z ON jz.ID_zanra = z.ID_zanra
GROUP BY f.Naslov, p.Datum, p.Cas, d.Ime_dvorane;
