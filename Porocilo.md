# Porocilo

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
Gašper prosim preverij transakcije, ki si jih napisal.

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
Gašper prosim lepo.

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