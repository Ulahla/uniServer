/*==============================================================*/
/* Database name:  SPORT                                        */
/* DBMS name:      Sybase AS Anywhere 8                         */
/* Created on:     19.11.2004 10:53:18                          */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_STRAFEN_VERHAENGT_SPIELER') then
    alter table STRAFEN
       delete foreign key FK_STRAFEN_VERHAENGT_SPIELER
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_TEAMS_KAPITAEN_SPIELER') then
    alter table TEAMS
       delete foreign key FK_TEAMS_KAPITAEN_SPIELER
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_WETTKAEM_WETTKAEMP_SPIELER') then
    alter table WETTKAEMPFE
       delete foreign key FK_WETTKAEM_WETTKAEMP_SPIELER
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_WETTKAEM_WETTKAEMP_TEAMS') then
    alter table WETTKAEMPFE
       delete foreign key FK_WETTKAEM_WETTKAEMP_TEAMS
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='SPIELER_PK'
     and t.table_name='SPIELER'
) then
   drop index SPIELER.SPIELER_PK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='STRAFEN_PK'
     and t.table_name='STRAFEN'
) then
   drop index STRAFEN.STRAFEN_PK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='VERHAENGTE_STRAFEN_FK'
     and t.table_name='STRAFEN'
) then
   drop index STRAFEN.VERHAENGTE_STRAFEN_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='KAPITAEN_FK'
     and t.table_name='TEAMS'
) then
   drop index TEAMS.KAPITAEN_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='TEAMS_PK'
     and t.table_name='TEAMS'
) then
   drop index TEAMS.TEAMS_PK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='WETTKAEMPFE_JE_SPIELER_FK'
     and t.table_name='WETTKAEMPFE'
) then
   drop index WETTKAEMPFE.WETTKAEMPFE_JE_SPIELER_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='WETTKAEMPFE_JE_TEAM_FK'
     and t.table_name='WETTKAEMPFE'
) then
   drop index WETTKAEMPFE.WETTKAEMPFE_JE_TEAM_FK
end if;

if exists(
   select 1 from sys.systable 
   where table_name='SPIELER'
     and table_type='BASE'
) then
    drop table SPIELER
end if;

if exists(
   select 1 from sys.systable 
   where table_name='STRAFEN'
     and table_type='BASE'
) then
    drop table STRAFEN
end if;

if exists(
   select 1 from sys.systable 
   where table_name='TEAMS'
     and table_type='BASE'
) then
    drop table TEAMS
end if;

if exists(
   select 1 from sys.systable 
   where table_name='WETTKAEMPFE'
     and table_type='BASE'
) then
    drop table WETTKAEMPFE
end if;

if exists(select 1 from sys.sysusertype where type_name='D_0_BIS_999') then
   drop datatype D_0_BIS_999
end if;

if exists(select 1 from sys.sysusertype where type_name='D_1_BIS_999') then
   drop datatype D_1_BIS_999
end if;

if exists(select 1 from sys.sysusertype where type_name='D_GEBURTSJAHR') then
   drop datatype D_GEBURTSJAHR
end if;

if exists(select 1 from sys.sysusertype where type_name='D_GESCHLECHT') then
   drop datatype D_GESCHLECHT
end if;

if exists(select 1 from sys.sysusertype where type_name='D_LIGA') then
   drop datatype D_LIGA
end if;

if exists(select 1 from sys.sysusertype where type_name='D_TITEL') then
   drop datatype D_TITEL
end if;

/*==============================================================*/
/* Domain: D_0_BIS_999                                          */
/*==============================================================*/
create domain D_0_BIS_999 as smallint
     check (@column is null or (@column between 0 and 999 ));

/*==============================================================*/
/* Domain: D_1_BIS_999                                          */
/*==============================================================*/
create domain D_1_BIS_999 as smallint
     check (@column is null or (@column between 1 and 999 ));

/*==============================================================*/
/* Domain: D_GEBURTSJAHR                                        */
/*==============================================================*/
create domain D_GEBURTSJAHR as smallint
     check (@column is null or (@column >= 1900 ));

/*==============================================================*/
/* Domain: D_GESCHLECHT                                         */
/*==============================================================*/
create domain D_GESCHLECHT as char(1)
     check (@column is null or ( @column in ('M','W') ));

/*==============================================================*/
/* Domain: D_LIGA                                               */
/*==============================================================*/
create domain D_LIGA as char(6) default 'zweite'
     check (@column is null or ( @column in ('erste','zweite','dritte') ));

/*==============================================================*/
/* Domain: D_TITEL                                              */
/*==============================================================*/
create domain D_TITEL as char(3)
     check (@column is null or ( @column in ('von','Dr.','   ') ));

/*==============================================================*/
/* Table: SPIELER                                               */
/*==============================================================*/
create table SPIELER 
(
    SPIELERNR            D_1_BIS_999                    not null,
    NAME                 char(15)                       not null,
    VORNAMEN             char(4),
    TITEL                D_TITEL,
    GEB_JAHR             D_GEBURTSJAHR,
    GESCHLECHT           D_GESCHLECHT,
    JAHRBEI              smallint                      
         check (JAHRBEI is null or (JAHRBEI >= 1970 )),
    STRASSE              char(15)                       not null default 'Treskowallee',
    HAUSNR               char(4)                        default '  8',
    PLZ                  integer                        default 10313
         check (PLZ is null or (PLZ between 00100 and 99999 )),
    ORT                  char(12)                       not null default 'Berlin',
    TELEFON              char(12),
    VERB_NR              integer                        default 3600
         check (VERB_NR is null or (VERB_NR between 1012 and 8900 )),
    primary key (SPIELERNR)
);

/*==============================================================*/
/* Index: SPIELER_PK                                            */
/*==============================================================*/
create unique index SPIELER_PK on SPIELER (
SPIELERNR ASC
);

/*==============================================================*/
/* Table: STRAFEN                                               */
/*==============================================================*/
create table STRAFEN 
(
    ZAHLUNGSNR           D_1_BIS_999                    not null,
    SPIELERNR            D_1_BIS_999                    not null,
    DATUM                date,
    BETRAG               numeric(6,2)                   not null
         check (BETRAG between 1 and 999),
    primary key (ZAHLUNGSNR)
);

/*==============================================================*/
/* Index: STRAFEN_PK                                            */
/*==============================================================*/
create unique index STRAFEN_PK on STRAFEN (
ZAHLUNGSNR ASC
);

/*==============================================================*/
/* Index: VERHAENGTE_STRAFEN_FK                                 */
/*==============================================================*/
create  index VERHAENGTE_STRAFEN_FK on STRAFEN (
SPIELERNR ASC
);

/*==============================================================*/
/* Table: TEAMS                                                 */
/*==============================================================*/
create table TEAMS 
(
    TEAMNR               D_1_BIS_999                    not null,
    SPIELERNR            D_1_BIS_999                    not null,
    LIGA                 D_LIGA,
    primary key (TEAMNR)
);

/*==============================================================*/
/* Index: TEAMS_PK                                              */
/*==============================================================*/
create unique index TEAMS_PK on TEAMS (
TEAMNR ASC
);

/*==============================================================*/
/* Index: KAPITAEN_FK                                           */
/*==============================================================*/
create  index KAPITAEN_FK on TEAMS (
SPIELERNR ASC
);

/*==============================================================*/
/* Table: WETTKAEMPFE                                           */
/*==============================================================*/
create table WETTKAEMPFE 
(
    TEAMNR               D_1_BIS_999                    not null,
    SPIELERNR            D_1_BIS_999                    not null,
    GEWONNEN             D_0_BIS_999                    not null,
    VERLOREN             D_0_BIS_999                    not null
);

/*==============================================================*/
/* Index: WETTKAEMPFE_JE_SPIELER_FK                             */
/*==============================================================*/
create  index WETTKAEMPFE_JE_SPIELER_FK on WETTKAEMPFE (
SPIELERNR ASC
);

/*==============================================================*/
/* Index: WETTKAEMPFE_JE_TEAM_FK                                */
/*==============================================================*/
create  index WETTKAEMPFE_JE_TEAM_FK on WETTKAEMPFE (
TEAMNR ASC
);

alter table STRAFEN
   add foreign key FK_STRAFEN_VERHAENGT_SPIELER (SPIELERNR)
      references SPIELER (SPIELERNR)
      on update restrict
      on delete restrict;

alter table TEAMS
   add foreign key FK_TEAMS_KAPITAEN_SPIELER (SPIELERNR)
      references SPIELER (SPIELERNR)
      on update restrict
      on delete restrict;

alter table WETTKAEMPFE
   add foreign key FK_WETTKAEM_WETTKAEMP_SPIELER (SPIELERNR)
      references SPIELER (SPIELERNR)
      on update restrict
      on delete restrict;

alter table WETTKAEMPFE
   add foreign key FK_WETTKAEM_WETTKAEMP_TEAMS (TEAMNR)
      references TEAMS (TEAMNR)
      on update restrict
      on delete restrict;



-- ============================================================
-- ============================================================
--   Ergaenzungen zum generierten SQL-Quelltext
-- ============================================================
-- ============================================================



-- ============================================================
--   Sichten:  	1.) selbstdefinierte Tabellen
--		2.) Spalten in selbstdefinierten Tabellen
-- ============================================================
/* Sichtdefinitionen entsprechen ANYWHERE 8 */
create view meine_tab as
    (select table_id, table_name
     from systable, sysusers
     where creator = uid
       and name = user		/* USER ist eine Systemfunktion */
       and table_type='BASE');


create view meine_col as
(select table_name, column_name, pkey, nulls, domain_name, width, scale
from syscolumn , sysdomain, systable
 where  syscolumn.domain_id = sysdomain.domain_id   
     and  syscolumn.table_id      = systable.table_id 
     and  systable.table_id in 
				(select table_id
     				from meine_tab));


/* alte Sichtdefinitionen entsprechend ANYWHERE 5.5 
create view meine_tab as
    (select table_id, table_name
     from systable
     where table_id>160
       and table_type='BASE')


create view meine_col as
(select table_name, column_name, pkey, nulls, domain_name, width, scale
from syscolumn , sysdomain, systable
 where  syscolumn.domain_id = sysdomain.domain_id   
     and  syscolumn.table_id      = systable.table_id 
     and  systable.table_id>160 
     and  systable.table_type = 'BASE')*/
-- ============================================================
--   Tupel einfuegen   (zuerst in Tabelle Spieler,
--                      wegen referentieller Integritaet)
-- ============================================================

insert spieler values(
6, 'Peters', 'R', '   ', 1964, 'M', 1977, 'Hafenallee', '80',
4000, 'Duesseldorf', '0211-476537', 8467
)

insert spieler values(
44, 'Baecker', 'E', 'Dr.', 1963, 'M', 1980, 'Lichtstraﬂe', '23',
4030, 'Ratingen', '02102-36875', 1124
)

insert spieler values(
83, 'Hofmann', 'PK', '   ', 1956, 'M', 1982, 'Marienufer', '16A',
4000, 'Duesseldorf', '0211-353548', 1608
)

insert spieler values(
2, 'Elfers', 'R', '   ', 1948, 'M', 1975, 'Stadtring', '43',
4000, 'Duesseldorf', '0211-237893', 2411
)

insert spieler values(
27, 'Kohl', 'DD', '   ', 1964, 'W', 1983, 'Luisenpfad', '804',
4005, 'Meerbusch', '02105-23485', 2513
)

insert spieler values(
104, 'Maurer', 'D', '   ', 1970, 'W', 1984, 'Stutenallee', '65',
4005, 'Meerbusch', '02105-98757', 7060
)

insert spieler values(
7, 'Wiegand', 'GWS', '   ', 1963, 'M', 1981, 'Erasmusweg', '39',
4000, 'Duesseldorf', '0211-347689', NULL
)

insert spieler values(
57, 'Boehmen', 'M', 'von', 1971, 'M', 1985, 'Erasmusweg', '16',
4000, 'Duesseldorf', '0211-473458', 6409
)

insert spieler values(
39, 'Bischof', 'D', '   ', 1956, 'M', 1980, 'Erikaplatz', '78',
4000, 'Duesseldorf', '0211-393435', NULL
)

insert spieler values(
112, 'Bauer', 'IP', 'von', 1963, 'W', 1984, 'Fuchsweg', '8',
4150, 'Krefeld', '02151-54874', 1319
)

insert spieler values(
8, 'Neuhaus', 'B', '   ', 1962, 'W', 1980, 'Sporenallee', '4',
4030, 'Ratingen', '02102-45845', 2983
)

insert spieler values(
100, 'Peters', 'P', '   ', 1963, 'M', 1979, 'Hafenallee', '80',
4000, 'Duesseldorf', '0211-494593', 6524
)

insert spieler values(
28, 'Kohl', 'C', '   ', 1963, 'W', 1983, 'Domplatz', '10',
4040, 'Neuss', '02101-65959', NULL
)

insert spieler values(
95, 'Mueller', 'P', '   ', 1934, 'M', 1972, 'Hauptweg', '33A',
4010, 'Hilden', '02103-86756', NULL
)


-- ============================================================


insert strafen values(
1, 6, '80/12/08', 100
)

insert strafen values(
2, 44, '81/05/05', 75
)

insert strafen values(
3, 27, '83/09/10', 100
)

insert strafen values(
4, 104, '84/12/08', 50
)

insert strafen values(
5, 44, '80/12/08', 25
)

insert strafen values(
6, 8, '80/12/08', 25
)

insert strafen values(
7, 44, '82/12/30', 30
)

insert strafen values(
8, 27, '84/11/12', 75
)


-- ============================================================


insert teams values(
1, 6, 'erste'
)

insert teams values(
2, 27, 'zweite'
)


-- ============================================================


insert wettkaempfe values(
1, 44, 7, 5
)

insert wettkaempfe values(
1, 83, 3, 3
)

insert wettkaempfe values(
1, 2, 4, 8
)

insert wettkaempfe values(
1, 57, 5, 0
)

insert wettkaempfe values(
1, 8, 0, 1
)

insert wettkaempfe values(
2, 27, 11, 2
)

insert wettkaempfe values(
2, 104, 8, 4
)

insert wettkaempfe values(
2, 112, 4, 8
)

insert wettkaempfe values(
2, 8, 4, 4
)

insert wettkaempfe values(
1, 6, 9, 1
)

