/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 11                       */
/* Created on:     15.04.2015 13:40:02                          */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_BELEGEN_BELEGEN_STUDENTE') then
    alter table BELEGEN
       delete foreign key FK_BELEGEN_BELEGEN_STUDENTE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_BELEGEN_BELEGEN2_LV') then
    alter table BELEGEN
       delete foreign key FK_BELEGEN_BELEGEN2_LV
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_LV_HALTEN_DOZENTEN') then
    alter table LV
       delete foreign key FK_LV_HALTEN_DOZENTEN
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='BELEGEN2_FK'
     and t.table_name='BELEGEN'
) then
   drop index BELEGEN.BELEGEN2_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='BELEGEN_FK'
     and t.table_name='BELEGEN'
) then
   drop index BELEGEN.BELEGEN_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='BELEGEN_PK'
     and t.table_name='BELEGEN'
) then
   drop index BELEGEN.BELEGEN_PK
end if;

if exists(
   select 1 from sys.systable 
   where table_name='BELEGEN'
     and table_type in ('BASE', 'GBL TEMP')
) then
    drop table BELEGEN
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='DOZENTEN_PK'
     and t.table_name='DOZENTEN'
) then
   drop index DOZENTEN.DOZENTEN_PK
end if;

if exists(
   select 1 from sys.systable 
   where table_name='DOZENTEN'
     and table_type in ('BASE', 'GBL TEMP')
) then
    drop table DOZENTEN
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='HALTEN_FK'
     and t.table_name='LV'
) then
   drop index LV.HALTEN_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='LV_PK'
     and t.table_name='LV'
) then
   drop index LV.LV_PK
end if;

if exists(
   select 1 from sys.systable 
   where table_name='LV'
     and table_type in ('BASE', 'GBL TEMP')
) then
    drop table LV
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='STUDENTEN_PK'
     and t.table_name='STUDENTEN'
) then
   drop index STUDENTEN.STUDENTEN_PK
end if;

if exists(
   select 1 from sys.systable 
   where table_name='STUDENTEN'
     and table_type in ('BASE', 'GBL TEMP')
) then
    drop table STUDENTEN
end if;

/*==============================================================*/
/* Table: BELEGEN                                               */
/*==============================================================*/
create table BELEGEN 
(
   MATNR                char(8)                        not null,
   NR                   integer                        not null,
   constraint PK_BELEGEN primary key clustered (MATNR, NR)
);

/*==============================================================*/
/* Index: BELEGEN_PK                                            */
/*==============================================================*/
create unique clustered index BELEGEN_PK on BELEGEN (
MATNR ASC,
NR ASC
);

/*==============================================================*/
/* Index: BELEGEN_FK                                            */
/*==============================================================*/
create index BELEGEN_FK on BELEGEN (
MATNR ASC
);

/*==============================================================*/
/* Index: BELEGEN2_FK                                           */
/*==============================================================*/
create index BELEGEN2_FK on BELEGEN (
NR ASC
);

/*==============================================================*/
/* Table: DOZENTEN                                              */
/*==============================================================*/
create table DOZENTEN 
(
   DOZNR                integer                        not null default autoincrement,
   NAME                 char(35)                       null,
   VORNAME              char(15)                       null,
   FACH                 char(15)                       null,
   TEL                  char(25)                       null,
   constraint PK_DOZENTEN primary key (DOZNR)
);

/*==============================================================*/
/* Index: DOZENTEN_PK                                           */
/*==============================================================*/
create unique index DOZENTEN_PK on DOZENTEN (
DOZNR ASC
);

/*==============================================================*/
/* Table: LV                                                    */
/*==============================================================*/
create table LV 
(
   NR                   integer                        not null default autoincrement,
   DOZNR                integer                        not null,
   BEZ                  char(30)                       null,
   KBEZ                 char(6)                        null
      constraint CKC_KBEZ_LV check (KBEZ is null or (KBEZ in ('DB','BWL','<Val6>','<Val7>','<Val8>','<Val9>','<Val10>'))),
   UHRZEIT              date                           null,
   RAUM                 char(6)                        null
      constraint CKC_RAUM_LV check (RAUM is null or (RAUM in ('C640','C446','C444','<Val3>'))),
   SG2                  char(4)                        null,
   constraint PK_LV primary key (NR)
);

/*==============================================================*/
/* Index: LV_PK                                                 */
/*==============================================================*/
create unique index LV_PK on LV (
NR ASC
);

/*==============================================================*/
/* Index: HALTEN_FK                                             */
/*==============================================================*/
create index HALTEN_FK on LV (
DOZNR ASC
);

/*==============================================================*/
/* Table: STUDENTEN                                             */
/*==============================================================*/
create table STUDENTEN 
(
   MATNR                char(8)                        not null,
   NAME                 char(35)                       not null,
   VORNAME              char(15)                       null,
   SG                   char(4)                        null,
   GEBDAT               date                           null,
   IMMADAT              date                           null,
   constraint PK_STUDENTEN primary key (MATNR)
);

/*==============================================================*/
/* Index: STUDENTEN_PK                                          */
/*==============================================================*/
create unique index STUDENTEN_PK on STUDENTEN (
MATNR ASC
);

alter table BELEGEN
   add constraint FK_BELEGEN_BELEGEN_STUDENTE foreign key (MATNR)
      references STUDENTEN (MATNR)
      on update restrict
      on delete restrict;

alter table BELEGEN
   add constraint FK_BELEGEN_BELEGEN2_LV foreign key (NR)
      references LV (NR)
      on update restrict
      on delete restrict;

alter table LV
   add constraint FK_LV_HALTEN_DOZENTEN foreign key (DOZNR)
      references DOZENTEN (DOZNR)
      on update restrict
      on delete restrict;

