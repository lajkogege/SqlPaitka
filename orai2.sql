-- normalizálás, 
-- szerk. bõv, Patika fh. funkcióira

create database patika

use patika

create table Orvos
(
kód int,
nev varchar(30) not null,
szak char(40) not null,
primary key (kód)
)


insert into orvos values (12345, 'dr Méz', 'gyerekorvos')
select * from orvos

insert into orvos values (54321, 'dr Méz', 'gyerekorvos')
insert into orvos values (55555, 'dr Õ', 'szülész-nõgyógyász')

-- fa: a SZK legyen szótárazott... az adatok el ne vesszenek!

create table Szak
(
szak int identity(11,1), -- autoincrement
megnevezés char(40),
primary key (szak)
)

insert into szak
select distinct szak
from orvos

create unique index neves1 on szak (megnevezés)
insert into szak values ('onkológus')

select * from szak
select * from orvos

alter table orvos
add szaKK int

select szak.szak 
from orvos 
	inner join szak on orvos.szak=szak.megnevezés


update orvos
set szakk=(select szak from szak where szak.megnevezés=orvos.szak)
-- ott a KKnak való érték a régi sz.

alter table orvos
drop column szak

-- átnevezhetõ ...
alter table orvos
add foreign key (szakk) references szak (szak) 


select * from szak
select * from orvos

-- ez 1 pl. volt egyéb szerk.változtatási munkára


-- BETEG (taj_szám, név, szül_dátum, lakhely) 

create table beteg
(
tajszám char(9),
név varchar (30),
szül_dátum date,
lakhely varchar(60), --érdemes 3 mezõben tartani
primary key (tajszám)
)

-- VÉNY (azonosító, felírás_kelt, beváltás_kelt, orvos, taj_szám)

create table vény
(
azonosító int,
felírás_kelt date,
beváltás_kelt date,
orvos int,
tajszám char(9)
primary key (azonosító),
foreign key (orvos) references orvos(kód),
foreign key (tajszám) references beteg(tajszám)
)

----------------------------
--2024.09.23
use patika
--FAJTA(fajta,leírás)
create table FAJTA
(
fajta int identity(101,1), --identity: egyedi azonositója lesz a rekordoknak, aut matikusan hozza létre 
leírás char (30),
primary key (fajta),
)

create unique index fajta_egyedi --hogy ne lehessen töbször felvinni hogy pl lázcsilapito. Hozz létre egy egyedi indexet a fajta táblábol a leírás szerint
on fajta(leírás)

insert into fajta values ('lazcsillapitó')

select * from fajta
insert into fajta values ('köptetõ')

select ident_current('fajta')--az utoljára dobott,generált azonosító az adott táblában

--GYÓGYSZER (gyszám, lenevezés, fajta, egys_ár, készlet)
--késöbb lesz: hatóanyag, vényes_e
create table GYÓGYSZER (
gyszám int PRIMARY KEY,
elenevezés  varchar(40) not null, --kötelezõ értéket adni neki
fajta int not null,
vényes_e bit not null,
foreign key(fajta) references fajta(fajta) --Gyógyszer fajta oszlopa kapcsolatban, idegen kulcsa a fajta tábla fajtával
)

create table KISZERELÉS
(
k_azon int identity(1,1),
tartalom char(20),
mennyiség smallint,
mértékegység char(3) not null
)

insert into KISZERELÉS values 
('tabletta', 10, 'db'),
('tabletta', 30, 'db')

select * from KISZERELÉS


--TERMÉK(tkód, gyógyszer, kiszerelés, eár1, eár2, eár3, készlet)
create table TERMÉK
(
tkód int,
gyógyszer int not null ,
kiszerelés int not null,
eár1 money not null,
eár2 money not null,
eár3 money not null,
--készlete nem ennek hanem a lejárattol függõ terméknek lesz
primary key (tkód),
foreign key (gyógyszer) references gyógyszer (gyszám),
--foreign key (kiszerelés) references kiszerelés (k_azon),
check(eár1>=0),
check(eár2>=0),
check(eár3>=0),
--1 csheck is lehetet volna itt zezzel a feltételel: (eáe>0 and eár2>=0 and eár3>=0)

)

select * from termék
select * from gyógyszer
select * from fajta
select * from KISZERELÉS


insert into gyógyszer values (12345, 'Algopyrin', 101, 0);

insert into termék values 
(0102030405, 12345, 1, 2200, 2200, 0)

insert into termék values 
(1020304050, 12345, 2, 4400, 4400, 0)

insert into termék values 
(20405060, 12345, 2, 4400, 4400, -230)
