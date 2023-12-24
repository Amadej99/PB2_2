# Porocilo

## Podatkovne baze 2
## Druga domača naloga

### Amadej Milićev
### Gašper Rifel

## K2

### K2.1
Pri konceptualnem modelu sva upoštevala komentarje, prav tako pa sva samoiniciativno spremenila nekaj stvari.

- Popravila sva kardinalnosti pri relaciji Karta - Sedež
- Popravila sva kardinalnosti pri relaciji Film - Vloga
- Dodala sva atribute entitetam Vloga, Jezik ter Žanr
- Odstranila sva entiteto Ocena
- Sedežu sva dodala atribut aktiven.
- Dvorani sva dodala atribut aktivna kapaciteta.
- Odstranila sva relacijo med karto in dvorano.
- Popravila sva kardinalnosti pri relaciji Film, Predstava.
- Popravila sva kardinalnosti pri relaciji Sedež, Dvorana.

Logičnega modela ni bilo potrebno popravljati, saj naš konceptualni model ne vsebuje nobene 1:1 povezave. Če bi bilo to potrebno bi glede na kardinalnost izbrali atribut, ki lahko obstaja brez drugega in mu določili dominantno vlogo v relaciji.

### K2.2
| **Entiteta**           | **Funkcionalne Odvisnosti**                                   |
|----------------------|--------------------------------------------------------------|
| DVORANA              | ID_DVORANE -> IME_DVORANE, KAPACITETA, AKTIVNA_KAPACITETA    |
| FILM                 | ID_FILMA -> NASLOV, LETO_IZDAJE, DOLZINA                     |
| IGRALEC              | ID_OSEBE -> STEVILO_ODIGRANIH_FILMOV                          |
| JEZIK                | ID_JEZIKA -> IME_JEZIKA, DRZAVA_IZVORA                       |
| KARTA                | (ID_PREDSTAVE, ID_SEDEZA) -> CENA                             |
| OSEBA                | ID_OSEBE -> IME, PRIIMEK, SPOL, DATUM_ROJSTVA                |
| PREDSTAVA            | ID_PREDSTAVE -> ID_FILMA, ID_DVORANE, DATUM, CAS              |
| REZISER              | ID_OSEBE -> STEVILO_REZIRANIH_FILMOV                          |
| SEDEZ                | ID_SEDEZA -> ID_DVORANE, VRSTA, STEVILKA_SEDEZA, VIP, AKTIVEN |
| VLOGA                | ID_VLOGE -> ID_FILMA, IME_LIKA, OPIS_VLOGE                   |
| ZANR                 | ID_ZANRA -> IME, OPIS_ZANRA                                   |

S pregledom dobljenih relacijskih shem in določitvijo funkcionalnih odvisnosti sva ugotovila, da je najin logični model že ustrezno v tretji normalni
obliki, saj se nikjer ne pojavljajo tranzitivne oziroma parcialne odvisnosti
(hkrati pa nimava večvrednostnih atributov, primarni ključi pa so tudi ustrezno določeni).


### K2.3
Preverila sva, če najin model zdrži vseh 10 transakcij, ki sva jih podala v opisu domene v prvi domači nalogi, ter ugotovila, da se nikjer ne pojavi težava in je vse transakcije možno uspešno opraviti.

### K2.4
Preverila sva, da so imeli vsi atributi nastavljene ustrezne obveznosti, prav tako sva preverila domene. Ker MySQL 5 podpira vse uporabljene tipe, s tem ni bilo težav. Vsak uporabljen podatkovni tip (Integer, Float, Boolean, VarChar, Date, Time) se je lepo preslikal v enak podatkovni tip. Prav tako so bile ustrezne števnosti. 

Referencialno integriteto preverim z neveljavnim režiserja (napačen ID Oseba).

```sql
INSERT INTO REZISER (ID_OSEBE, STEVILO_REZIRANIH_FILMOV)
VALUES
    (4, 10);
```
Ker imamo v bazi le osebe z IDji 1-3, se sproži napaka.

```
Cannot add or update a child row: a foreign key constraint fails (`kino`.`REZISER`, CONSTRAINT `FK_VLOGA_PRI_FILMU2` FOREIGN KEY (`ID_OSEBE`) REFERENCES `OSEBA` (`ID_OSEBE`))
1 statement failed.
```


## K3

### K3.1
Skripto sva kreirala za podatkovno bazo MySQL 5. To sva lokalno namestila s pomočjo Dockerja. Narekovajev ni bilo potrebno popravljati.

### K3.2
Odločila sva se, da bova dodala stolpec, ki bo preštel vse aktivne sedeže in s tem beležil realno kapaciteto dvorane. Stolpec se sicer doda že ob kreaciji baze vendar je označen kot neobvezen. Kasneje se ga posodobi z naslednjim ukazom.

```sql
UPDATE DVORANA
SET AKTIVNA_KAPACITETA = (SELECT COUNT(*) FROM SEDEZ WHERE SEDEZ.ID_DVORANE = DVORANA.ID_DVORANE AND SEDEZ.AKTIVEN = 1);
```

To je smiselno, saj potrebujemo ob planiranju vsake predstave vedeti točno koliko sedežev imamo na voljo. Sedeže je potrebno obnavljati, saj se obrabljajo. Prav tako bova dodala sprožilec, ki bo ob "deaktiviranju" nekega sedeža ponovno preštel število sedežev v dvorani, kjer se deaktivirani sedež nahaja.

### K3.3
```sql
CREATE TRIGGER update_active_seat AFTER UPDATE ON SEDEZ FOR EACH ROW
UPDATE DVORANA SET AKTIVNA_KAPACITETA = 
(SELECT COUNT(*) FROM SEDEZ WHERE ID_DVORANE = DVORANA.ID_DVORANE AND AKTIVEN = 1)
```

Ustvarila sva prožilec, ki prešteje in posodobi število aktivnih sedežev v dvorani ob spremembi statusa aktivnosti na sedežu v isti dvorani.

### K4

#### 1
Vnašanje podatkov filma, mu izberemo žanr ter jezik (tej so predhodno že vneseni v tabelo), ter vnesemo še igralce, njihove vloge in režiserje za ta film. To se zgodi nekaj časa pred začetkom predvajanja tega filma.

```sql
INSERT INTO FILM VALUES(4,'Film 4', 2001, '1:35:00', 7);
INSERT INTO JE_ZANRA VALUES(4,2),(4,3);
INSERT INTO IMA_REZISERJA VALUES(4,2);
INSERT INTO JE_V_JEZIKIH VALUES(4,1),(4,3);
```

#### 2
Ko se 1 mesec izteče ali ko ni več prometa za nek film, se iz podatkovne baze odstranijo vse predstave s vezane na ta film. Film, režiser, igralci in ostalo pa ostane v podatkovni bazi, saj morajo naslov ter opis filma biti na voljo za ogled preteklih filmov, ki so bili predvajani.

```sql
DELETE FROM PREDSTAVA
WHERE DATEDIFF(NOW(), DATUM) > 30;
```

#### 3
Če se nekaj sedežev v dvorani uniči, ali pa je potrebno zapreti vrsto sedežev, moramo tiste sedeže odstraniti iz možnih izbir za uporabnike.

```sql
UPDATE SEDEZ
   SET AKTIVEN = FALSE
WHERE STEVILKA_SEDEZA = 102 
AND   STEVILKA_SEDEZA = 101;
```
#### 4
Vnesemo izvajanje novih predstav, dodelimo jim identifikatorje, jim podelimo datum in čas izvajanja ter izberemo dvorane v katerih se bodo te predstave predvajale. V podatkovni bazi morajo biti vrste dvoran ter njihove lastnosti kot so sedeži ter kapaciteta že vneseni.

```sql
INSERT INTO PREDSTAVA VALUES(4,3,1,'2024-01-06','18:00:00');
```

#### 5
Preštevanje število filmov, ki so bili na voljo do zdaj.

```sql
SELECT COUNT(*) FROM FILM;
```
#### 6
Filmu se je spremenila ocena, tako da moramo spremeniti oceno, vendar ohraniti vse ostale informacije.

```sql
UPDATE FILM SET OCENA = 5 WHERE ID_FILMA=4;
```
#### 7
Izpis vseh izdanih kart.

```sql
SELECT f.Naslov, p.Datum, p.Cas,d.Ime_dvorane, s.Vrsta, s.Stevilka_sedeza, k.Cena  FROM KARTA k
JOIN PREDSTAVA p ON k.ID_predstave = p.ID_predstave
JOIN SEDEZ s ON k.ID_sedeza = s.ID_sedeza
JOIN FILM f ON p.ID_filma = f.ID_filma
JOIN DVORANA d ON s.ID_dvorane = d.ID_dvorane;
```
#### 8 
Preštevanje koliko filmov je bilo za vsak jezik. 

```sql
SELECT j.ime_jezika, count(*) as Stevilo_FIlmov FROM FILM f
JOIN JE_V_JEZIKIH je ON f.ID_filma = je.ID_filma
JOIN JEZIK j ON je.ID_jezika = j.ID_jezika
GROUP BY j.ime_jezika;
```
#### 9
Izpis število kart za vsak film, urejen padajoče, s tem vidimo kateri filmi so prinesli največ obiska in profita.

```sql
SELECT f.Naslov, count(*) as 'Stevilo prodanih kart' FROM FILM f
JOIN PREDSTAVA p ON f.ID_filma = p.ID_filma
JOIN KARTA k ON p.ID_predstave = k.ID_predstave
GROUP BY 1
ORDER BY 2 DESC;
```
#### 10
Izpis aktivnih predvajanih predstavitev, njihovih datumov, časov, ter zraven še lastnosti filma (žanr, jezik) ter dvorane, v katerih bodo ta predvajanja predvajana.

```sql
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
```

Za analizo transakcij sva izdelala matriko transakcija/relacija, ki nam prikazuje vse relacije, katere se uporabljajo pri najinih transakcijah.   

|   | FILM | ZANR | REZISER | JEZIK | DVORANA | SEDEZ | VLOGA | PREDSTAVA | KARTA | OSEBA |
|---|------|------|---------|------|---------|-------|-------|-----------|-------|-------|
| 1 |  I   |  I   |   I     |   I  |    -    |   -   |   -   |     -     |   -   |   -   |
| 2 |  D   |   -  |   -     |   -  |    -    |   -   |   -   |     D     |   -   |   -   |
| 3 |  U   |   -  |   U     |   -  |    -    |   U   |   -   |     -     |   -   |   U   |
| 4 |  I   |   -  |   -     |   -  |    -    |   -   |   -   |     I     |   -   |   -   |
| 5 |  S   |   -  |   -     |   -  |    -    |   -   |   -   |     -     |   -   |   -   |
| 6 |  U   |   -  |   -     |   -  |    -    |   -   |   -   |     -     |   -   |   -   |
| 7 |  S   |   -  |   -     |   -  |    S    |   S   |   -   |     S     |   S   |   -   |
| 8 |  S   |   -  |   -     |   S  |    S    |   S   |   -   |     S     |   -   |   -   |
| 9 |  S   |   -  |   -     |   -  |    -    |   -   |   -   |     S     |   S   |   -   |
|10 |  S   |   -  |   -     |   S  |    S    |   -   |   -   |     S     |   S   |   -   |

Na podlagi te matrike, sva se odločila za sekundarno indeksiranje pri tabelah:

```sql
CREATE INDEX idx_id_filma_datum ON PREDSTAVA (ID_FILMA, DATUM);
```
PREDSTAVA, saj omogoča učinkovito iskanje predstav na določen datum.

```sql
CREATE INDEX idx_id_predstave ON KARTA (ID_PREDSTAVE);
```
KARTA, saj omogoča učinkovito iskanje kart glede na pripadajočo predstavo.


```sql
CREATE INDEX idx_id_filma_jezik ON JE_V_JEZIKIH (ID_FILMA);
```
JE_V_JEZIKIH, saj omogoča hitrejšo in optimizirano iskanje filmov glede na njihov uporabljen jezik.

```sql
CREATE INDEX idx_id_filma_zanr ON JE_ZANRA (ID_FILMA);
```
JE_ZANRA, saj omogoča hitrejšo in optimizirano iskanje filmov glede na njihove vrsti žanra.

```sql
CREATE INDEX idx_id_filma_igralec ON VLOGO_IGRA_JO_ (ID_FILMA);
```
VLOGE_IGRA_JO, saj omogoča učinkovito iskanje igralcev, ki so sodelovali pri nekem filmu.


### K5
Ustvarila sva pogled, ki izpiše vse španske filme.

```sql
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
```

Ustvarila sva pogled, ki izpiše vse komedije.

```sql
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
```