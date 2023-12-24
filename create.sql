/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     23/12/2023 10:40:35                          */
/*==============================================================*/


drop table if exists DVORANA;

drop table if exists FILM;

drop table if exists IGRALEC;

drop table if exists IMA_REZISERJA;

drop table if exists JEZIK;

drop table if exists JE_V_JEZIKIH;

drop table if exists JE_ZANRA;

drop table if exists KARTA;

drop table if exists OSEBA;

drop table if exists PREDSTAVA;

drop table if exists REZISER;

drop table if exists SEDEZ;

drop table if exists VLOGA;

drop table if exists VLOGO_IGRA_JO_;

drop table if exists ZANR;

/*==============================================================*/
/* Table: DVORANA                                               */
/*==============================================================*/
create table DVORANA
(
   ID_DVORANE           int not null,
   IME_DVORANE          varchar(55) not null,
   KAPACITETA           int not null,
   AKTIVNA_KAPACITETA   int,
   primary key (ID_DVORANE)
);

/*==============================================================*/
/* Table: FILM                                                  */
/*==============================================================*/
create table FILM
(
   ID_FILMA             int not null,
   NASLOV               varchar(55) not null,
   LETO_IZDAJE          int not null,
   DOLZINA              time,
   OCENA                decimal,
   primary key (ID_FILMA)
);

/*==============================================================*/
/* Table: IGRALEC                                               */
/*==============================================================*/
create table IGRALEC
(
   ID_OSEBE             int not null,
   STEVILO_ODIGRANIH_FILMOV int not null,
   primary key (ID_OSEBE)
);

/*==============================================================*/
/* Table: IMA_REZISERJA                                         */
/*==============================================================*/
create table IMA_REZISERJA
(
   ID_FILMA             int not null,
   ID_OSEBE             int not null,
   primary key (ID_FILMA, ID_OSEBE)
);

/*==============================================================*/
/* Table: JEZIK                                                 */
/*==============================================================*/
create table JEZIK
(
   ID_JEZIKA            int not null,
   IME_JEZIKA           varchar(55) not null,
   DRZAVA_IZVORA        varchar(55),
   primary key (ID_JEZIKA)
);

/*==============================================================*/
/* Table: JE_V_JEZIKIH                                          */
/*==============================================================*/
create table JE_V_JEZIKIH
(
   ID_FILMA             int not null,
   ID_JEZIKA            int not null,
   primary key (ID_FILMA, ID_JEZIKA)
);

/*==============================================================*/
/* Table: JE_ZANRA                                              */
/*==============================================================*/
create table JE_ZANRA
(
   ID_FILMA             int not null,
   ID_ZANRA             int not null,
   primary key (ID_FILMA, ID_ZANRA)
);

/*==============================================================*/
/* Table: KARTA                                                 */
/*==============================================================*/
create table KARTA
(
   ID_PREDSTAVE         int not null,
   ID_SEDEZA            int not null,
   CENA                 float not null,
   primary key (ID_PREDSTAVE, ID_SEDEZA)
);

/*==============================================================*/
/* Table: OSEBA                                                 */
/*==============================================================*/
create table OSEBA
(
   ID_OSEBE             int not null,
   IME                  varchar(55) not null,
   PRIIMEK              varchar(55) not null,
   SPOL                 char(1) not null,
   DATUM_ROJSTVA        date not null,
   primary key (ID_OSEBE)
);

/*==============================================================*/
/* Table: PREDSTAVA                                             */
/*==============================================================*/
create table PREDSTAVA
(
   ID_PREDSTAVE         int not null,
   ID_FILMA             int not null,
   ID_DVORANE           int not null,
   DATUM                date not null,
   CAS                  time not null,
   primary key (ID_PREDSTAVE)
);

/*==============================================================*/
/* Table: REZISER                                               */
/*==============================================================*/
create table REZISER
(
   ID_OSEBE             int not null,
   STEVILO_REZIRANIH_FILMOV int not null,
   primary key (ID_OSEBE)
);

/*==============================================================*/
/* Table: SEDEZ                                                 */
/*==============================================================*/
create table SEDEZ
(
   ID_SEDEZA            int not null,
   ID_DVORANE           int not null,
   VRSTA                int not null,
   STEVILKA_SEDEZA      int not null,
   VIP                  bool not null,
   AKTIVEN              bool not null,
   primary key (ID_SEDEZA)
);

/*==============================================================*/
/* Table: VLOGA                                                 */
/*==============================================================*/
create table VLOGA
(
   ID_VLOGE             int not null,
   ID_FILMA             int not null,
   IME_LIKA             varchar(55) not null,
   OPIS_VLOGE           varchar(55),
   primary key (ID_VLOGE)
);

/*==============================================================*/
/* Table: VLOGO_IGRA_JO_                                        */
/*==============================================================*/
create table VLOGO_IGRA_JO_
(
   ID_VLOGE             int not null,
   ID_OSEBE             int not null,
   primary key (ID_VLOGE, ID_OSEBE)
);

/*==============================================================*/
/* Table: ZANR                                                  */
/*==============================================================*/
create table ZANR
(
   ID_ZANRA             int not null,
   IME                  varchar(55) not null,
   OPIS_ZANRA           varchar(55),
   primary key (ID_ZANRA)
);

alter table IGRALEC add constraint FK_VLOGA_PRI_FILMU foreign key (ID_OSEBE)
      references OSEBA (ID_OSEBE) on delete restrict on update restrict;

alter table IMA_REZISERJA add constraint FK_IMA_REZISERJA foreign key (ID_FILMA)
      references FILM (ID_FILMA) on delete restrict on update restrict;

alter table IMA_REZISERJA add constraint FK_IMA_REZISERJA2 foreign key (ID_OSEBE)
      references REZISER (ID_OSEBE) on delete restrict on update restrict;

alter table JE_V_JEZIKIH add constraint FK_JE_V_JEZIKIH foreign key (ID_FILMA)
      references FILM (ID_FILMA) on delete restrict on update restrict;

alter table JE_V_JEZIKIH add constraint FK_JE_V_JEZIKIH2 foreign key (ID_JEZIKA)
      references JEZIK (ID_JEZIKA) on delete restrict on update restrict;

alter table JE_ZANRA add constraint FK_JE_ZANRA foreign key (ID_FILMA)
      references FILM (ID_FILMA) on delete restrict on update restrict;

alter table JE_ZANRA add constraint FK_JE_ZANRA2 foreign key (ID_ZANRA)
      references ZANR (ID_ZANRA) on delete restrict on update restrict;

alter table KARTA add constraint FK_ZA_PREDSTAVO foreign key (ID_PREDSTAVE)
      references PREDSTAVA (ID_PREDSTAVE) on delete restrict on update restrict;

alter table KARTA add constraint FK_ZA_SEDEZ foreign key (ID_SEDEZA)
      references SEDEZ (ID_SEDEZA) on delete restrict on update restrict;

alter table PREDSTAVA add constraint FK_IMA_PREDSTAVO foreign key (ID_FILMA)
      references FILM (ID_FILMA) on delete restrict on update restrict;

alter table PREDSTAVA add constraint FK_SE_PREDVAJA_V foreign key (ID_DVORANE)
      references DVORANA (ID_DVORANE) on delete restrict on update restrict;

alter table REZISER add constraint FK_VLOGA_PRI_FILMU2 foreign key (ID_OSEBE)
      references OSEBA (ID_OSEBE) on delete restrict on update restrict;

alter table SEDEZ add constraint FK_IMA_SEDEZ foreign key (ID_DVORANE)
      references DVORANA (ID_DVORANE) on delete restrict on update restrict;

alter table VLOGA add constraint FK_IMA_VLOGE foreign key (ID_FILMA)
      references FILM (ID_FILMA) on delete restrict on update restrict;

alter table VLOGO_IGRA_JO_ add constraint FK_VLOGO_IGRA_JO_ foreign key (ID_VLOGE)
      references VLOGA (ID_VLOGE) on delete restrict on update restrict;

alter table VLOGO_IGRA_JO_ add constraint FK_VLOGO_IGRA_JO_2 foreign key (ID_OSEBE)
      references IGRALEC (ID_OSEBE) on delete restrict on update restrict;

