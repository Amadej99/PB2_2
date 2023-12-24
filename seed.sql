-- DVORANA table
INSERT INTO DVORANA (ID_DVORANE, IME_DVORANE, KAPACITETA)
VALUES
    (1, 'Dvorana A', 100),
    (2, 'Dvorana B', 120),
    (3, 'Dvorana C', 80);
    
-- ZANR table
INSERT INTO ZANR (ID_ZANRA, IME, OPIS_ZANRA)
VALUES
    (1, 'Drama', 'Opis žanra drame'),
    (2, 'Akcija', 'Opis žanra akcije'),
    (3, 'Komedija', 'Opis žanra komedije');

-- FILM table
INSERT INTO FILM (ID_FILMA, NASLOV, LETO_IZDAJE, DOLZINA, OCENA)
VALUES
    (1, 'Film 1', 2020, '02:15:00',4),
    (2, 'Film 2', 2018, '01:50:00',8),
    (3, 'Film 3', 2021, '02:30:00',6);
    
-- OSEBA table
INSERT INTO OSEBA (ID_OSEBE, IME, PRIIMEK, SPOL, DATUM_ROJSTVA)
VALUES
    (1, 'Janez', 'Novak', 'M', '1990-05-15'),
    (2, 'Ana', 'Kovač', 'Ž', '1985-12-10'),
    (3, 'Maja', 'Horvat', 'Ž', '1993-08-22');

-- IGRALEC table
INSERT INTO IGRALEC (ID_OSEBE, STEVILO_ODIGRANIH_FILMOV)
VALUES
    (1, 5);
    
-- REZISER table
INSERT INTO REZISER (ID_OSEBE, STEVILO_REZIRANIH_FILMOV)
VALUES
    (2, 6),
    (3, 2);

-- IMA_REZISERJA table
INSERT INTO IMA_REZISERJA (ID_FILMA, ID_OSEBE)
VALUES
    (1, 2),
    (2, 3),
    (3, 2);

-- JEZIK table
INSERT INTO JEZIK (ID_JEZIKA, IME_JEZIKA, DRZAVA_IZVORA)
VALUES
    (1, 'Slovenščina', 'Slovenija'),
    (2, 'Angleščina', 'Združeno kraljestvo'),
    (3, 'Španščina', 'Španija');

-- JE_V_JEZIKIH table
INSERT INTO JE_V_JEZIKIH (ID_FILMA, ID_JEZIKA)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

-- JE_ZANRA table
INSERT INTO JE_ZANRA (ID_FILMA, ID_ZANRA)
VALUES
    (1, 2),
    (2, 1),
    (3, 3);

-- PREDSTAVA table
INSERT INTO PREDSTAVA (ID_PREDSTAVE, ID_FILMA, ID_DVORANE, DATUM, CAS)
VALUES
    (1, 1, 1, '2023-12-24', '19:00:00'),
    (2, 2, 3, '2023-12-25', '17:30:00'),
    (3, 3, 2, '2023-12-26', '20:15:00');

-- SEDEZ table
INSERT INTO SEDEZ (ID_SEDEZA, ID_DVORANE, VRSTA, STEVILKA_SEDEZA, VIP, AKTIVEN)
VALUES
    (1, 1, 1, 101, TRUE, TRUE),
    (2, 1, 2, 102, FALSE, TRUE),
    (3, 2, 1, 201, TRUE, TRUE);
    
-- KARTA table
INSERT INTO KARTA (ID_PREDSTAVE, ID_SEDEZA, CENA)
VALUES
    (1, 1, 10.50),
    (2, 2, 8.75),
    (3, 3, 12.00);

-- VLOGA table
INSERT INTO VLOGA (ID_VLOGE, ID_FILMA, IME_LIKA, OPIS_VLOGE)
VALUES
    (1, 1, 'Glavni lik 1', 'Opis glavnega lika 1'),
    (2, 2, 'Glavni lik 2', 'Opis glavnega lika 2'),
    (3, 3, 'Glavni lik 3', 'Opis glavnega lika 3');

-- VLOGO_IGRA_JO_ table
INSERT INTO VLOGO_IGRA_JO_ (ID_VLOGE, ID_OSEBE)
VALUES
    (1, 1),
    (2, 1),
    (3, 1);
